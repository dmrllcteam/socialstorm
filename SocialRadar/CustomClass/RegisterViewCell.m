//
//  RegisterViewCell.m
//  SocialRadar
//
//  Created by Mohit Singh on 08/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "RegisterViewCell.h"

@implementation RegisterViewCell
@synthesize labelCell,textField,buttonCell;

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
    [textField release];
    [labelCell release];
    [buttonCell release];
    [_arraowImg release];
    [super dealloc];
}
@end
