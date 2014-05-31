//
//  ServiceMethods.m
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "ServiceMethods.h"
#import "dispatch/queue.h"
#import "Utilities.h"

#define SERVICE_URL "http://76.74.198.94:81/api"

@interface ServiceMethods ()

-(void)prepareHeader:(NSMutableURLRequest *)req;
-(ServiceMethods *)init;
-(void)httpAccess:(NSString *)url httpMethod:(NSString *)method httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers httpBody:(NSData *)body timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail;

@end

ServiceMethods *instance = nil;

@implementation ServiceMethods

dispatch_queue_t dq;

-(ServiceMethods *)init
{
    ServiceMethods *obj = [super init];
    dq = dispatch_queue_create("ServiceMethods", NULL);
    return obj;
}

+(ServiceMethods *)getInstance
{
    if (instance==nil) {
        instance = [[ServiceMethods alloc] init];
    }
    return instance;
}

-(void)httpGet:(NSString *)url httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail
{
    
}

-(void)httpPost:(NSString *)url httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers httpBody:(NSData *)body timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail
{
    
}

-(void)httpAccess:(NSString *)url httpMethod:(NSString *)method httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers httpBody:(NSData *)body timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail;
{
    NSLog(@"start url %@", url);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [req setTimeoutInterval:timeout];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:headers];
    if (cookies!=nil) {
        // to do
    }
    [req setHTTPMethod:method];
    [req setAllHTTPHeaderFields:dict];
    [self prepareHeader:req];
    if ([[method uppercaseString] isEqualToString:@"POST"] && (body !=nil)) {
        NSLog(@"set body: %@ %d", [Utilities __debug_nsdata_as_string:body returnHex:NO], [body length]);
        [req setHTTPBody:body];
    }
    dispatch_async(dq, ^{
        NSError *error = nil;
        NSURLResponse *rsp = nil;
        NSData *data = nil;
        data = [NSURLConnection sendSynchronousRequest:req returningResponse:&rsp error:&error];
        //error = [NSError errorWithDomain:@"" code:1 userInfo:NULL];
        if (error==nil) {
            NSLog(@"http success %@ %d", [Utilities __debug_nsdata_as_string:data returnHex:NO], [data length]);
            dispatch_async(dispatch_get_main_queue(), ^{
                httpSuccess(data);
            });
        } else {
            NSLog(@"http error %@, %@", [error domain], [error description]);
            dispatch_async(dispatch_get_main_queue(), ^{
                httpFail(error);
            });
        }
    });
}

-(void)wuyeRegister:(NSString *)cellno onSuceess:(void (^)(NSInteger code))regSuccess onFail:(void (^)(NSError *))regFail
{
    NSString *url = [[[NSString stringWithUTF8String:SERVICE_URL] stringByAppendingString:@"/CustomerType2/CheckCustomerType2/"] stringByAppendingString:cellno];
    [self httpGet:url httpCookies:nil requestHeaders:nil timeout:30 onSuceess:^(NSData *response) {
        NSLog(@"reg success");
        char *cstr = (char *)malloc(sizeof(char)*[response length]);
        [response getBytes:(void *)cstr length:[response length]];
        NSString *ret = [[NSString stringWithCString:cstr encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"]];
        free(cstr);
        if ([ret isEqualToString:@"0"]) {
            regSuccess(0);
        } else {
            NSError *error = [NSError errorWithDomain:@"service error code" code:[ret integerValue] userInfo:nil];
            regFail(error);
        }
    } onFail:^(NSError *error) {
        NSLog(@"reg fail");
        regFail(error);
    }];
}

-(void)prepareHeader:(NSMutableURLRequest *)req
{
    [req setValue:@"username" forHTTPHeaderField:@"zhijian"];
    [req setValue:@"password" forHTTPHeaderField:@"zhijian"];
}

@end
