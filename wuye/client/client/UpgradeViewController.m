//
//  UpgradeViewController.m
//  client
//
//  Created by Chaojun Sun on 14-7-20.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "UpgradeViewController.h"
#define UPGRADE_URL @"http://122.10.117.234:81/PackageDownload/Package"

@interface UpgradeViewController ()

@end

@implementation UpgradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)clickUpgrade:(id)sender
{
    NSURL *url = [NSURL URLWithString:UPGRADE_URL];
    [[UIApplication sharedApplication] openURL:url];
}

@end
