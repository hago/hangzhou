//
//  RedeemViewController.h
//  wuye
//
//  Created by Chaojun Sun on 14-6-1.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface RedeemViewController : UIViewController<ZBarReaderViewDelegate, UIAlertViewDelegate> {
    ZBarReaderView *readerView;
}

@end
