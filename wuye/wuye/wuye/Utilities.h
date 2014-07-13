//
//  Utilities.h
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IOS_7_OR_LATER ([Utilities getMajorVersion]>=7)

@interface Utilities : NSObject

+(BOOL)isRegistered;
+(NSDictionary *)getUserInfo;
+(void)saveUserInfo:(NSDictionary *)userinfo;
+(NSArray *)getGroups:(NSString *)cellno;
+(void)saveGroups:(NSString *)cellno GroupInfo:(NSArray *)groups;

+(BOOL)isValidCellnumber:(NSString *)input;
+(void)startLoadingUI;
+(void)startLoadingUI:(UIViewController *)controller;
+(void)stopLoadingUI;
+(void)showError:(NSString *)title Message:(NSString *)message;

+(NSUInteger)getMajorVersion;
+(NSUInteger)getMinorVersion;

+(NSString *)md5:(NSString *)str UsingEncoding:(NSStringEncoding)encoding;
+(NSString *)md5Data:(const void *)buffer DataLength:(NSUInteger)length;

+(NSString *)__debug_nsdata_as_string:(NSData *)data returnHex:(BOOL)returnhex;

@end
