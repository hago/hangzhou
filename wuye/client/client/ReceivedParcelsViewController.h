//
//  ReceivedParcelsViewController.h
//  client
//
//  Created by Chaojun Sun on 14-5-21.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedParcelsViewController : UIViewController<UITableViewDataSource> {
    NSArray *signedparcels;
    UIRefreshControl *refreshControl;
}

@property (strong, atomic) IBOutlet UITableView *list;

@end
