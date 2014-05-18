//
//  ServiceMethods.h
//  wuye
//
//  Created by Chaojun Sun on 14-5-17.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceMethods : NSObject<NSURLConnectionDataDelegate>

+(ServiceMethods *)getInstance;
-(void)clientRegister:(NSString *)cellno onSuceess:(void (^)(NSInteger code))regSuccess onFail:(void (^)(NSError *))regFail;

@end
