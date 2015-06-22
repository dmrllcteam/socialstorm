//
//  AboutViewController.m
//  SocialStorm
//
//  Created by Sanjay Kumar on 17/04/14.
//  Copyright (c) 2014 Mohit Singh. All rights reserved.
//

#import "AboutViewController.h"
#import "Common_IPhone.h"
#import <QuartzCore/QuartzCore.h>


@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.title = @"About";
    
    
    web.layer.cornerRadius = 10;
    web.layer.masksToBounds = YES;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,backImg.size.width, backImg.size.height);
    [leftButton setImage:backImg forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];
    
    
    NSURLRequest *request;
    request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SocialStorm" ofType:@"html"]]];
    [web loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}
-(void)backTarget:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
