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
#import "ActiveViewController.h"

@interface RegisterViewController ()

-(void)gotoActive;
-(void)regFailMessage:(NSError *)error;

@end

@implementation RegisterViewController

@synthesize btnnext;
@synthesize txtcell;

id loadingView;

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
    NSString *cellno = [[self.txtcell text] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \t"]];
    NSLog(@"cell is %@", cellno);
    if ([cellno isEqualToString:@""] || ![Utilities isValidCellnumber:cellno]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"手机号不对" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    ServiceMethods *sm = [ServiceMethods getInstance];
    loadingView = [Utilities startLoadingUI];
    [sm clientRegister:cellno onSuceess:^(NSInteger code) {
        [Utilities stopLoadingUI:loadingView];
        NSLog(@"reg succ");
        ActiveViewController *ac = [[UIStoryboard storyboardWithName:@"client" bundle:NULL] instantiateViewControllerWithIdentifier:@"activewindow"];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:ac];
    } onFail:^(NSError *error) {
        [Utilities stopLoadingUI:loadingView];
        NSLog(@"reg fail %@", [error description]);
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:@"注册失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [al show];
    }];
}

-(void)gotoActive
{
    
}

-(void)regFailMessage:(NSError *)error
{
    
}

-(IBAction)cellinputDone:(id)sender
{
    [self.txtcell resignFirstResponder];
}

@end
