//
//  ParcelsViewController.h
//  wuye
//
//  Created by Chaojun Sun on 14-7-13.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParcelsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSArray *myparcels;
    NSArray *wuyegroups;
    UIRefreshControl *refreshControl;
}

@property(atomic, retain) IBOutlet UITableView *parcelsList;

@end
