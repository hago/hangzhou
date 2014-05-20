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

@implementation Utilities

NSMutableDictionary *handleDict = nil;
UIView *loadingView;

+(BOOL)isRegistered
{
    return NO;
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

+(id)startLoadingUI
{
    UIViewController *controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    return [self startLoadingUI:controller];
}

+(id)startLoadingUI:(UIViewController *)controller
{
    if (handleDict == nil) {
        handleDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
    }
    id key = [controller class];
    CGRect canvas = controller.view.frame;
    NSLog(@"parent view %f %f %f %f", canvas.origin.x, canvas.origin.y, canvas.size.width, canvas.size.height);
    UIView *cover = [[UIView alloc] initWithFrame:canvas];
    [cover setBackgroundColor:[UIColor clearColor]];
    CGRect rect = CGRectMake((canvas.size.width - LOADING_GIF_WIDTh) / 2, (canvas.size.height - LOADING_GIF_HEIGHT) / 2, LOADING_GIF_WIDTh, LOADING_GIF_HEIGHT);
    NSLog(@"loading view %f %f %f %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    UIImageView *img = [[UIImageView alloc] initWithFrame:rect];
    [img setAnimationImages:[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"loading0.gif"],
                             [UIImage imageNamed:@"loading1.gif"],
                             [UIImage imageNamed:@"loading2.gif"],
                             [UIImage imageNamed:@"loading3.gif"],
                             [UIImage imageNamed:@"loading4.gif"],
                             [UIImage imageNamed:@"loading5.gif"],
                             [UIImage imageNamed:@"loading6.gif"],
                             [UIImage imageNamed:@"loading7.gif"],
                             [UIImage imageNamed:@"loading8.gif"],
                             [UIImage imageNamed:@"loading9.gif"],
                             [UIImage imageNamed:@"loading10.gif"],
                             [UIImage imageNamed:@"loading11.gif"],
                             nil]];
    [img setAnimationDuration:(5 / img.animationImages.count)];
    [img setAnimationRepeatCount:300];
    [img startAnimating];
    //[img setImage:[UIImage imageNamed:@"bender.jpg"]];
    [img setBackgroundColor:[UIColor clearColor]];
    //[controller.view setAlpha:0.50f];
    [cover addSubview:img];
    [controller.view addSubview:cover];
    [handleDict setObject:cover forKey:key];
    loadingView = cover;
    NSLog(@"loading view started");
    return key;
}

+(void)stopLoadingUI
{
    [loadingView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
}

+(void)stopLoadingUI:(id)handle
{
    UIView *view = [handleDict objectForKey:handle];
    if (view==nil) {
        NSLog(@"loading view not found");
        return;
    }
    [handleDict removeObjectForKey:handle];
    //[view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
    [view removeFromSuperview];
    NSLog(@"loading view stopped");
}

+(NSString *)__debug_nsdata_as_string:(NSData *)data returnHex:(BOOL)returnhex
{
    if (data==nil) {
        return @"";
    }
    NSString *prt;
    if (!returnhex) {
        char *cstr = (char *)malloc(sizeof(char)*[data length]);
        [data getBytes:(void *)cstr length:[data length]];
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
