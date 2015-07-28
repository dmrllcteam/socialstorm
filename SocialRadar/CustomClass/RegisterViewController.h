//
//  RegisterViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 08/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegisterViewCell;
@interface RegisterViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UIScrollViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *registerScroll_View;
    IBOutlet RegisterViewCell *registerTableViewCell;
    IBOutlet UITableView *register_TableView;
    UITextField *commonTextField;
    IBOutlet UIView *pickerViewScreen,*childPickerViewScreen;
    IBOutlet UIPickerView *pickerView1;
    NSMutableArray *dataArray;
    UIImage *imageCreate;
    NSData *dataImage ;
    IBOutlet UIImageView *mainImgView;
    int pickerRow;
    UIToolbar* numberToolbar;
}
@property (nonatomic, retain)  IBOutlet RegisterViewCell *registerTableViewCell;

- (IBAction)registerButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
-(IBAction)DoneBtnClicked;

@end
