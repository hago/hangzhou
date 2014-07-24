//
//  Utilities.h
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface Utilities : NSObject

+(BOOL)isRegistered;
+(NSDictionary *)getUserInfo;
+(void)saveUserInfo:(NSDictionary *)userinfo;
+(BOOL)isValidCellnumber:(NSString *)input;
+(id)startLoadingUI;
+(id)startLoadingUI:(UIViewController *)controller;
+(void)stopLoadingUI;
+(void)stopLoadingUI:(id)handle;
+(float)getVersion;
+(void)showError:(NSString *)title Message:(NSString *)message;

+(NSString *)datestringFromDotnetDateString:(NSString *)input;

+(NSString *)md5:(NSString *)str UsingEncoding:(NSStringEncoding)encoding;
+(NSString *)md5Data:(const void *)buffer DataLength:(NSUInteger)length;

+(NSString *)__debug_nsdata_as_string:(NSData *)data returnHex:(BOOL)returnhex;

@end
