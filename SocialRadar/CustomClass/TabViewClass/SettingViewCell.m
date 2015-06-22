//
//  SettingViewCell.m
//  SocialRadar
//
//  Created by Mohit Singh on 04/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "SettingViewCell.h"

@implementation SettingViewCell
@synthesize setting_lbl,imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [setting_lbl release];
    [imageView release];
    [_fav_btnOutlet release];
    [super dealloc];
}
@end
