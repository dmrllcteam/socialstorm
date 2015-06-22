//
//  EditProfileViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 28/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "EditProfileViewController.h"
#import "RegisterViewCell.h"
#import "Common_IPhone.h"
#import "AppDelegate.h"
#import "User.h"
#import "UIImage+Base64Image.h"
#import "CLXURLConnection.h"

@interface EditProfileViewController ()

@end

#define kEFFECTIVE_KEYBORAD_HEIGHT     167

@implementation EditProfileViewController
@synthesize registerTableViewCell,userData;

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
    self.navigationItem.hidesBackButton = YES;
    
    firstNameStr = [[NSMutableString alloc] init];
    ageStr = [[NSMutableString alloc] init];
    emailStr = [[NSMutableString alloc] init];
    userNameStr = [[NSMutableString alloc] init];
    passwordStr = [[NSMutableString alloc] init];
    phoneNoStr = [[NSMutableString alloc] init];
    
    
    pickerView1.delegate=self;
    pickerView1.dataSource=self;
    
    self.title = @"Edit Profile";
    
    editdataDict = [[NSMutableDictionary alloc] init];
    [editdataDict setObject:userData.Name forKey:[NSString stringWithFormat:@"%d", 1]];
    [firstNameStr setString:userData.Name];
    [editdataDict setObject:[NSString stringWithFormat:@"%i",userData.Age] forKey:[NSString stringWithFormat:@"%d", 2]];
    [ageStr setString:[NSString stringWithFormat:@"%i",userData.Age]];
    [editdataDict setObject:userData.EmailAddress forKey:[NSString stringWithFormat:@"%d", 3]];
    [emailStr setString:userData.EmailAddress];
    [editdataDict setObject:userData.UserName forKey:[NSString stringWithFormat:@"%d", 4]];
    [userNameStr setString:userData.UserName];
    
    [editdataDict setObject:userData.Password forKey:[NSString stringWithFormat:@"%d", 5]];
    [passwordStr setString:userData.Password];
    
    if (![userData.RelationshipStatus isEqual:[NSNull null]])
    {
        
        if ([[userData.RelationshipStatus uppercaseString] isEqualToString:@"S"] || [userData.RelationshipStatus isEqualToString:@"Single"])
        {
            [editdataDict setObject:@"Single" forKey:[NSString stringWithFormat:@"%d", 6]];
        }
//        else if ([[userData.RelationshipStatus uppercaseString] isEqualToString:@"M"] || [userData.RelationshipStatus isEqualToString:@"Married"] )
//        {
//            [editdataDict setObject:@"Married" forKey:[NSString stringWithFormat:@"%d", 6]];
//        }
        else if ([[userData.RelationshipStatus uppercaseString] isEqualToString:@"I"] || [userData.RelationshipStatus isEqualToString:@"In a relationship"] )
                   {
                        [editdataDict setObject:@"In a relationship" forKey:[NSString stringWithFormat:@"%d", 6]];
                    }

    }
    //if (![userData.RelationshipStatus isEqual:[NSNull null]])
    
    if (![userData.Gender isEqual:[NSNull null]])
    {
        if ([[userData.Gender uppercaseString] isEqualToString:@"F"] || [userData.Gender isEqualToString:@"Female"])
        {
            [editdataDict setObject:@"Female" forKey:[NSString stringWithFormat:@"%d", 7]];
        }else if([[userData.Gender uppercaseString] isEqualToString:@"M"] || [userData.Gender isEqualToString:@"Male"])
        {
            [editdataDict setObject:@"Male" forKey:[NSString stringWithFormat:@"%d", 7]];
        }

    }
    
    
       
    [editdataDict setObject:userData.PhoneNo forKey:[NSString stringWithFormat:@"%d", 8]];
    [phoneNoStr setString:userData.PhoneNo];
    
    photAsAString = userData.Photo;
    
    
   
    
    
    if (userArrayData) {
        [userArrayData release];
        userArrayData = nil;
    }
     userArrayData = [[NSMutableArray alloc] init];
    
    if ([userData.Name length] != 0) {
        [userArrayData addObject:userData.Name];
    }else
    {
        [userArrayData addObject:@"Name"];
    }
    
    if (![[NSString stringWithFormat:@"%i",userData.Age] isEqualToString:@"0"]) {
        [userArrayData addObject:[NSString stringWithFormat:@"%i",userData.Age]];
    }else
    {
        [userArrayData addObject:@"Age"];
    }
    
    
    if ([userData.EmailAddress length] != 0) {
         [userArrayData addObject:userData.EmailAddress];
    }else
    {
        [userArrayData addObject:@"Email"];
    }
    
    if ([userData.UserName length] != 0) {
        [userArrayData addObject:userData.UserName];
    }else
    {
        [userArrayData addObject:@"Username"];
    }
    
    if ([userData.Password length] != 0) {
        [userArrayData addObject:userData.Password];
    }else
    {
        [userArrayData addObject:@"Password"];
    }
   
    
    if (![userData.RelationshipStatus isEqual:[NSNull null]])
    {
        
        if ([userData.RelationshipStatus length] != 0) {
            
            if ([userData.RelationshipStatus isEqualToString:@"S"])
            {
                [userArrayData addObject:@"Single"];
            }else
            {
                [userArrayData addObject:@""];
            }
            
        }else
        {
            //Placeholder change
            [userArrayData addObject:@"Relationship Status"];
        }

    }else
    {
        //Placeholder change
        [userArrayData addObject:@"Relationship Status"];
    }
    
      if (![userData.Gender isEqual:[NSNull null]])
      {
          if ([userData.Gender length] != 0) {
              if ([userData.Gender isEqualToString:@"F"])
              {
                  [userArrayData addObject:@"Female"];
              }else
              {
                  [userArrayData addObject:@"Male"];
                  
              }
          }else
          {
              [userArrayData addObject:@"Gender"];
          }

      }else
      {
          [userArrayData addObject:@"Gender"];
      }
    
    
    if ([userData.PhoneNo length] != 0) {
        [userArrayData addObject:userData.PhoneNo];
    }else
    {
        //Placeholder change
        [userArrayData addObject:@"Phone Number"];
    }

        
    
    [userArrayData addObject:@"Photo"];
        
   
    
    UIImage* buttonImage1 = [UIImage imageNamed:@"back_btn.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [leftButton setImage:buttonImage1 forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];
    
    
    UIImage* buttonImage2 = [UIImage imageNamed:@"doneEdit.png"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame= CGRectMake(0, 0,buttonImage2.size.width, buttonImage2.size.height);
    [rightButton setImage:buttonImage2 forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doneTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *done_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=done_btn;
    [done_btn release];

    edit_TableViews.backgroundColor = [UIColor clearColor];
    edit_TableViews.opaque = YES;
    
    if (IS_IPHONE_5) {
        edit_TableViews.frame = CGRectMake(edit_TableViews.frame.origin.x, 0, edit_TableViews.frame.size.width, edit_TableViews.frame.size.height);
    }
    
    if (IS_IPHONE_5) {
        registerScroll_View.contentSize = CGSizeMake(320, edit_TableViews.frame.size.height+180);
        
        //
    }else
    {
        registerScroll_View.contentSize = CGSizeMake(320, edit_TableViews.frame.size.height+320);
    }
    
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardPresent) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDissmiss) name:UIKeyboardDidHideNotification object:nil];*/
    
    //Adding toolbar to phone textfield
    UIBarButtonItem *donebutton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad:)];
    [donebutton setTintColor:[UIColor blackColor]];
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackOpaque;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           donebutton,
                           nil];
    [numberToolbar sizeToFit];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneTarget:(id)sender
{
    // save the edit here
   /* if ([emailStr length]>0&&![self validateEmail:emailStr]){
        [appDelegate showAlertMessage:@"Enter the correct email" tittle:nil];
        return ;
    }*/
    if(![phoneNoStr isEqualToString:@""])
    {
       if ([phoneNoStr length] != 14)
        {
            [appDelegate showAlertMessage:@"Enter the correct phone number" tittle:nil];
            return ;
        }
    }
     [appDelegate startAnimatingIndicatorView];
    [commonTextField resignFirstResponder];
    NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:firstNameStr forKey:@"Name"];
    [localDoct setValue:ageStr forKey:@"Age"];
    [localDoct setValue:emailStr forKey:@"EmailAddress"];
    [localDoct setValue:userNameStr forKey:@"UserName"];
    [localDoct setValue:passwordStr forKey:@"Password"];
    [localDoct setValue:[editdataDict objectForKey:[NSString stringWithFormat:@"%d",6]] forKey:@"RelationshipStatus"];
    [localDoct setValue:[editdataDict objectForKey:[NSString stringWithFormat:@"%d",7]] forKey:@"Gender"];
    [localDoct setValue:phoneNoStr forKey:@"PhoneNo"];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
    [localDoct setValue:latitude forKey:@"Latitude"];
    [localDoct setValue:longitude forKey:@"longitude"];
    NSString *strImageData = nil;
  
    if (imageCreate)
    {
        

        dataImage = [UIImageJPEGRepresentation(imageCreate,1.0) retain];
        //dataImage=[UIImagePNGRepresentation(imageCreate) retain] ;
        
        if(dataImage)
        {
         strImageData =[UIImage base64forData:dataImage];
        if(strImageData)
        [localDoct setValue:strImageData forKey:@"Photo"];
            
        }
    }
    else
    {
        //case of nil old image;
    //   imageCreate= [UIImage imageWithData:[UIImage base64DataFromString:userData.Photo]];
        dataImage=[[NSData dataWithContentsOfURL:[NSURL URLWithString:userData.Photo]] retain];
        
       
        //dataImage = [UIImageJPEGRepresentation(imageCreate, 1.0) retain];
         //dataImage=[UIImagePNGRepresentation(imageCreate) retain] ;
        
        if(dataImage)
        {
            strImageData =[UIImage base64forData:dataImage];
            if(strImageData)
                [localDoct setValue:strImageData forKey:@"Photo"];
            
        }
        
        
        // [localDoct setValue:userData.Photo forKey:@"Photo"];
    }

   
    
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp postParseInfoWithUrlPath:KUpdateUser WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
    
    
    [localDoct release];
    localDoct = nil;
    
    
    
}

