//
//  HallOfFrameViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 21/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HallOfFrameViewCell;

@interface HallOfFrameViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *hallOfFrame_tableView;
    IBOutlet HallOfFrameViewCell *hallOfFarame_Cell;
    NSMutableArray *arrayOfStrorm;
}

@end
