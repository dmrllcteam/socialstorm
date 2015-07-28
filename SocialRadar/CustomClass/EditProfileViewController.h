//
//  EditProfileViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 28/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegisterViewCell,User;

@interface EditProfileViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate>
{
    IBOutlet UITableView *edit_TableViews;
    IBOutlet UIView *pickerViewScreen,*childPickerViewScreen;
    IBOutlet UIPickerView *pickerView1;
     UITextField *commonTextField;
    IBOutlet UIScrollView *registerScroll_View;
    
    NSMutableDictionary* editdataDict;
    
    NSMutableArray *userArrayData;
    NSString *photAsAString;
    
    UIImage *imageCreate;
    NSData *dataImage ;
    
    NSMutableString* firstNameStr;
    NSMutableString* ageStr;
    NSMutableString* emailStr;
    NSMutableString* userNameStr;
    NSMutableString* passwordStr;
    NSMutableString* phoneNoStr;
    UIToolbar* numberToolbar;
    
    int pickerRow;
    
}


@property (nonatomic, retain) RegisterViewCell *registerTableViewCell;
@property (nonatomic, retain) User *userData;

-(IBAction)DoneBtnClicked;

@end
