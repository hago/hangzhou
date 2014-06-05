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
#import "Base64.h"

#define SERVICE_URL "http://76.74.178.94:81/api"

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
    [self httpAccess:url httpMethod:@"GET" httpCookies:cookies requestHeaders:headers httpBody:nil timeout:timeout onSuceess:httpSuccess onFail:httpFail];
}

-(void)httpPost:(NSString *)url httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers httpBody:(NSData *)body timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail
{
    [self httpAccess:url httpMethod:@"POST" httpCookies:cookies requestHeaders:headers httpBody:body timeout:timeout onSuceess:httpSuccess onFail:httpFail];
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
        NSLog(@"set body: %@ %lu", [Utilities __debug_nsdata_as_string:body returnHex:NO], (unsigned long)[body length]);
        [req setHTTPBody:body];
    }
    dispatch_async(dq, ^{
        NSError *error = nil;
        NSURLResponse *rsp = nil;
        NSData *data = nil;
        data = [NSURLConnection sendSynchronousRequest:req returningResponse:&rsp error:&error];
        //error = [NSError errorWithDomain:@"" code:1 userInfo:NULL];
        if (error==nil) {
            NSLog(@"http success %@ %lu", [Utilities __debug_nsdata_as_string:data returnHex:NO], (unsigned long)[data length]);
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

-(void)wuyeRegister:(NSString *)cellno onSuceess:(void (^)(NSInteger code))apiSuccess onFail:(void (^)(NSError *))apiFail
{
    NSString *url = [[[NSString stringWithUTF8String:SERVICE_URL] stringByAppendingString:@"/CustomerType2/CheckCustomerType2/"] stringByAppendingString:cellno];
    [self httpGet:url httpCookies:nil requestHeaders:nil timeout:30 onSuceess:^(NSData *response) {
        NSLog(@"reg success");
        NSError *err = nil;
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            apiFail(err);
            return;
        }
        NSNumber *jcode = [obj objectForKey:@"code"];
        if (jcode==nil) {
            err = [NSError errorWithDomain:@"wuyeRegister" code:-2000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"code not found", @"description", nil]];
            apiFail(err);
            return;
        }
        NSInteger code = [jcode integerValue];
        NSLog(@"clientRegister returned %ld", (long)code);
        switch (code) {
            case 0:
                apiSuccess(0);
                break;
            case -1:
            default:
                err = [NSError errorWithDomain:@"wuyeRegister" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"server return %ld", (long)code], @"description", nil]];
                apiFail(err);
                break;
        }
    } onFail:^(NSError *error) {
        NSLog(@"reg fail");
        apiFail(error);
    }];
}

-(void)registerDeliveryNo:(NSDictionary *)req onSuceess:(void (^)(NSInteger code))apiSuccess onFail:(void (^)(NSError *))apiFail
{
    NSString *url = [[NSString stringWithUTF8String:SERVICE_URL] stringByAppendingString:@"/CustomerType2/CreatePacelCustomer"];
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:req options:0 error:&error];
    if (error!=nil) {
        error = [NSError errorWithDomain:@"invalid request" code:-1 userInfo:nil];
        apiFail(error);
        return;
    }
    [self httpPost:url httpCookies:nil requestHeaders:nil httpBody:body timeout:30 onSuceess:^(NSData *response) {
        NSLog(@"register delivery ok");
        NSLog(@"%@", [Utilities __debug_nsdata_as_string:response returnHex:NO]);
        NSError *err = nil;
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            apiFail(err);
            return;
        }
        NSNumber *jcode = [obj objectForKey:@"code"];
        if (jcode==nil) {
            err = [NSError errorWithDomain:@"wuyeRegister" code:-2000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"code not found", @"description", nil]];
            apiFail(err);
            return;
        }
        NSInteger code = [jcode integerValue];
        NSLog(@"registerDeliveryNo returned %ld", (long)code);
        switch (code) {
            case 0:
                apiSuccess(0);
                break;
            case -1:
            default:
                err = [NSError errorWithDomain:@"wuyeRegister" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"server return %ld", (long)code], @"description", nil]];
                apiFail(err);
                break;
        }
    } onFail:^(NSError *error) {
        NSLog(@"register delivery fail");
        apiFail(error);
    }];
}

-(void)prepareHeader:(NSMutableURLRequest *)req
{
    NSString *basestr = @"zhijian:zhijian";
    NSString *b64str = [basestr base64EncodedString];
    NSString *authstring = [NSString stringWithFormat:@"Basic %@", b64str];
    [req setValue:authstring forHTTPHeaderField:@"Authorization"];
    [req setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
}

@end
