//
//  HallOfFrameViewCell.m
//  SocialRadar
//
//  Created by Mohit Singh on 21/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import "HallOfFrameViewCell.h"

@implementation HallOfFrameViewCell

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
    [_label_cell release];
    [_stornImage_cell release];
    [_bolt_imageView release];
    [super dealloc];
}
@end
