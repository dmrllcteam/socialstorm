//
//  RXCustomTabBar.h
//  Nuyeek
//
//  Created by Sanjiv Saran on 22/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface RXCustomTabBar : UITabBarController {
	UIButton *btn1;
	UIButton *btn2;
	UIButton *btn3;
	
    
}

@property (nonatomic, retain) UIButton *btn1;
@property (nonatomic, retain) UIButton *btn2;
@property (nonatomic, retain) UIButton *btn3;


-(void) hideTabBar;
-(void) addCustomElements;
-(void) selectTab:(int)tabID;

-(void) hideNewTabBar;
-(void) ShowNewTabBar;


@end
