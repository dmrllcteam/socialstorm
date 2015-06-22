//
//  LoginViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "Common_IPhone.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    appDelegate.IsFaceBookLogin = false;
    appDelegate.IsTwitterLogin=false;
    
    [NSTimer scheduledTimerWithTimeInterval:120
                                     target:self
                                   selector:@selector(UpdateUserStrikeInfo)
                                   userInfo:nil
                                    repeats:YES];
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(ResignTextField)];
    //tap.delegate=self;
    
    [self.view addGestureRecognizer:tap];
}
-(void)ResignTextField
{
    [userName_text resignFirstResponder];
    [password_text resignFirstResponder];
}

-(void)UpdateUserStrikeInfo
{
    
    User *userData = appDelegate.appdelegateUser;

    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    //[localDoct setValue:appDelegate.appdelegateUser.UserName forKey:@"UserName"];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserName"];
    
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(UpdateUserStrikeInfoResponse:);
    [temp postParseInfoWithUrlPath:KUserStatus WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
   
    
}


-(void)UpdateUserStrikeInfoResponse:(NSDictionary*)response
{
  //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
          // dispatch_sync(dispatch_get_main_queue(), ^{
            User *updateUser = [[User alloc]initWithDict:response] ;
            [appDelegate setbuttonImage:updateUser.ActiveStatus];
           [updateUser release];
     // });
    
             //    });

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [userName_text release];
    [password_text release];
    [super dealloc];
    
}
- (IBAction)loginButtonAction:(id)sender
{
     [userName_text resignFirstResponder];
     [password_text resignFirstResponder];
    
    if ([userName_text.text isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Please type in your Email address and Password" tittle:nil];
        
    }else if([password_text.text isEqualToString:@""])
    {
         [appDelegate showAlertMessage:@"Please type in your Email address and Password" tittle:nil];
    }else
    {
        // [APPDELEGATE createTabView];
        
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:userName_text.text forKey:@"UserName"];
        [localDoct setValue:password_text.text forKey:@"Password"];
        
        [appDelegate startAnimatingIndicatorView];
        
        
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getupdateResponse:);
        [temp postParseInfoWithUrlPath:KAuthenticateUser WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
}
    
    
}


#pragma mark -- 
#pragma mark Facebook Login Actions

- (IBAction)faceBookButtonAction:(id)sender
{
      appDelegate.Loginobj=self;
     [appDelegate startAnimatingIndicatorView];
     [FBSession.activeSession closeAndClearTokenInformation];
     //[appDelegate setIsFromFaceBookLogin:YES];
     [appDelegate openSessionWithAllowLoginUI:YES];
}

// Delegate Method get called when you login through facebook
- (void)LoginthroughFacebook

{
    NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    

    
    appDelegate.IsFaceBookLogin = true;
    appDelegate.IsTwitterLogin = false;
 // this will check whether Facebook user is already exists
    
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:4] forKey:@"FacebookOrTwitterID"];
    [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:0] forKey:@"Name"];
    [localDoct setValue:[NSNumber numberWithInt:0] forKey:@"Age"];
    [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:1] forKey:@"EmailAddress"];
    [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:2] forKey:@"UserName"];
    [localDoct setValue:@"" forKey:@"Password"];
    [localDoct setValue:@"" forKey:@"RelationshipStatus"];
    [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:3] forKey:@"Gender"];
    [localDoct setValue:latitude forKey:@"Latitude"];
    [localDoct setValue:longitude forKey:@"longitude"];
    [localDoct setValue:@"" forKey:@"PhoneNo"];
    [localDoct setValue:@""forKey:@"Photo"];
    [localDoct setValue:[NSNumber numberWithInt:0] forKey:@"RegisterType"];
    
    
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponseFacebook:);
    [temp postParseInfoWithUrlPath:KSignUpWitFacebookOrTwitter WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
    
    [localDoct release];
    
// Use follwing code to get the image and email of LoginUser
//    [self.view addSubview:appDelegate.profilePictureView];

    
}

#pragma mark --
#pragma mark Twitter Login Actions

- (IBAction)twitterButtonAction:(id)sender
{
    [self performSelector:@selector(animating) withObject:nil afterDelay:.1];
     appDelegate.Loginobj=self;
    [appDelegate TwitterLogin];
}
-(void)animating
{
      [appDelegate startAnimatingIndicatorView];
    
}
//Delegate Method get called when login through twitter
- (void)LoginthroughTwitter
{
    appDelegate.IsTwitterLogin = true;
    appDelegate.IsFaceBookLogin = false;
    
    
    
    NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    

    
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:appDelegate.TwitterId forKey:@"FacebookOrTwitterID"];
    [localDoct setValue:appDelegate.TwitterName forKey:@"Name"];
    [localDoct setValue:[NSNumber numberWithInt:0] forKey:@"Age"];
    NSString *string  = [NSString stringWithFormat:@"%@_%@",@"Twitter",appDelegate.TwitterUserName];
    [localDoct setValue:string forKey:@"EmailAddress"];
    [localDoct setValue:appDelegate.TwitterUserName forKey:@"UserName"];
    [localDoct setValue:@"" forKey:@"Password"];
    [localDoct setValue:@"" forKey:@"RelationshipStatus"];
    [localDoct setValue:@"" forKey:@"Gender"];
    [localDoct setValue:latitude forKey:@"Latitude"];
    [localDoct setValue:longitude forKey:@"longitude"];
    [localDoct setValue:@"" forKey:@"PhoneNo"];
    [localDoct setValue:@""forKey:@"Photo"];
    [localDoct setValue:[NSNumber numberWithInt:0] forKey:@"RegisterType"];
    
   
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponseTwitter:);
    [temp postParseInfoWithUrlPath:KSignUpWitFacebookOrTwitter WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
    
    [localDoct release];
    

    
    

    
}

