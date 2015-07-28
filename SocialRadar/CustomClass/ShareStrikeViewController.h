//
//  ShareStrikeViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 21/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;

@interface ShareStrikeViewController : UIViewController<UIAlertViewDelegate>
{
    
}
- (IBAction)facebookAction:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)dontshare:(id)sender;
@property (nonatomic, retain) Location *location;
@property (nonatomic,retain) NSMutableDictionary *postParams;

@end
