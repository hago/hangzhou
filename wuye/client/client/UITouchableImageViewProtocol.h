//
//  UITouchableImageViewProtocol.h
//  client
//
//  Created by Chaojun Sun on 14-5-29.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UITouchableImageViewProtocol <NSObject>

@optional
-(void)touchDown:(UIImageView *)sender byTouches:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchUp:(UIImageView *)sender byTouches:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchMoved:(UIImageView *)sender byTouches:(NSSet *)touches withEvent:(UIEvent *)event;

@end
