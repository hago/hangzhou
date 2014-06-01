//
//  ReceiptViewController.m
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "ReceiptViewController.h"
#import "ServiceMethods.h"
#import "Utilities.h"

@interface ReceiptViewController ()

@end

@implementation ReceiptViewController

@synthesize btnNext;
@synthesize txtCell;
@synthesize deliveryNo;

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

-(IBAction)next:(id)sender
{
    NSString *cell = [self.txtCell.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t\r\n"]];
    if ([cell isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请输入收件人手机号" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *userinfo = [Utilities getUserInfo];
    NSString *fmt = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale systemLocale]];
    NSDateFormatter *fmtr = [[NSDateFormatter alloc] init];
    [fmtr setDateFormat:fmt];
    NSDictionary *customer = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:0], @"customerId",
                              cell, @"mobile",
                              @"", @"username",
                              @"1", @"gender",
                              @"", @"province",
                              @"", @"city",
                              @"", @"district",
                              @"", @"campname",
                              @"", @"bldNumber",
                              @"", @"unitNumber",
                              @"", @"roomNumber",
                              @"", @"validationCode",
                              [[UIDevice currentDevice].identifierForVendor UUIDString], @"deviceinfo",
                              @"0", @"type",
                              @"", @"communityId",
                              @"", @"campCode",
                              [fmtr stringFromDate:[NSDate date]], @"validationCodeTime",
                              nil];
    NSDictionary *pacel =[NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"pacelId",
                          [fmtr stringFromDate:[NSDate date]], @"arrivedData",
                          @"", @"signDate",
                          @"", @"signname",
                          @"", @"customerId",
                          @"", @"province",
                          @"", @"city",
                          @"", @"district",
                          @"", @"campname",
                          @"", @"bldNumber",
                          @"", @"unitNumber",
                          @"", @"roomNumber",
                          @"", @"type",
                          @"", @"communityId",
                          @"356789944", @"logisticsId",
                          @"", @"twoDCode",
                          nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          customer, @"customer",
                          [userinfo objectForKey:@"wuyemobile"], @"wuyemobile",
                          pacel, @"pacel",
                          nil];
    [Utilities startLoadingUI:self];
    [[ServiceMethods getInstance] registerDeliveryNo:dict onSuceess:^(NSInteger code) {
        [Utilities stopLoadingUI];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"记录快件成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } onFail:^(NSError *error) {
        [Utilities stopLoadingUI];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }];
}

-(IBAction)txtInputDone:(id)sender
{
    [sender resignFirstResponder];
}

@end
