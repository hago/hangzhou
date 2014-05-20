//
//  Utilities.h
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(BOOL)isRegistered;
+(NSDictionary *)getUserInfo;
+(void)saveUserInfo:(NSDictionary *)userinfo;
+(BOOL)isValidCellnumber:(NSString *)input;
+(id)startLoadingUI;
+(id)startLoadingUI:(UIViewController *)controller;
+(void)stopLoadingUI;
+(void)stopLoadingUI:(id)handle;

+(NSString *)md5:(NSString *)str UsingEncoding:(NSStringEncoding)encoding;
+(NSString *)md5Data:(const void *)buffer DataLength:(NSUInteger)length;

+(NSString *)__debug_nsdata_as_string:(NSData *)data returnHex:(BOOL)returnhex;

@end
