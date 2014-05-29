//
// UITouchableImageView.h
// ThaiTour
//
// Created by sun hago on 10-11-11.
// Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITouchableImageViewProtocol.h"

@interface UITouchableImageView : UIImageView

@property(nonatomic, strong) id<UITouchableImageViewProtocol> clickDelegate;

@end