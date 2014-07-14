//
//  RegisterViewController.m
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "RegisterViewController.h"
#import "Utilities.h"
#import "ServiceMethods.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize btnnext;
@synthesize txtcell;

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
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"KeyboardCancel", @"Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"KeyboardDone", @"Done") style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    self.txtcell.inputAccessoryView = numberToolbar;
}

-(void)cancelNumberPad{
    [self.txtcell resignFirstResponder];
    self.txtcell.text = @"";
}

-(void)doneWithNumberPad{
    [self.txtcell resignFirstResponder];
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
    NSString *cellno = [[self.txtcell text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
    NSLog(@"cell is %@", cellno);
    if ([cellno isEqualToString:@""] || ![Utilities isValidCellnumber:cellno]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"手机号不对" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    ServiceMethods *sm = [ServiceMethods getInstance];
    [Utilities startLoadingUI:self];
    [sm wuyeRegister:cellno onSuceess:^(NSDictionary *userinfo) {
        NSLog(@"wuye reg succ");
        [Utilities stopLoadingUI];
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:userinfo];
        [info setObject:cellno forKey:@"wuyemobile"];
        [Utilities saveUserInfo:info];
        AppDelegate *h = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *vc = [h createMainController];
        [UIView transitionFromView:self.view toView:vc.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
        }];
    } onFail:^(NSError *error) {
        [Utilities stopLoadingUI];
        NSLog(@"wuye reg fail");
        [[[UIAlertView alloc] initWithTitle:@"" message:@"电话号码验证不通过" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

-(IBAction)cellinputDone:(id)sender
{
    [self.txtcell resignFirstResponder];
}

@end
