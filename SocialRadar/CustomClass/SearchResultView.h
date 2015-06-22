//
//  SearchResultView.h
//  SocialRadar
//
//  Created by Mohit Singh on 02/07/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HallOfFrameViewCell,NearByLocation;

@interface SearchResultView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *textSearch_TableView;
    NSMutableArray *arrayOfTextSearch;
    NearByLocation *nearByLocationsDidSelect;
}

@property (nonatomic,retain) NSMutableArray *arrayOfTextSearch;
@property (nonatomic , retain) HallOfFrameViewCell *hallOfFarame_Cell;

@end
