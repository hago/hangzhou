//
//  AppDelegate.h
//  client
//
//  Created by Chaojun Sun on 14-5-18.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

-(UITabBarController *)createMainController;

@end
