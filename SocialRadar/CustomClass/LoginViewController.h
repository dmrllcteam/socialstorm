//
//  LoginViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLXURLConnection.h"

@interface LoginViewController : UIViewController<CXConnectionDelegate>
{
    IBOutlet UITextField *userName_text;
    IBOutlet UITextField *password_text;
    IBOutlet UIImageView *twImage;
    NSMutableArray *dataArray;
    
    
    
}

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)faceBookButtonAction:(id)sender;
- (IBAction)twitterButtonAction:(id)sender;
- (IBAction)registerButtonAction:(id)sender;
- (void)LoginthroughFacebook;
- (void)LoginthroughTwitter;



@end
