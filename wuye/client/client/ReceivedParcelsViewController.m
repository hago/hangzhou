//
//  ReceivedParcelsViewController.m
//  client
//
//  Created by Chaojun Sun on 14-5-21.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "ReceivedParcelsViewController.h"
#import "ServiceMethods.h"
#import "Utilities.h"

#define SIGNED_PARCEL_CELL_REUSE_IDENTIFIER @"SignedParcelsCell"

@interface ReceivedParcelsViewController ()

-(void)loadingParcels;

@end

@implementation ReceivedParcelsViewController

NSArray *signedparcels;
UIRefreshControl *refreshControl;

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
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新"];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.list addSubview:refreshControl];
    UINib *nib = [UINib nibWithNibName:@"SignedParcelsCell" bundle:nil];
    [self.list registerNib:nib forCellReuseIdentifier:SIGNED_PARCEL_CELL_REUSE_IDENTIFIER];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startRefresh) userInfo:nil repeats:NO];
    //[self loadingParcels];
}

- (void)startRefresh
{
    NSLog(@"timer");
    [self.list setContentOffset:CGPointMake(0, -refreshControl.frame.size.height*2) animated:YES];
    [refreshControl beginRefreshing];
    [self loadingParcels];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refreshing");
    [self loadingParcels];
}

-(void)loadingParcels
{
    NSDictionary *user = [Utilities getUserInfo];
    NSString *cell = [user objectForKey:@"customerId"];
    if (cell == nil) {
        //
    }
    [[ServiceMethods getInstance] signedPacels:cell PageNumber:1 onSuceess:^(NSArray *parcels) {
        NSLog(@"my pacels succeed");
        [refreshControl endRefreshing];
        NSLog(@"my parcels %d, %@", [parcels count], [parcels description]);
        signedparcels = parcels;
        [self.list reloadData];
    } onFail:^(NSError *error) {
        NSLog(@"my pacels failed");
        [refreshControl endRefreshing];
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
    return (signedparcels==nil) ? 0 : [signedparcels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", [[myparcels objectAtIndex:indexPath.row] description]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SIGNED_PARCEL_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    /*if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER];
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     }*/
    NSDictionary *dict = [signedparcels objectAtIndex:indexPath.row];
    //NSNumber *pid = [dict objectForKey:@"parcelId"];
    NSString *datestr = [dict objectForKey:@"arrivedDate"];
    NSString *fetchdatestr = [dict objectForKey:@"signDate"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 送达的快递", [datestr substringToIndex:10]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"取件时间 %@", [fetchdatestr substringToIndex:10]];
    [cell sizeToFit];
    return cell;
}
// end of table data source protocol

@end
