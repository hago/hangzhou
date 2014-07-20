//
//  UnsignedParcelCell.m
//  wuye
//
//  Created by Chaojun Sun on 14-7-15.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "UnsignedParcelCell.h"
#import "ServiceMethods.h"
#import "Utilities.h"

@implementation UnsignedParcelCell

@synthesize lbltitle;
@synthesize lblsubtitle;
@synthesize btnsms;
@synthesize parcelId;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)btnSmsclick:(id)sender
{
    [[ServiceMethods getInstance] resendSms:[NSString stringWithFormat:@"%lu", (unsigned long)self.parcelId] onSuceess:^(NSInteger code) {
        NSLog(@"resend ok");
        [Utilities showError:@"" Message:@"发送成功"];
    } onFail:^(NSError *error) {
        [Utilities showError:@"" Message:@"发送失败"];
    }];
}

@end
