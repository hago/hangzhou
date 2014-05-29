//
//  ParcelViewController.h
//  client
//
//  Created by Chaojun Sun on 14-5-21.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITouchableImageViewProtocol.h"

@interface MyParcelsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITouchableImageViewProtocol>

@property (strong, atomic) IBOutlet UITableView *list;

@end
