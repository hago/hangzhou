//
//  AppDelegate.m
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "AppDelegate.h"
#import "Utilities.h"
#import "RegisterViewController.h"
#import "ServiceMethods.h"

@interface AppDelegate ()

-(void)gotoDownload;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if ([Utilities getVersion] >= 7) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:149.0/255.9 blue:204.0/255.0 alpha:1]];
    }
    UIViewController *vc;
    if (![Utilities isRegistered]) {
        vc = [[UIStoryboard storyboardWithName:@"wuye" bundle:NULL] instantiateViewControllerWithIdentifier:@"regwindow"];
    } else {
        vc = [self createMainController];
    }
    self.window.rootViewController = vc;
    [[ServiceMethods getInstance] checkUpgrade:^(){
        [self gotoDownload];
    } UpgradeAvailable:^(){
        [[[UIAlertView alloc] initWithTitle:@"" message:@"现有一个新版本可以升级了" delegate:self cancelButtonTitle:@"现在不用" otherButtonTitles:@"立刻升级", nil] show];
    } NoUpgrade:^(){
        // do nothing
    }];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            [self gotoDownload];
            break;
        }
    }
}

-(void)gotoDownload
{
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"wuye" bundle:NULL] instantiateViewControllerWithIdentifier:@"upgrade"];
    UIViewController *current = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    if (current==nil) {
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
    } else {
        [UIView transitionFromView:current.view toView:vc.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
        }];
    }
}

-(UITabBarController *)createMainController
{
    UITabBarController *tb = (UITabBarController *)[[UIStoryboard storyboardWithName:@"wuye" bundle:NULL] instantiateViewControllerWithIdentifier:@"mainwindow"];
    UIViewController *vc;
    NSMutableArray *vclist = [NSMutableArray array];
    vc =[[UIStoryboard storyboardWithName:@"wuye" bundle:NULL] instantiateViewControllerWithIdentifier:@"receipt"];
    [vclist addObject:vc];
    vc =[[UIStoryboard storyboardWithName:@"wuye" bundle:NULL] instantiateViewControllerWithIdentifier:@"consume"];
    [vclist addObject:vc];
    vc =[[UIStoryboard storyboardWithName:@"wuye" bundle:NULL] instantiateViewControllerWithIdentifier:@"myparcels"];
    [vclist addObject:vc];
    [tb setViewControllers:vclist];
    return tb;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
