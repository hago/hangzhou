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
-(void)clientRegister:(NSString *)cellno onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)checkCode:(NSString *)code CellNumber:(NSString *)cellno CustomerId:(NSUInteger)cid onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)unsignedPacels:(NSString *)customerId PageNumber:(NSUInteger)pageno onSuceess:(void (^)(NSArray *))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)signedPacels:(NSString *)customerId PageNumber:(NSUInteger)pageno onSuceess:(void (^)(NSArray *))apiSuccess onFail:(void (^)(NSError *))apiFail;
-(void)getPacel:(NSString *)parcelId onSuceess:(void (^)(NSDictionary *))apiSuccess onFail:(void (^)(NSError *))apiFail;

@end
