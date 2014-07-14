//
//  UnsignedParcelCell.h
//  wuye
//
//  Created by Chaojun Sun on 14-7-15.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnsignedParcelCell : UITableViewCell

@property(atomic) NSInteger parcelId;
@property(atomic, retain) IBOutlet UILabel *lbltitle;
@property(atomic, retain) IBOutlet UILabel *lblsubtitle;
@property(atomic, retain) IBOutlet UIButton *btnsms;

-(IBAction)btnSmsclick:(id)sender;

@end
