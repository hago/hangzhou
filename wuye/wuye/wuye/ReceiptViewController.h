//
//  ReceiptViewController.h
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *groups;
}

@property (strong, atomic) IBOutlet UITextField *txtCell;
@property (strong, atomic) IBOutlet UITextField *deliveryNo;
@property (strong, atomic) IBOutlet UIButton *btnNext;
@property (strong, atomic) IBOutlet UITableView *groupselector;
@property (strong, atomic) IBOutlet UILabel *lblgroup;

-(IBAction)next:(id)sender;
-(IBAction)txtInputDone:(id)sender;
-(IBAction)selectGroup:(id)sender;

@end
