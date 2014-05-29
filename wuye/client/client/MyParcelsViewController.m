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

#define MY_PARCEL_CELL_REUSE_IDENTIFIER @"MyParcelsCell"

@interface MyParcelsViewController ()

-(void)loadingParcels;

@end

@implementation MyParcelsViewController

@synthesize list;

NSArray *myparcels;
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
    UINib *nib = [UINib nibWithNibName:@"MyParcelsCell" bundle:nil];
    [self.list registerNib:nib forCellReuseIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER];
    
    //[refreshControl beginRefreshing];
    [self loadingParcels];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadingParcels];
}

-(void)loadingParcels
{
    NSDictionary *user = [Utilities getUserInfo];
    NSString *cell = [user objectForKey:@"customerId"];
    if (cell == nil) {
        //
    }
    [[ServiceMethods getInstance] unsignedPacels:cell PageNumber:1 onSuceess:^(NSArray *parcels) {
        NSLog(@"my pacels succeed");
        [refreshControl endRefreshing];
        NSLog(@"my parcels %d, %@", [parcels count], [parcels description]);
        myparcels = parcels;
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
    return (myparcels==nil) ? 0 : [myparcels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@", [[myparcels objectAtIndex:indexPath.row] description]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    /*if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }*/
    NSDictionary *dict = [myparcels objectAtIndex:indexPath.row];
    //NSNumber *pid = [dict objectForKey:@"parcelId"];
    NSString *datestr = [dict objectForKey:@"arrivedDate"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@送达的快递", [datestr substringToIndex:10]];
    [cell sizeToFit];
    return cell;
}
// end of table data source protocol

// table delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [myparcels objectAtIndex:indexPath.row];
    NSString *qrcodeurl = [dict objectForKey:@"twoDCode"];
    [Utilities startLoadingUI];
    [[ServiceMethods getInstance] httpGet:qrcodeurl httpCookies:nil requestHeaders:nil timeout:45 onSuceess:^(NSData *response) {
        NSLog(@"qrcode image success");
        [Utilities stopLoadingUI];
        //UIImage *img = [UIImage imageWithData:response];
        //UIImageView *imgview = [[UIImageView alloc] initWithImage:img];
    } onFail:^(NSError *error) {
        NSLog(@"qrcode image failed");
        [Utilities stopLoadingUI];
    }];
}
// end of table delegate

@end
