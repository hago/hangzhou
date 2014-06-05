//
//  RedeemViewController.m
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "RedeemViewController.h"
#import "ServiceMethods.h"
#import "Utilities.h"

#define SCANNER_MARGIN 20

@interface RedeemViewController ()

@end

@implementation RedeemViewController

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
    
    float th = self.tabBarController.tabBar.frame.size.height;
    // Do any additional setup after loading the view.
    //ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
    readerView = [[ZBarReaderView alloc] init];
    [readerView setReaderDelegate:self];
    [self.view addSubview:readerView];
    CGRect vcr = self.view.frame;
    CGRect rect = CGRectMake(vcr.origin.x + SCANNER_MARGIN, vcr.origin.y + SCANNER_MARGIN, vcr.size.width - 2*SCANNER_MARGIN, vcr.size.height - th - 2*SCANNER_MARGIN);
    [readerView setFrame:rect];
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

- (void) viewDidAppear: (BOOL) animated
{
    // run the reader when the view is visible
    [readerView start];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [readerView stop];
}

- (void)readerView:(ZBarReaderView*)view didReadSymbols:(ZBarSymbolSet*)syms fromImage:(UIImage*)img
{
    [readerView stop];
    NSString *url = nil;
    for(ZBarSymbol *sym in syms) {
        NSLog(@"detect %@", sym.data);
        url = sym.data;
        break;
    }
    if (url == nil) {
        [readerView start];
    } else {
        [Utilities startLoadingUI:self];
        NSLog(@"qr url %@", url);
        [[ServiceMethods getInstance] httpGet:url httpCookies:nil requestHeaders:nil timeout:30 onSuceess:^(NSData *response) {
            NSLog(@"qr url ok %@", [Utilities __debug_nsdata_as_string:response returnHex:NO]);
            [Utilities stopLoadingUI];
            NSError *error = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
            if (error!=nil) {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"网络不好，请再试一次" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return;
            }
            NSString *code = [dict objectForKey:@"code"];
            if (![code isEqualToString:@"0"]) {
                [[[UIAlertView alloc] initWithTitle:@"" message:@"不是有效的取货二维码" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                return;
            }
            [[[UIAlertView alloc] initWithTitle:@"" message:@"验证二维码成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } onFail:^(NSError *error) {
            NSLog(@"qr url fail");
            [Utilities stopLoadingUI];
            [[[UIAlertView alloc] initWithTitle:@"" message:@"不是有效的取货二维码" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [readerView start];
}

@end
