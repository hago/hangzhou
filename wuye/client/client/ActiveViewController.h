//
//  ActiveViewController.h
//  client
//
//  Created by Chaojun Sun on 14-5-18.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActiveViewController : UIViewController

@property (retain, atomic) IBOutlet UIButton *btnnext;
@property (retain, atomic) IBOutlet UIButton *btnresend;
@property (retain, atomic) IBOutlet UITextField *txtcode;
@property (retain, atomic) IBOutlet UITextField *txtcountdown;

-(IBAction)next:(id)sender;
-(IBAction)cellinputDone:(id)sender;
-(IBAction)resend:(id)sender;
-(void)setInfo:(NSString *)cell CustomerId:(NSUInteger)cid;

@end
