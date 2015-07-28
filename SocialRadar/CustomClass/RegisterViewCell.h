//
//  RegisterViewCell.h
//  SocialRadar
//
//  Created by Mohit Singh on 08/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewCell : UITableViewCell
{
    IBOutlet UITextField *textField;
    IBOutlet UILabel *labelCell;
    IBOutlet UIButton *buttonCell;
    
    
}

@property ( nonatomic, retain) IBOutlet UITextField *textField;
@property ( nonatomic, retain) IBOutlet UILabel *labelCell;
@property ( nonatomic, retain)  IBOutlet UIButton *buttonCell;
@property (retain, nonatomic) IBOutlet UIImageView *arraowImg;

@end
