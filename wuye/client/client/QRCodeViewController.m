//
//  QRCodeViewController.m
//  client
//
//  Created by Chaojun Sun on 14-7-23.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "QRCodeViewController.h"
#import "Utilities.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

@synthesize qrImage;
@synthesize parcel;
@synthesize imvqr;
@synthesize lblgroup;

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
    [self.imvqr setImage:self.qrImage];
    //[self.lblgroup setText:[self.parcel objectForKey:@"groupName"]];
    [self.lblgroup setText:[Utilities datestringFromDotnetDateString:[self.parcel objectForKey:@"arrivedDate"]]];
}

-(IBAction)clickExit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
