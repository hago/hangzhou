//
//  MyParcelsCell.m
//  client
//
//  Created by Chaojun Sun on 14-7-22.
//  Copyright (c) 2014年 Chaojun Sun. All rights reserved.
//

#import "MyParcelsCell.h"

@implementation MyParcelsCell

@synthesize lbltitle;
@synthesize lblsubtitle;

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

@end
