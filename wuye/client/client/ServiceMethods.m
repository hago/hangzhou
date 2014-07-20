//
//  ServiceMethods.m
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceMethods.h"
#import "dispatch/queue.h"
#import "Utilities.h"
#import "Base64.h"
#define  HTTP_TIMEOUT 30
#define SERVICE_URL @"http://122.10.117.234:81/api"
#define CLIENT_VERSION 100

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

-(void)httpAccess:(NSString *)url httpMethod:(NSString *)method httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers httpBody:(NSData *)body timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail
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

-(void)prepareHeader:(NSMutableURLRequest *)req
{
    NSString *basestr = @"zhijian:zhijian";
    NSString *b64str = [basestr base64EncodedString];
    NSString *authstring = [NSString stringWithFormat:@"Basic %@", b64str];
    [req setValue:authstring forHTTPHeaderField:@"Authorization"];
    [req setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
}

-(void)clientRegister:(NSString *)cellno onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail
{
    NSString *url = [SERVICE_URL stringByAppendingString:@"/Customer/CreateCustomer"];
    NSString *fmt = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale systemLocale]];
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    [fmtr setDateFormat:fmt];
    NSDictionary *reqobj = [NSDictionary dictionaryWithObjectsAndKeys:
                            cellno, @"mobile",
                            [[UIDevice currentDevice].identifierForVendor UUIDString], @"deviceinfo",
                            @"0", @"type",
                            [NSNumber numberWithInt:0], @"customerId",
                            @"x", @"username",
                            @"1", @"gender",
                            @"", @"province",
                            @"", @"city",
                            @"", @"district",
                            @"", @"campname",
                            @"", @"campCode",
                            @"", @"bldNumber",
                            @"", @"unitNumber",
                            @"", @"roomNumber",
                            @"", @"communityId",
                            @"", @"validationCode",
                            @"", @"groupName",
                            [fmtr stringFromDate:[NSDate date]], @"validationCodeTime",
                            nil];
    NSError * err = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:reqobj options:0 error:&err];
    if (err!=nil) {
        apiFail(err);
        return;
    }
    //NSString *str = [Utilities __debug_nsdata_as_string:body returnHex:NO];
    //NSLog(@"clientRegister body %@ %d %d", str, [str length], [body length]);
    [self httpPost:url httpCookies:nil requestHeaders:nil httpBody:body timeout:HTTP_TIMEOUT onSuceess:^(NSData *response) {
        NSError * err = nil;
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            apiFail(err);
            return;
        }
        NSNumber *jcode = [obj objectForKey:@"code"];
        if (jcode==nil) {
            err = [NSError errorWithDomain:@"clientRegister" code:-2000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"code not found", @"description", nil]];
            apiFail(err);
            return;
        }
        NSInteger code = [jcode integerValue];
        NSLog(@"clientRegister returned %ld", (long)code);
        switch (code) {
            case 0:
                apiSuccess(obj);
                break;
            case -1:
                //regSuccess(-1);
                //break;
            default:
                err = [NSError errorWithDomain:@"clientRegister" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"server return %ld", (long)code], @"description", nil]];
                apiFail(err);
                break;
        }
    } onFail:^(NSError *error) {
        apiFail(error);
    }];
}

-(void)checkCode:(NSString *)code CellNumber:(NSString *)cellno CustomerId:(NSUInteger)cid onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail;
{
    NSString *url = [SERVICE_URL stringByAppendingString:@"/Customer/CheckCode"];
    NSString *fmt = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale systemLocale]];
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    [fmtr setDateFormat:fmt];
    NSDictionary *reqobj = [NSDictionary dictionaryWithObjectsAndKeys:
                            cellno, @"mobile",
                            [[UIDevice currentDevice].identifierForVendor UUIDString], @"deviceinfo",
                            @"0", @"type",
                            [NSNumber numberWithUnsignedInteger:cid], @"customerId",
                            @"x", @"username",
                            @"1", @"gender",
                            @"", @"province",
                            @"", @"city",
                            @"", @"district",
                            @"", @"campname",
                            @"", @"campCode",
                            @"", @"bldNumber",
                            @"", @"unitNumber",
                            @"", @"roomNumber",
                            @"", @"communityId",
                            @"", @"groupName",
                            code, @"validationCode",
                            [fmtr stringFromDate:[NSDate date]], @"validationCodeTime",
                            nil];
    NSError * err = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:reqobj options:0 error:&err];
    if (err!=nil) {
        apiFail(err);
        return;
    }
    [self httpPost:url httpCookies:nil requestHeaders:nil httpBody:body timeout:HTTP_TIMEOUT onSuceess:^(NSData *response) {
        NSError * err = nil;
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            apiFail(err);
            return;
        }
        NSNumber *jcode = [obj objectForKey:@"code"];
        if (jcode==nil) {
            err = [NSError errorWithDomain:@"clientRegister" code:-2000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"code not found", @"description", nil]];
            apiFail(err);
            return;
        }
        NSInteger code = [jcode integerValue];
        NSLog(@"clientRegister returned %ld", (long)code);
        switch (code) {
            case 0:
                apiSuccess(reqobj);
                break;
            case -1:
                //regSuccess(-1);
                //break;
            default:
                err = [NSError errorWithDomain:@"clientRegister" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"server return %ld", (long)code], @"description", nil]];
                apiFail(err);
                break;
        }
    } onFail:^(NSError *error) {
        apiFail(error);
    }];
}

