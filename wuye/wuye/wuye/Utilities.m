//
//  Utilities.m
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "Utilities.h"
#import <CommonCrypto/CommonCrypto.h>
#define LOADING_GIF_HEIGHT 66
#define LOADING_GIF_WIDTh 66
#define REGISTERED_USERINFO_KEY @"REGISTERED_USERINFO_KEY"

@implementation Utilities

NSMutableDictionary *handleDict = nil;
UIActivityIndicatorView *indicator = nil;

+(BOOL)isRegistered
{
    return [Utilities getUserInfo] != nil;
}

+(NSDictionary *)getUserInfo
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:REGISTERED_USERINFO_KEY];
    return dict;
}

+(void)saveUserInfo:(NSDictionary *)userinfo
{
    [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:REGISTERED_USERINFO_KEY];
}

+(BOOL)isValidCellnumber:(NSString *)input
{
    if (input==nil) {
        return NO;
    }
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:@"^\\d{11}?$" options:0 error:&error];
    //NSLog(@"reg %@", error==nil ? @"OK" : @"fail");
    NSRange range;
    range.location = 0;
    range.length = [input length];
    NSUInteger i = [re numberOfMatchesInString:input options:0 range:range];
    //NSLog(@"matches :%u", i);
    return i==1;
}

+(void)startLoadingUI:(UIViewController *)controller
{
    if (indicator==nil) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    CGRect canvas = controller.view.frame;
    [indicator setCenter:CGPointMake(canvas.size.width/2, canvas.size.height/2)];
    [indicator setContentMode:UIViewContentModeCenter];
    [controller.view setUserInteractionEnabled:NO];
    [indicator startAnimating];
    [controller.view addSubview:indicator];
    [controller.view bringSubviewToFront:indicator];
    NSLog(@"loading view started");
}

+(void)stopLoadingUI
{
    [indicator.superview performSelectorOnMainThread:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
    [indicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [indicator performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    NSLog(@"loading view stopped");
}

+(NSString *)__debug_nsdata_as_string:(NSData *)data returnHex:(BOOL)returnhex
{
    if (data==nil) {
        return @"";
    }
    //NSLog(@"data length %d", [data length]);
    NSString *prt;
    if (!returnhex) {
        NSUInteger l = [data length];
        char *cstr = (char *)malloc(sizeof(char)*(l+1));
        [data getBytes:(void *)cstr length:[data length]];
        cstr[l] = '\x0';
        prt = [NSString stringWithCString:cstr encoding:NSUTF8StringEncoding];
        free(cstr);
    } else {
        prt = [data description];
    }
    return prt;
}

+(NSString *)md5:(NSString *)str UsingEncoding:(NSStringEncoding)encoding
{
    const char *cstr = [str cStringUsingEncoding:encoding];
    return [Utilities md5Data:(const void *)cstr DataLength:strlen(cstr)];
}

+(NSString *)md5Data:(const void *)buffer DataLength:(NSUInteger)length
{
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, buffer, length);
    char *md;
    CC_MD5_Final((unsigned char *)md, &ctx);
    NSString *ret;
    ret = [NSString stringWithCString:md encoding:NSUTF8StringEncoding];
    return ret;
}

@end
