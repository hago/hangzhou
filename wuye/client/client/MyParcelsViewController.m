//
//  ParcelViewController.m
//  client
//
//  Created by Chaojun Sun on 14-5-21.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "MyParcelsViewController.h"
#import "ServiceMethods.h"
#import "Utilities.h"

@interface MyParcelsViewController ()

@end

@implementation MyParcelsViewController

@synthesize indicator;
@synthesize list;

NSArray *myparcels;

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
    [self.indicator setHidesWhenStopped:YES];
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    NSDictionary *user = [Utilities getUserInfo];
    NSString *cell = [user objectForKey:@"mobile"];
    if (cell == nil) {
        //
    }
    [[ServiceMethods getInstance] unsignedPacels:cell PageNumber:1 onSuceess:^(NSArray *parcels) {
        NSLog(@"my pacels succeed");
        [self.indicator stopAnimating];
        NSLog(@"my parcels %d, %@", [parcels count], [parcels description]);
        myparcels = parcels;
        [self.list reloadData];
    } onFail:^(NSError *error) {
        NSLog(@"my pacels failed");
        [self.indicator stopAnimating];
    }];
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

// table data source protocol
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (myparcels==nil) ? 0 : [myparcels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", [[myparcels objectAtIndex:indexPath.row] description]);
    return nil;
}
// end of table data source protocol

@end
