//
//  RXCustomTabBar.m
//  Nuyeek
//
//  Created by Sanjiv Saran on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RXCustomTabBar.h"
#import "Common_IPhone.h"

#define TABBAR_IMAGE_Y 431
#define TABBAR_IMAGE_WIDTH 61


@implementation RXCustomTabBar

@synthesize btn1, btn2, btn3;

- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self addCustomElements];
    [self selectTab:self.selectedIndex];
    
}

- (void)hideTabBar
{
    for(UIView *view in self.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            view.hidden=YES;
            //[[[view subviews] objectAtIndex:0] setHidden:NO];
            //[[[view subviews] objectAtIndex:1] setHidden:NO];
            //[[[view subviews] objectAtIndex:2] setHidden:NO];
            //[[[view subviews] objectAtIndex:3] setHidden:NO];
            //[[[view subviews] objectAtIndex:4] setHidden:NO];
            
            break;
        }
    }
}

- (void)hideNewTabBar
{
    
    self.btn1.hidden = 1;
    self.btn2.hidden = 1;
    self.btn3.hidden = 1;
    
}

- (void)ShowNewTabBar
{
    self.btn1.hidden = 0;
    self.btn2.hidden = 0;
    self.btn3.hidden = 0;
}

-(void)addCustomElements
{
    
    //
    
    // Initialise our two images
    UIImage *btnImage = [UIImage imageNamed:@"profile_icn.png"];
    UIImage *btnImageSelected = [UIImage imageNamed:@"profile_active.png"];
    
    if(!self.btn1)
    {
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 402, tabCustom_Img.size.width, tabCustom_Img.size.height)];
        imageView.backgroundColor=[UIColor clearColor];
        imageView.image = tabCustom_Img;
        imageView.contentMode = UIViewContentModeCenter; //RAR possible fix to make TabBar centered on 6, 6+
        [self.view addSubview:imageView];
        [imageView release];
        
        self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
        btn1.frame = CGRectMake(50, TABBAR_IMAGE_Y, TABBAR_IMAGE_WIDTH, 49); // Set the frame (size and position) of the button)
        [btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
        [btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
        [btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
        [btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
        
        
        // Now we repeat the process for the other buttons
        //    btnImage = [UIImage imageNamed:@"strike_btn_pressed.png"];
        btnImage = [UIImage imageNamed:@"strike_button.png"];
        btnImageSelected = [UIImage imageNamed:@"strike_button.png"];
        
        self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(62, TABBAR_IMAGE_Y, TABBAR_IMAGE_WIDTH, 49);
        [btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        [btn2 setTag:1];
        
        
        btnImage = [UIImage imageNamed:@"settings_icn.png"];
        btnImageSelected = [UIImage imageNamed:@"settings_active.png"];
        
        self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(124, 426, 72, 54);
        [btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
        [btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
        btn3.enabled=YES;
        [btn3 setTag:2];
        
        
        
        
        
        
        
        // Add my new buttons to the view
        [self.view addSubview:btn1];
        [self.view addSubview:btn2];
        [self.view addSubview:btn3];
        
        // Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
        [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)buttonClicked:(id)sender
{
    int tagNum = [sender tag];
    [self selectTab:tagNum];
}


- (void)selectTab:(int)tabID{
    
    switch(tabID)
    {
        case 0:
            [btn1 setSelected:true];
            [btn2 setSelected:false];
            [btn3 setSelected:false];
            
            self.selectedIndex = tabID;
            //            [APPDELEGATE setSelectedtab:tabID];
            //            if(![APPDELEGATE isFromCamera])
            //            {
            //                [[NSNotificationCenter defaultCenter]postNotificationName:Refresh_Feed_Data object:nil];
            //            }
            break;
        case 1:
            [btn1 setSelected:false];
            [btn2 setSelected:true];
            [btn3 setSelected:false];
            
            self.selectedIndex = tabID;
            //            [APPDELEGATE setSelectedtab:tabID];
            //             if(![APPDELEGATE isFromCamera])
            //             {
            //            [[NSNotificationCenter defaultCenter]postNotificationName:Refresh_Explore_Data object:nil];
            //             }
            break;
        case 2:
            [btn1 setSelected:false];
            [btn2 setSelected:false];
            [btn3 setSelected:true];
            
            // [self.tabBar setSelectedItem:nil];
            // [self .tabBar.]
            
            break;
    }
    
    self.selectedIndex = tabID;
    //    [APPDELEGATE setIsFromFriends:NO];
    //    [APPDELEGATE setIsFromCamera:NO];
    
}

- (void)dealloc {
    [btn1 release];
    [btn2 release];
    [btn3 release];
    
    [super dealloc];
}

@end
