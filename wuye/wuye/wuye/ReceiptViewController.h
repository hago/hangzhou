//
//  ReceiptViewController.h
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptViewController : UIViewController

@property (strong, atomic) IBOutlet UITextField *txtCell;
@property (strong, atomic) IBOutlet UITextField *deliveryNo;
@property (strong, atomic) IBOutlet UIButton *btnNext;

-(IBAction)next:(id)sender;
-(IBAction)txtInputDone:(id)sender;

@end