#pragma mark INSTENCEMETHODS

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

-(void)backTarget:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    [firstNameStr release];
    [ageStr release];
    [emailStr release];
    [userNameStr release];
    [passwordStr release];
    [phoneNoStr release];
    
    [edit_TableViews release];
    [super dealloc];
}
- (void)viewDidUnload {
    [edit_TableViews release];
    edit_TableViews = nil;
    [super viewDidUnload];
}



#pragma mark
#pragma mark UIActionDelegate Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    
    if (buttonIndex==0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
    }
    else if(buttonIndex==1)
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else
    {
        [appDelegate showtabView];
    }
    
}




#pragma mark
#pragma mark ImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (imageCreate) {
        [imageCreate release];
    }
    
    imageCreate = [[self imageByScalingAndCroppingForSize:[info objectForKey:@"UIImagePickerControllerOriginalImage"] :CGSizeMake(260, 306)] retain];
//    [picker dismissModalViewControllerAnimated:YES]; DAJ depricated
    [picker presentViewController: self animated:YES completion:nil];

    [appDelegate showtabView];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//     [picker dismissModalViewControllerAnimated:YES]; DAJ depricated
    [picker presentViewController: self animated:YES completion:nil];

    [appDelegate showtabView];
}


#pragma mark UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 8)
    {
        if (range.length == 0)
        {
            [phoneNoStr setString:textField.text];
            [phoneNoStr appendString:string];
        }
        else
        {
            [phoneNoStr setString:textField.text];
            [phoneNoStr deleteCharactersInRange:range];
        }
        
        CGRect rect = childPickerViewScreen.frame;
        rect.origin.y = rect.origin.y+120;
        
        //[registerScroll_View scrollRectToVisible:rect animated:YES];
        
        if ([string isEqualToString:@""])
        {
            return YES;
        }
        
        
        if (range.location == 3)
        {
            textField.text = [NSString stringWithFormat:@"(%@) ",textField.text];
            return YES;
        }else if(range.location == 9)
        {
            textField.text = [NSString stringWithFormat:@"%@-",textField.text];
            return YES;
        }else if (range.location > 13)
        {
            [phoneNoStr setString:textField.text];
            return NO;
        }else
        {
            return YES;
        }
       
        
        
        
    }
    else if (textField.tag == 2)
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSString *expression= @"^([0-9]+)?$";
        
        NSError *error = nil;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
        {
            return NO;
        }
        
        if (range.length == 0)
        {
            [ageStr setString:textField.text];
            [ageStr appendString:string];
        }
        else
        {
            [ageStr setString:textField.text];
            [ageStr deleteCharactersInRange:range];
        }
        
        return YES;
    }
    else if (textField.tag == 1)
    {
        if (range.length == 0)
        {
            [firstNameStr setString:textField.text];
            [firstNameStr appendString:string];
        }
        else
        {
            [firstNameStr setString:textField.text];
            [firstNameStr deleteCharactersInRange:range];
        }
        return YES;
    }
    else if (textField.tag == 3)
    {
        if (range.length == 0)
        {
            [emailStr setString:textField.text];
            [emailStr appendString:string];
        }
        else
        {
            [emailStr setString:textField.text];
            [emailStr deleteCharactersInRange:range];
        }
        return YES;
    }
    else if (textField.tag == 4)
    {
        if (range.length == 0)
        {
            [userNameStr setString:textField.text];
            [userNameStr appendString:string];
        }
        else
        {
            [userNameStr setString:textField.text];
            [userNameStr deleteCharactersInRange:range];
        }
        return YES;
    }
    else if (textField.tag == 5)
    {
        if (range.length == 0)
        {
            [passwordStr setString:textField.text];
            [passwordStr appendString:string];
        }
        else
        {
            [passwordStr setString:textField.text];
            [passwordStr deleteCharactersInRange:range];
        }
        return YES;
    }
    else
    {
        return YES;
    }
    
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textfield{
	[textfield resignFirstResponder];
	return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text)
    {
        [editdataDict setObject:textField.text forKey:[NSString stringWithFormat:@"%d", textField.tag]];
    }
    if (textField.tag==5) {
        [self moveDown:44];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
            
        case 6: case 7: case 9:
            [self openPickerView:textField.tag textvalue:textField.text];
            commonTextField=textField;
            return NO;
            break;
        case 8:
            [self moveUp:kEFFECTIVE_KEYBORAD_HEIGHT+50];
            textField.inputAccessoryView=numberToolbar;
            edit_TableViews.userInteractionEnabled=NO;
            return YES;
            break;
        case 5:
            [self moveUp:44];
            return YES;
            break;
        default:
            return YES;
            break;
    }
    
    //[edit_TableViews scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int offset=0;
    
    if (textField.tag==3) {
        offset=600;
    }
    else if(textField.tag==4)
    {
        offset=660;
    }
    else if(textField.tag==5)
    {
        offset=700;
    }
    else if(textField.tag==8)
    {
        offset=750;
    }
    
   // float Y = (textField.tag-1)*44;
    //[registerScroll_View setContentOffset:CGPointMake(registerScroll_View.frame.origin.x, Y)];
    commonTextField = textField;
}



