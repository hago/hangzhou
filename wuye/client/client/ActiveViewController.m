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
#define COUNTDOWN_SECONDS 60

@interface ActiveViewController ()

-(void)startCountDown;
-(void)timerfunc;

@end

@implementation ActiveViewController

@synthesize btnnext;
@synthesize txtcode;
@synthesize lblcountdown;

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
    
    [self startCountDown];
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
    NSLog(@"timer running");
    if (secs > 0) {
        NSString *txt = [NSString stringWithFormat:@"验证短信已发出，请在%u秒内输入", secs];
        [lblcountdown setText:txt];
        secs--;
    } else {
        [timer invalidate];
        [lblcountdown setText:@""];
        [self.btnresend setHidden:NO];
    }
}

@end
