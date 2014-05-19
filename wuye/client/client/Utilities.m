//
//  Utilities.m
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "Utilities.h"
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
    //[img setAnimationImages:[NSArray arrayWithObjects:
     //                       [UIImage imageNamed:@"bender"]
//                            , [UIImage imageNamed:@""]
  //                          , [UIImage imageNamed:@""]
    //                         , nil]];
    //[img setAnimationDuration:(1 / img.animationImages.count)];
    //[img setAnimationRepeatCount:30];
    //[img startAnimating];
    [img setImage:[UIImage imageNamed:@"bender.jpg"]];
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

@end
