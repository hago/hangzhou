//
//  RedeemViewController.m
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "RedeemViewController.h"

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
    // Do any additional setup after loading the view.
    //ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
    readerView = [[ZBarReaderView alloc] init];
    [readerView setReaderDelegate:self];
    [self.view addSubview:readerView];
    CGRect rect = CGRectMake(0, 20, 320, 300);
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
    // do something useful with results
    [readerView stop];
    for(ZBarSymbol *sym in syms) {
        NSLog(@"detect %@", sym.data);
        break;
    }
}

@end