#pragma mark
#pragma mark end

- (IBAction)registerButtonAction:(id)sender {
    RegisterViewController *reg = [[RegisterViewController alloc] initWithNibName:kRegisterViewControler bundle:nil];
    [self.navigationController pushViewController:reg animated:YES];
    _RELEASE(reg);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userName_text)
    {
        [password_text becomeFirstResponder];
    }
    else
    {
        [password_text resignFirstResponder];
        [self loginButtonAction:nil];
    }
    return YES;
}

#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response
{
    
   
        [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@""message:[response objectForKey:kMessage]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        _RELEASE(errorAlert);
        //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        //[appDelegate showAlertMessage:@"Invalid username or password" tittle:nil];
        return;
    }else
    {
                   
         appDelegate.appdelegateUser = [[User alloc] initWithDict:response];
        [APPDELEGATE createTabView];
        
    }
       
}


-(void)getupdateResponseFacebook:(NSDictionary*)response
{
    [appDelegate stopAnimatingIndicatorView];
    // id user doesnot exist regester the user else just populate the data
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
     /*   NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        
       // NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
       // NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
        
      
        
        [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:0] forKey:@"Name"];
        [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:1] forKey:@"EmailAddress"];
        [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:2] forKey:@"UserName"];
        [localDoct setValue:[appDelegate.FaceBookArray objectAtIndex:3] forKey:@"Gender"];
        [localDoct setValue:[NSNumber numberWithInt:0] forKey:@"RegisterType"];
        
        NuyeekWebService* nuyeekWebService = [[NuyeekWebService alloc]init];
        SEL selector = @selector(getupdateResponse:);
        [nuyeekWebService PostParseInfoWithUrlPath:KSaveUser  WithSelector:selector callerClass:self parameterDic:localDoct showloader:YES];
        [localDoct release];*/

    }
    else
    {
        appDelegate.appdelegateUser = [[User alloc] initWithDict:response];
        [APPDELEGATE createTabView];
        
    }

}

-(void)getupdateResponseTwitter:(NSDictionary*)response
{
    
    [appDelegate stopAnimatingIndicatorView];
    // id user doesnot exist regester the user else just populate the data
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
//        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
//        
//        [localDoct setValue:appDelegate.TwitterName forKey:@"Name"];
//        [localDoct setValue:appDelegate.TwitterUserName forKey:@"UserName"];
//        NSString *string  = [NSString stringWithFormat:@"%@_%@",@"Twitter",appDelegate.TwitterUserName];
//        [localDoct setValue:string forKey:@"EmailAddress"];
//        [localDoct setValue:[NSNumber numberWithInt:0] forKey:@"RegisterType"];
//        
//        NuyeekWebService* nuyeekWebService = [[NuyeekWebService alloc]init];
//        SEL selector = @selector(getupdateResponse:);
//        [nuyeekWebService PostParseInfoWithUrlPath:KSaveUser  WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
//        
//        [dataArray release];
//        [localDoct release];
        
    }
    else
    {
        appDelegate.appdelegateUser = [[User alloc] initWithDict:response];
        [APPDELEGATE createTabView];
    }
    
}




#pragma mark - Helper methods
/*
 * Helper method to show alert results or errors
 */
- (NSString *)checkErrorMessage:(NSError *)error {
    NSString *errorMessage = @"";
    if (error) {
        errorMessage = @"Operation failed, retry later.";//[error localizedDescription];
    }
    //    } else {
    //        errorMessage = @"Operation failed due to a connection problem, retry later.";
    //    }
    return errorMessage;
}

/*
 * Helper method to check for the posted ID
 */
- (NSString *) checkPostId:(NSDictionary *)results {
    NSString *message = @"Posted successfully.";
    // Share Dialog
    /*NSString *postId = results[@"postId"];
     if (!postId) {
     // Web Dialog
     postId = results[@"post_id"];
     }
     if (postId) {
     message = [NSString stringWithFormat:@"Posted story, id: %@", postId];
     }*/
    return message;
}



-(void)showAlert
{
    //dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts configured.You can add or create a Facebook accounts in Settings." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertView.tag=102;
        [alertView show];
        [alertView release];
   //     });
    
}


@end