-(void)unsignedPacels:(NSString *)customerId PageNumber:(NSUInteger)pageno onSuceess:(void (^)(NSArray *))apiSuccess onFail:(void (^)(NSError *))apiFail
{
    NSString *url = [NSString stringWithFormat:@"%@/pacel/Unsigned/%@/%lu", SERVICE_URL, customerId, (unsigned long)pageno];
    [self httpGet:url httpCookies:nil requestHeaders:nil timeout:HTTP_TIMEOUT onSuceess:^(NSData *response) {
        NSLog(@"unsignedPacels success");
        NSError *err = nil;
        NSArray *list = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            NSLog(@"unsignedPacels parse fail %@", [Utilities __debug_nsdata_as_string:response returnHex:NO]);
            apiFail(err);
        }
        apiSuccess(list);
    } onFail:^(NSError *error) {
        NSLog(@"unsignedPacels fail %@", [error description]);
        apiFail(error);
    }];
}

-(void)signedPacels:(NSString *)customerId PageNumber:(NSUInteger)pageno onSuceess:(void (^)(NSArray *))apiSuccess onFail:(void (^)(NSError *))apiFail
{
    NSString *url = [NSString stringWithFormat:@"%@/pacel/Signed/%@/%lu", SERVICE_URL, customerId, (unsigned long)pageno];
    [self httpGet:url httpCookies:nil requestHeaders:nil timeout:HTTP_TIMEOUT onSuceess:^(NSData *response) {
        NSLog(@"signedPacels success");
        NSError *err = nil;
        NSArray *list = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            NSLog(@"signedPacels parse fail %@", [Utilities __debug_nsdata_as_string:response returnHex:NO]);
            apiFail(err);
        }
        apiSuccess(list);
    } onFail:^(NSError *error) {
        NSLog(@"signedPacels fail %@", [error description]);
    }];
}

-(void)getPacel:(NSString *)parcelId onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail
{
    NSString *url = [NSString stringWithFormat:@"%@/pacel/SpecifiedParcel/%@", SERVICE_URL, parcelId];
    [self httpGet:url httpCookies:nil requestHeaders:nil timeout:HTTP_TIMEOUT onSuceess:^(NSData *response) {
        NSLog(@"unsignedPacels success");
        NSError *err = nil;
        NSDictionary *parcel = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            NSLog(@"getPacel parse fail %@", [Utilities __debug_nsdata_as_string:response returnHex:NO]);
            apiFail(err);
        }
        apiSuccess(parcel);
    } onFail:^(NSError *error) {
        NSLog(@"unsignedPacels fail %@", [error description]);
    }];
}

-(void)checkUpgrade:(void (^)())upgradeRequired UpgradeAvailable:(void (^)())upGradeAvailable NoUpgrade:(void (^)())noUpgrade
{
    NSString *url = [NSString stringWithFormat:@"%@/Upgrade/IsUpgradeIOS/%d", SERVICE_URL, CLIENT_VERSION];
    [self httpGet:url httpCookies:nil requestHeaders:nil timeout:HTTP_TIMEOUT onSuceess:^(NSData *response) {
        NSLog(@"upgrade call ok");
        NSError *err = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&err];
        if (err!=nil) {
            NSLog(@"upgrade parse fail %@", [Utilities __debug_nsdata_as_string:response returnHex:NO]);
            noUpgrade();
        }
        NSNumber *num = [dict objectForKey:@"code"];
        NSInteger code = [num integerValue];
        if (code==0) {
            num = [dict objectForKey:@"forceUpgrade"];
            NSInteger forceup = [num integerValue];
            if (forceup==0) {
                upgradeRequired();
            } else {
                upGradeAvailable();
            }
        } else {
            noUpgrade();
        }
    } onFail:^(NSError *error) {
        NSLog(@"upgrade call fail %@", [error localizedDescription]);
        noUpgrade();
    }];
}

@end