#pragma mark UIKeyboard

/*-(void) keyboardPresent
{
    CGRect rectTable = edit_TableViews.frame;
    rectTable.size.height = edit_TableViews.frame.size.height-kEFFECTIVE_KEYBORAD_HEIGHT;
    edit_TableViews.frame = rectTable;
}

-(void) keyboardDissmiss
{
    CGRect rectTable = edit_TableViews.frame;
    if (IS_IPHONE_5) {
        rectTable.size.height = edit_TableViews.frame.size.height+kEFFECTIVE_KEYBORAD_HEIGHT;
        
        //
    }else
    {
         rectTable.size.height = edit_TableViews.frame.size.height+kEFFECTIVE_KEYBORAD_HEIGHT;
    }
     edit_TableViews.frame = rectTable;
}*/

#pragma mark UIPICKER  
-(void) moveUp:(CGFloat)y
{
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    edit_TableViews.frame = CGRectMake(edit_TableViews.frame.origin.x,
                                  edit_TableViews.frame.origin.y -y,
                                  edit_TableViews.frame.size.width,
                                  edit_TableViews.frame.size.height);
    [UIView commitAnimations];
}

-(void) moveDown:(CGFloat)y
{
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    edit_TableViews.frame = CGRectMake(edit_TableViews.frame.origin.x,
                                           edit_TableViews.frame.origin.y +y,
                                           edit_TableViews.frame.size.width,
                                           edit_TableViews.frame.size.height);
     [UIView commitAnimations];
}

