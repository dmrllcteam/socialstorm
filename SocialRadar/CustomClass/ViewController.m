//
//  ViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "ViewController.h"
#import "Common_IPhone.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self performSelector:@selector(callLogin) withObject:nil afterDelay:2.0];
    
   

    
}

-(void)getupdateResponse:(NSDictionary*)response
{
    if(![[response objectForKey:@"status"] boolValue])
    {
        return;
    }
}
-(void)callLogin
{
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:kLoginViewControler bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
    _RELEASE(login);
    


    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
