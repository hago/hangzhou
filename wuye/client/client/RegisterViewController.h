//
//  RegisterViewController.h
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (retain, atomic) IBOutlet UIButton *btnnext;
@property (retain, atomic) IBOutlet UITextField *txtcell;

-(IBAction)next:(id)sender;
-(IBAction)cellinputDone:(id)sender;

@end
