//
//  ParcelsViewController.h
//  wuye
//
//  Created by Chaojun Sun on 14-7-13.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParcelsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(atomic, retain) IBOutlet UITableView *parcelsList;
@property(atomic, retain) IBOutlet UILabel *lblgroup;
@property(atomic, retain) IBOutlet UIPickerView *pkrgroups;

-(IBAction)listGroups:(id)sender;

@end