#pragma mark
#pragma mark UIPickerViewDelegate--

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView1.tag==6) {
        return ([relationShipArray objectAtIndex:row]);
    }
    else if(pickerView1.tag==7)
    {
        return ([genderArray objectAtIndex:row]);
    }
    
    return @" ";
    
}
-(void)doneWithNumberPad:(id)sender{
    
    edit_TableViews.userInteractionEnabled=YES;
    [self moveDown:kEFFECTIVE_KEYBORAD_HEIGHT+50];
    [commonTextField resignFirstResponder];
}

#pragma mark
#pragma mark UIButtonClicked Methods

-(void)openPickerView:(int)tag textvalue:(NSString*)text
{
    [commonTextField resignFirstResponder];
    
    if (IS_IPHONE_5) {
        pickerViewScreen.frame = CGRectMake(0, 100,pickerViewScreen.frame.size.width , pickerViewScreen.frame.size.height);
    }else
    {
        pickerViewScreen.frame = CGRectMake(0, 20,pickerViewScreen.frame.size.width , pickerViewScreen.frame.size.height);
        
    }
    
    
   
    if (tag==6) {
        
        
        [self moveUp:130];
        [self setPickerRow:tag pickerText:text];
        [appDelegate hidetabView];
         [appDelegate.tabBarController.view addSubview:pickerViewScreen];
        //[self.view addSubview:pickerViewScreen];
        pickerView1.tag=6;
        [pickerView1 selectRow:pickerRow inComponent:0 animated:NO];
        [pickerView1 reloadAllComponents];
    }
    else if(tag == 7)
    {
        [self moveUp:170];
           [self setPickerRow:tag pickerText:text];
        [appDelegate hidetabView];
         [appDelegate.tabBarController.view addSubview:pickerViewScreen];
      //[self.view addSubview:pickerViewScreen];
        pickerView1.tag=7;
         [pickerView1 selectRow:pickerRow inComponent:0 animated:NO];
        [pickerView1 reloadAllComponents];
    }
    else if(tag==9)
    {
       [appDelegate hidetabView];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"iPhone Camera",@"iPhone Photo Library", nil];
        
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
    }
    
}


