//
//  UITouchableImageView.m
//  client
//
//  Created by Chaojun Sun on 14-5-29.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "UITouchableImageView.h"

@implementation UITouchableImageView

@synthesize clickDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        NSEnumerator *enumerator = [touches objectEnumerator];
        id value;
        while ((value = [enumerator nextObject])) {
            UITouch *touch = (UITouch *)value;
            if ([touch.view isKindOfClass:[UITouchableImageView class]]) {
                UITouchableImageView *tview = (UITouchableImageView *)touch.view;
                if ((tview.clickDelegate !=nil) && [tview.clickDelegate respondsToSelector:@selector(touchDown:byTouches:withEvent:)]) {
                    [tview.clickDelegate touchDown:tview byTouches:touches withEvent:event];
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        NSEnumerator *enumerator = [touches objectEnumerator];
        id value;
        while ((value = [enumerator nextObject])) {
            UITouch *touch = (UITouch *)value;
            if ([touch.view isKindOfClass:[UITouchableImageView class]]) {
                UITouchableImageView *tview = (UITouchableImageView *)touch.view;
                if ((tview.clickDelegate !=nil) && [tview.clickDelegate respondsToSelector:@selector(touchUp:byTouches:withEvent:)]) {
                    [tview.clickDelegate touchUp:tview byTouches:touches withEvent:event];
                }
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeTouches) {
        NSEnumerator *enumerator = [touches objectEnumerator];
        id value;
        while ((value = [enumerator nextObject])) {
            UITouch *touch = (UITouch *)value;
            if ([touch.view isKindOfClass:[UITouchableImageView class]]) {
                UITouchableImageView *tview = (UITouchableImageView *)touch.view;
                if ((tview.clickDelegate !=nil) && [tview.clickDelegate respondsToSelector:@selector(touchMoved:byTouches:withEvent:)]) {
                    [tview.clickDelegate touchMoved:tview byTouches:touches withEvent:event];
                }
            }
        }
    }
}

@end
