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
#import "UITouchableImageView.h"
#import "MyParcelsCell.h"
#import "QRCodeViewController.h"

#define MY_PARCEL_CELL_REUSE_IDENTIFIER @"MyParcelsCell"

@interface MyParcelsViewController ()

-(void)loadingParcels;
-(void)resizeTableView;

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
    [[ServiceMethods getInstance] unsignedPacels:cell PageNumber:1 onSuceess:^(NSArray *parcels) {
        NSLog(@"my pacels succeed");
        [refreshControl endRefreshing];
        NSLog(@"my parcels %lu, %@", (unsigned long)[parcels count], [parcels description]);
        myparcels = parcels;
        [self.list reloadData];
        //[self resizeTableView];
    } onFail:^(NSError *error) {
        NSLog(@"my pacels failed");
        [refreshControl endRefreshing];
    }];
}

-(void)resizeTableView
{
    //NSLog(@"%f, %f", self.list.contentSize.height, self.list.frame.size.height);
    CGSize cs = self.list.contentSize;
    CGRect current = self.list.frame;
    if (cs.height < current.size.height) {
        CGFloat minh = ([[UIScreen mainScreen] bounds].size.height - 49 - 44 - 20) / 2;
        CGFloat h = cs.height < minh ? minh : cs.height;
        CGRect r = CGRectMake(current.origin.x, current.origin.y, current.size.width, h);
        [self.list setFrame:r];
    } else if (cs.height > current.size.height) {
        CGFloat maxh = [[UIScreen mainScreen] bounds].size.height - 49 - 44 - 20;
        CGFloat h = cs.height > maxh ? maxh : cs.height;
        CGRect r = CGRectMake(current.origin.x, current.origin.y, current.size.width, h);
        [self.list setFrame:r];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [refreshControl endRefreshing];
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
    MyParcelsCell *cell = [tableView dequeueReusableCellWithIdentifier:MY_PARCEL_CELL_REUSE_IDENTIFIER forIndexPath:indexPath];
    NSDictionary *dict = [myparcels objectAtIndex:indexPath.row];
    //NSNumber *pid = [dict objectForKey:@"parcelId"];
    NSString *datestr = [dict objectForKey:@"arrivedDate"];
    [cell.lbltitle setText:[NSString stringWithFormat:@"快递 %@", [dict objectForKey:@"logisticsId"]]];
    [cell.lblsubtitle setText:[NSString stringWithFormat:@"到达时间：%@", [datestr substringToIndex:10]]];
    return cell;
}
// end of table data source protocol

// table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [myparcels objectAtIndex:indexPath.row];
    NSString *qrcodeurl = [dict objectForKey:@"twoDCode"];
    [Utilities startLoadingUI];
    [[ServiceMethods getInstance] httpGet:qrcodeurl httpCookies:nil requestHeaders:nil timeout:45 onSuceess:^(NSData *response) {
        NSLog(@"qrcode image success");
        [Utilities stopLoadingUI];
        UIImage *img = [UIImage imageWithData:response];
        QRCodeViewController *qc = [[UIStoryboard storyboardWithName:@"client" bundle:NULL] instantiateViewControllerWithIdentifier:@"qrwindow"];
        [qc setQrImage:img];
        [qc setParcel:dict];
        [self presentViewController:qc animated:YES completion:^{
            ;
        }];
    } onFail:^(NSError *error) {
        NSLog(@"qrcode image failed");
        [Utilities stopLoadingUI];
        [Utilities showError:@"" Message:@"网络不给力"];
    }];
}

// end of table delegate

-(void)touchDown:(UIImageView *)sender byTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    [sender removeFromSuperview];
}

@end
