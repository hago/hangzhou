//
//  ServiceMethods.h
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMethods : NSObject<NSURLConnectionDataDelegate>

+(ServiceMethods *)getInstance;
-(void)wuyeRegister:(NSString *)cellno onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)registerDeliveryNo:(NSDictionary *)req onSuceess:(void (^)(NSInteger code))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)getGroupNames:(NSString *)cell onSuceess:(void (^)(NSArray *groupNames))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)getWuyeParcels:(NSString *)customerId PageNo:(NSUInteger)pageno onSuceess:(void (^)(NSArray *))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)resendSms:(NSString *)parcelId onSuceess:(void (^)(NSInteger))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)checkUpgrade:(void (^)())upgradeRequired UpgradeAvailable:(void (^)())upGradeAvailable NoUpgrade:(void (^)())noUpgrade;

-(void)httpGet:(NSString *)url httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail;
-(void)httpPost:(NSString *)url httpCookies:(NSDictionary *)cookies requestHeaders:(NSDictionary *)headers httpBody:(NSData *)body timeout:(NSTimeInterval)timeout onSuceess:(void (^)(NSData *response))httpSuccess onFail:(void (^)(NSError *))httpFail;

@end
