//
//  ActiveViewController.m
//  client
//
//  Created by Chaojun Sun on 14-5-18.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "ActiveViewController.h"
#import "ServiceMethods.h"
#import "Utilities.h"
#import "AppDelegate.h"
#define COUNTDOWN_SECONDS 60

@interface ActiveViewController ()

-(void)startCountDown;
-(void)timerfunc;

@end

@implementation ActiveViewController

@synthesize btnnext;
@synthesize txtcode;
@synthesize txtcountdown;

NSString *cellno;
NSUInteger customerid;
NSUInteger secs;
NSTimer *timer;
id handle;

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
    self.txtcode.inputAccessoryView = numberToolbar;

    [self startCountDown];
}

-(void)cancelNumberPad{
    [self.txtcode resignFirstResponder];
    self.txtcode.text = @"";
}

-(void)doneWithNumberPad{
    [self.txtcode resignFirstResponder];
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

-(void)setInfo:(NSString *)cell CustomerId:(NSUInteger)cid
{
    cellno = cell;
    customerid = cid;
}

-(IBAction)next:(id)sender
{
    NSString *code = [self.txtcode text];
    id loadingView = [Utilities startLoadingUI];
    [[ServiceMethods getInstance] checkCode:code CellNumber:cellno CustomerId:customerid onSuceess:^(NSDictionary *info) {
        [Utilities stopLoadingUI:loadingView];
        NSLog(@"check succ");
        [Utilities saveUserInfo:info];
        AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIViewController *vc = [dele createMainController];
        [UIView transitionFromView:self.view toView:vc.view duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
            [[[UIApplication sharedApplication] keyWindow] setRootViewController:vc];
        }];
    } onFail:^(NSError *error) {
        [Utilities stopLoadingUI:loadingView];
        NSLog(@"check fail %@", [error description]);
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:@"激活失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [al show];
    }];
}

-(IBAction)cellinputDone:(id)sender
{
    [self.txtcode resignFirstResponder];
}

-(IBAction)resend:(id)sender
{
    ServiceMethods *sm = [ServiceMethods getInstance];
    handle = [Utilities startLoadingUI];
    [sm clientRegister:cellno onSuceess:^(NSDictionary *info) {
        [Utilities stopLoadingUI:handle];
        NSLog(@"reg succ");
        [self.btnresend setHidden:YES];
        [self startCountDown];
    } onFail:^(NSError *error) {
        [Utilities stopLoadingUI:handle];
        NSLog(@"reg fail %@", [error description]);
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:@"注册失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [al show];
    }];
}

-(void)startCountDown
{
    [self.btnresend setHidden:YES];
    secs = COUNTDOWN_SECONDS;
    timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerfunc) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)timerfunc
{
    //NSLog(@"timer running");
    if (secs > 0) {
        NSString *txt = [NSString stringWithFormat:@"重新发送%lu秒", (unsigned long)secs];
        [self.txtcountdown setText:txt];
        secs--;
    } else {
        [timer invalidate];
        [self.txtcountdown setText:@""];
        [self.txtcountdown setHidden:YES];
        [self.btnresend setHidden:NO];
    }
}

@end
