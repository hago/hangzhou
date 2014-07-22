//
//  QRCodeViewController.h
//  client
//
//  Created by Chaojun Sun on 14-7-23.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeViewController : UIViewController

@property(atomic, strong) UIImage *qrImage;
@property(atomic, strong) NSDictionary *parcel;
@property(atomic, strong) IBOutlet UIImageView *imvqr;
@property(atomic, strong) IBOutlet UILabel *lblgroup;
@property(atomic, strong) IBOutlet UINavigationBar *navbar;

-(IBAction)clickExit:(id)sender;

@end
