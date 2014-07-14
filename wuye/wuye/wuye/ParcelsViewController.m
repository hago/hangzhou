//
//  ParcelsViewController.m
//  wuye
//
//  Created by Chaojun Sun on 14-7-13.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "ParcelsViewController.h"
#import "Utilities.h"
#import "ServiceMethods.h"
#import "UnsignedParcelCell.h"

#define MY_PARCEL_CELL_REUSE_IDENTIFIER @"MyParcelsCell"

@interface ParcelsViewController ()

@end

@implementation ParcelsViewController

CGFloat cellHeight = -1;

@synthesize parcelsList;

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
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新"];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.parcelsList addSubview:refreshControl];
    UINib *nib = [UINib nibWithNibName:@"parcel" bundle:nil];
    [self.parcelsList registerNib:nib forCellReuseIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startRefresh) userInfo:nil repeats:NO];
}

- (void)startRefresh
{
    NSLog(@"timer");
    [self.parcelsList setContentOffset:CGPointMake(0, -refreshControl.frame.size.height*2) animated:YES];
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
    NSString *cid = [user objectForKey:@"customerId"];
    if (cid == nil) {
        // relogin
    }
    ServiceMethods *svc = [ServiceMethods getInstance];
    [svc getWuyeParcels:cid PageNo:1 onSuceess:^(NSArray *parcels) {
        NSLog(@"my pacels succeed");
        [refreshControl endRefreshing];
        NSLog(@"my parcels %lu, %@", (unsigned long)[parcels count], [parcels description]);
        myparcels = parcels;
        [self.parcelsList reloadData];
    } onFail:^(NSError *error) {
        NSLog(@"my pacels failed");
        [refreshControl endRefreshing];
        [Utilities showError:@"" Message:@"网络不给力"];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (myparcels==nil) ? 0 : [myparcels count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"未领的包裹";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"parcel" owner:self options:nil];
    for (NSUInteger i=0; i<views.count; i++) {
        UIView *view = [views objectAtIndex:i];
        if ([view isKindOfClass:[UnsignedParcelCell class]]) {
            cellHeight = view.frame.size.height;
            break;
        }
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UnsignedParcelCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    NSDictionary *dict = [myparcels objectAtIndex:indexPath.row];
    NSNumber *pid = [dict objectForKey:@"pacelId"];
    NSString *datestr = [dict objectForKey:@"arrivedDate"];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@送达的快递", [datestr substringToIndex:10]];
    [cell.lbltitle setText:[NSString stringWithFormat:@"%@ 送达的快递", [datestr substringToIndex:10]]];
    [cell.lblsubtitle setText:[dict objectForKey:@"groupName"]];
    [cell setParcelId:[pid integerValue]];
    [cell sizeToFit];
    return cell;
}
// end of table data source protocol

// table delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tap");
    NSDictionary *dict = [myparcels objectAtIndex:indexPath.row];
    NSString *qrcodeurl = [dict objectForKey:@"twoDCode"];
    [Utilities startLoadingUI];
    [[ServiceMethods getInstance] httpGet:qrcodeurl httpCookies:nil requestHeaders:nil timeout:45 onSuceess:^(NSData *response) {
        NSLog(@"qrcode image success");
        [Utilities stopLoadingUI];
    } onFail:^(NSError *error) {
        NSLog(@"qrcode image failed");
        [Utilities stopLoadingUI];
    }];
}

// end of table delegate

@end