-(void)setPickerRow:(int)tag pickerText:(NSString*)pickerText
{
    pickerRow=0;
    if(tag==7)
    {
        for (int i=0; i<[genderArray count]; i++) {
            if([[genderArray objectAtIndex:i] isEqualToString:pickerText])
            {
                pickerRow=i;
                return;
            }
               
        }
    }
    
    if(tag==6)
    {
        for (int i=0; i<[relationShipArray count]; i++) {
            if([[relationShipArray objectAtIndex:i] isEqualToString:pickerText])
            {
                pickerRow=i;
                return;
            }
                
        }
    }
}


-(IBAction)DoneBtnClicked
{
    [appDelegate showtabView];
    int  row = [pickerView1 selectedRowInComponent:0];
    
    if (pickerView1.tag==6) {
        [self moveDown:130];
        commonTextField.text = [relationShipArray objectAtIndex:row];
    }
    else if(pickerView1.tag==7)
    {
        [self moveDown:170];
        commonTextField.text = [genderArray objectAtIndex:row];
    }
    
    [pickerViewScreen removeFromSuperview];
    
    
    [editdataDict setObject:commonTextField.text forKey:[NSString stringWithFormat:@"%d", pickerView1.tag]];
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [userArrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // static NSString *CellIdentifier = @"tableIdentifier";
    
    
    RegisterViewCell *registerCell = nil; //= (RegisterViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (registerCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"RegisterViewCell" owner:self options:nil];
        // [registerTableViewCell setNeedsDisplay];
        registerCell = registerTableViewCell;
        registerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    registerCell.labelCell.hidden = TRUE;
    registerCell.buttonCell.hidden = TRUE;
    registerCell.arraowImg.hidden = TRUE;
    
   
    registerCell.textField.delegate=self;
    registerCell.textField.tag=(indexPath.row+1);
    
    registerCell.buttonCell.tag = indexPath.row+1;
    
    switch (indexPath.row +1) {
        case 1:
            registerCell.textField.keyboardType = UIKeyboardTypeAlphabet;
            registerCell.textField.secureTextEntry= 0 ;
            [registerCell.textField setEnabled:YES];
            break;
        case 2:
            registerCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            registerCell.textField.secureTextEntry= 0 ;
            [registerCell.textField setEnabled:YES];
            break;
        case 3:
            registerCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            registerCell.textField.secureTextEntry= 0 ;
            [registerCell.textField setEnabled:YES];
            
            if (userData.RegisterType == 0) {
                [registerCell.textField setEnabled:NO];
                
            }else if(userData.RegisterType == 1)
            {
                [registerCell.textField setEnabled:YES];
            }

            break;
        case 4 :
            registerCell.textField.keyboardType = UIKeyboardTypeAlphabet;
            registerCell.textField.secureTextEntry= 0 ;
            [registerCell.textField setEnabled:YES];
            
            if (userData.RegisterType == 0) {
                [registerCell.textField setEnabled:NO];
                
            }else if(userData.RegisterType == 1)
            {
                [registerCell.textField setEnabled:YES];
            }

            break;
        case 5:
            registerCell.textField.keyboardType = UIKeyboardTypeAlphabet;
            registerCell.textField.secureTextEntry=TRUE;
            
            if (userData.RegisterType == 0) {
                [registerCell.textField setEnabled:NO];
                
            }else if(userData.RegisterType == 1)
            {
                [registerCell.textField setEnabled:YES];
            }

            break;
        case 6: case 7:
            registerCell.textField.secureTextEntry= 0 ;
            [registerCell.textField setEnabled:YES];
            break;
            
        case 8:
            registerCell.textField.keyboardType = UIKeyboardTypePhonePad;
            //Placeholder change
            registerCell.textField.placeholder = @"Phone Number";
            [registerCell.textField setEnabled:YES];
            break;
        case 9:
            registerCell.arraowImg.hidden = FALSE;
            registerCell.textField.placeholder = @" ";
            registerCell.textField.secureTextEntry= 0 ;
            [registerCell.textField setEnabled:YES];
            //registerCell.textField.text = [registerArrays objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    if (indexPath.row + 1 == 9)
    {
        if ([editdataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row+1]])
        {
           registerCell.textField.text = [editdataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row+1]];
        }
        else
        {
            registerCell.textField.text = [userArrayData objectAtIndex:indexPath.row];
        }
    }
    else
    {
        if ([editdataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row+1]])
        {
            
            
            if ([[editdataDict valueForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] length] != 0) {
                
                int checkAge = indexPath.row +1;
                
                if (checkAge == 2)
                {
                    if ([[editdataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row+1]] isEqualToString:@"0"])
                    {
                        registerCell.textField.placeholder = [userArrayData objectAtIndex:indexPath.row];
                    }else
                    {
                        registerCell.textField.text = [editdataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row+1]];
                    }
                    
                }
                else
                {
                    registerCell.textField.text = [editdataDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row+1]];
                }
              
                
                
                 
               
                
            }else
            {
                registerCell.textField.placeholder = [userArrayData objectAtIndex:indexPath.row];
            }
           
        }
        else
        {
            registerCell.textField.text = nil;
            registerCell.textField.placeholder = [userArrayData objectAtIndex:indexPath.row];
        }
        
    }
    
    
    return registerCell;
}


#pragma mark - Table view delegate




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}


#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response{
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }else
    {
        appDelegate.appdelegateUser = [[User alloc] initWithDict:response];
        
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Profile Updated Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        errorAlert.tag=1001;
        [errorAlert show];
        _RELEASE(errorAlert);
        
    }
}

-(UIImage *) imageByScalingAndCroppingForSize:(UIImage *)inImage : (CGSize ) cropImageSize
{
    CGSize targetSize = cropImageSize;
    UIImage *sourceImage = inImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}




@end
