//
//  RegisterViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 08/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewCell.h"
#import "Common_IPhone.h"
#import "HomeViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "AppDelegate.h"
#import "CLXURLConnection.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize registerTableViewCell;

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
    pickerView1.delegate=self;
    pickerView1.dataSource=self;
    
    [self.view addSubview:pickerViewScreen];
    pickerViewScreen.hidden = YES;
    
    if (IS_IPHONE_5) {
        registerScroll_View.contentSize = CGSizeMake(320, register_TableView.frame.size.height+180);
        
        //
    }else
    {
        registerScroll_View.contentSize = CGSizeMake(320, register_TableView.frame.size.height+320);
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(ResignTextField)];
    //tap.delegate=self;
    
    [mainImgView addGestureRecognizer:tap];
    
    register_TableView.backgroundColor = [UIColor clearColor];
    register_TableView.opaque = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardPresent) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDissmiss) name:UIKeyboardDidHideNotification object:nil];
    
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
-(void)doneWithNumberPad:(id)sender{
    
   
    //edit_TableViews.userInteractionEnabled=YES;
   // [self moveDown:kEFFECTIVE_KEYBORAD_HEIGHT+50];
    [commonTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [registerScroll_View release];
    [registerTableViewCell release];
    
    [register_TableView release];
    [pickerView1 release];
    [pickerViewScreen release];
    [childPickerViewScreen release];
    [super dealloc];
}

#pragma mark
#pragma mark UIButtonClicked Methods

-(void)openPickerView:(int)tag textvalue:(NSString*)text
{
    [commonTextField resignFirstResponder];
    
    if (IS_IPHONE_5) {
        pickerViewScreen.frame = CGRectMake(0, 108,pickerViewScreen.frame.size.width , pickerViewScreen.frame.size.height);
    }else
    {
        pickerViewScreen.frame = CGRectMake(0, 24,pickerViewScreen.frame.size.width , pickerViewScreen.frame.size.height);
        
    }

    if (tag==6) {
//        [self.view addSubview:pickerViewScreen];
        [self moveUp:200];
        [self setPickerRow:tag pickerText:text];
        pickerViewScreen.hidden = NO;
        pickerView1.tag=6;
        [pickerView1 reloadAllComponents];
    }
    else if(tag == 7)
    {
//        [self.view addSubview:pickerViewScreen];
        [self moveUp:230];
        [self setPickerRow:tag pickerText:text];
        pickerViewScreen.hidden = NO;
        pickerView1.tag=7;
        [pickerView1 reloadAllComponents];
    }
    else if(tag==9)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"iPhone Camera",@"iPhone Photo Library", nil];
        
        [actionSheet showInView:self.view];

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
    
    int  row = [pickerView1 selectedRowInComponent:0];
    
    if (pickerView1.tag==6) {
        [self moveDown:200];
        commonTextField.text = [relationShipArray objectAtIndex:row];
    }
    else if(pickerView1.tag==7)
    {
        [self moveDown:230];
        commonTextField.text = [genderArray objectAtIndex:row];
    }

//    [pickerViewScreen removeFromSuperview];
    pickerViewScreen.hidden = YES;
}


#pragma mark UIKeyboard

-(void) keyboardPresent
{
    [registerScroll_View setContentSize:CGSizeMake(320, 900)];
}

-(void) keyboardDissmiss
{
    if (IS_IPHONE_5) {
        registerScroll_View.contentSize = CGSizeMake(320, register_TableView.frame.size.height+180);
        
        //
    }else
    {
        registerScroll_View.contentSize = CGSizeMake(320, register_TableView.frame.size.height+320);
    }
}


-(void)ResignTextField
{
    [commonTextField resignFirstResponder];
}

#pragma mark UITextFieldDelegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
   
    
    if (textField.tag == 8)
    {
        
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
            return NO;
        }else
        {
            return YES;
        }
        
    }else
    {
        return YES;
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
            textField.inputAccessoryView=numberToolbar;
            return YES;
            break;
        case 2:
            textField.inputAccessoryView=numberToolbar;
            return YES;
            break;
        default:
            return YES;
            break;
    }
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
        offset=820;
    }
    
    float Y = (textField.tag-1)*44;
    [registerScroll_View setContentOffset:CGPointMake(registerScroll_View.frame.origin.x, Y)];
    commonTextField = textField;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{

}


#pragma mark
#pragma mark GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
    
    
}


#pragma mark
#pragma mark UIActionDelegate Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate=self;

    if (buttonIndex==0) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else if(buttonIndex==1)
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}
#pragma mark UIPICKER
-(void) moveUp:(CGFloat)y
{
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    registerScroll_View.frame = CGRectMake(registerScroll_View.frame.origin.x,
                                       registerScroll_View.frame.origin.y -y,
                                       registerScroll_View.frame.size.width,
                                       registerScroll_View.frame.size.height);
    [UIView commitAnimations];
}

-(void) moveDown:(CGFloat)y
{
    [UIView beginAnimations: @"moveField" context: nil];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    registerScroll_View.frame = CGRectMake(registerScroll_View.frame.origin.x,
                                       registerScroll_View.frame.origin.y +y,
                                       registerScroll_View.frame.size.width,
                                       registerScroll_View.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark
#pragma mark ImagePickerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageCreate = [[self imageByScalingAndCroppingForSize:[info objectForKey:@"UIImagePickerControllerOriginalImage"] :CGSizeMake(260, 306)] retain];
    //imageCreate = [[self imageByScalingAndCroppingForSize:[info objectForKey:@"UIImagePickerControllerOriginalImage"] :CGSizeMake(120, 60)] retain];
    
//    [picker dismissModalViewControllerAnimated:YES]; // DAJ depricated
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [registerArrays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableIdentifier";
    
    
    registerTableViewCell = (RegisterViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (registerTableViewCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"RegisterViewCell" owner:self options:nil];
       // [registerTableViewCell setNeedsDisplay];
        registerTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    registerTableViewCell.labelCell.hidden = TRUE;
    registerTableViewCell.buttonCell.hidden = TRUE;
    registerTableViewCell.arraowImg.hidden = TRUE;
    
    registerTableViewCell.textField.placeholder = [registerArrays objectAtIndex:indexPath.row];
    registerTableViewCell.textField.delegate=self;
    registerTableViewCell.textField.tag=(indexPath.row+1);
    
    registerTableViewCell.buttonCell.tag = indexPath.row+1;
    
    
    switch (indexPath.row +1) {
            
        case 1:
            registerTableViewCell.textField.keyboardType = UIKeyboardTypeAlphabet;
            [registerTableViewCell.textField  setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            break;
        case 4 :
            registerTableViewCell.textField.keyboardType = UIKeyboardTypeAlphabet;
            break;
        case 2: 
            registerTableViewCell.textField.keyboardType = UIKeyboardTypeNumberPad;
           // registerTableViewCell.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            break;
        case 3:
            registerTableViewCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 5:
            registerTableViewCell.textField.keyboardType = UIKeyboardTypeAlphabet;
            registerTableViewCell.textField.secureTextEntry=TRUE;
            break;
        case 6: case 7: 
            break;
            
            case 8:
            registerTableViewCell.textField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case 9:
            registerTableViewCell.arraowImg.hidden = FALSE;
            registerTableViewCell.textField.placeholder = @" ";
            registerTableViewCell.textField.text = [registerArrays objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    
    return registerTableViewCell;
}


#pragma mark - Table view delegate




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
/*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */

}

#pragma mark
#pragma mark UIPickerViewDelegate

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


#pragma mark -  Delgate Function Call 

-(BOOL)textFieldShouldReturn:(UITextField*)textfield{
	[textfield resignFirstResponder];
	return YES;
}


- (IBAction)registerButtonAction:(id)sender
{
    
    [commonTextField resignFirstResponder];
    
    dataArray = [[NSMutableArray alloc]init];

    for (int i=0;i<8; i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [register_TableView cellForRowAtIndexPath:path];
        UITextField *textField = (UITextField*)[cell viewWithTag:i+1];
        if (textField.text.length>0) {
           [dataArray addObject:textField.text]; 
        }
        else{
           [dataArray addObject:@""];
        }
        
    }
    
    if ([[dataArray objectAtIndex:0] isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Enter the name" tittle:nil];
        return ;
    }/*else if([[dataArray objectAtIndex:1] isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Enter the age" tittle:nil];
        return ;
    }*/else if([[dataArray objectAtIndex:3] isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Enter the username" tittle:nil];
        return ;
    }else if([[dataArray objectAtIndex:4] isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Enter the password" tittle:nil];
        return ;
    }/*else if([[dataArray objectAtIndex:5] isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Select the Relationship Status" tittle:nil];
        return ;
    }else if([[dataArray objectAtIndex:6] isEqualToString:@""])
    {
        [appDelegate showAlertMessage:@"Select the gender" tittle:nil];
        return ;
    }*/
    
    
    if([[dataArray objectAtIndex:2] isEqualToString:@""]){
        //[appDelegate showAlertMessage:@"Enter the email" tittle:nil];
       // return ;
    }else
    {
        if (![self validateEmail:[dataArray objectAtIndex:2]]){
            [appDelegate showAlertMessage:@"Enter the correct email" tittle:nil];
            return ;
        }
    }
    
    
    
    if(![[dataArray objectAtIndex:7] isEqualToString:@""])
     {
        if ([[dataArray objectAtIndex:7] length] != 14)
           {
            [appDelegate showAlertMessage:@"Enter the correct phone number" tittle:nil];
            return ;
        }
    }
    

    
    
//    if([[dataArray objectAtIndex:7] isEqualToString:@""]){
//        [appDelegate showAlertMessage:@"Enter the phone number" tittle:nil];
//        return ;
//    }else{
//         if ([[dataArray objectAtIndex:7] length] != 14){
//            [appDelegate showAlertMessage:@"Enter the correct phone number" tittle:nil];
//            return ;
//        }
//    }
    
    [appDelegate startAnimatingIndicatorView];
    
    [self performSelector:@selector(callSubmitData) withObject:nil afterDelay:.1];
    
        
}
-(void)callSubmitData
{
    
    
    if (imageCreate) {
        dataImage = [UIImageJPEGRepresentation(imageCreate, 1.0) retain] ;
    }
    
    NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:[dataArray objectAtIndex:0] forKey:@"Name"];
    NSString *age=[dataArray objectAtIndex:1];
    if (age.length>0)
    [localDoct setValue:[dataArray objectAtIndex:1] forKey:@"Age"];
    else
     [localDoct setValue:[NSString stringWithFormat:@"%i",0] forKey:@"Age"];    
    [localDoct setValue:[dataArray objectAtIndex:2] forKey:@"EmailAddress"];
    [localDoct setValue:[dataArray objectAtIndex:3] forKey:@"UserName"];
    [localDoct setValue:[dataArray objectAtIndex:4] forKey:@"Password"];
    [localDoct setValue:[dataArray objectAtIndex:5] forKey:@"RelationshipStatus"];
    [localDoct setValue:[dataArray objectAtIndex:6] forKey:@"Gender"];
    [localDoct setValue:[dataArray objectAtIndex:7] forKey:@"PhoneNo"];
    [localDoct setValue:[NSNumber numberWithInt:1] forKey:@"RegisterType"];
    [localDoct setValue:latitude forKey:@"Latitude"];
    [localDoct setValue:longitude forKey:@"longitude"];
    [localDoct setValue:[NSString stringWithFormat:@"%i",0] forKey:@"UserId"];
    if (dataImage) {
        NSString *strImageData = [RegisterViewController base64forData:dataImage];
        if(strImageData)
        [localDoct setValue:strImageData forKey:@"Photo"];
    }
    
    
   
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp postParseInfoWithUrlPath:KSaveUser WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
    
    [dataArray release];
    
    [imageCreate release];
    imageCreate = nil;
    
//    [dataImage release];
//     dataImage = nil;
    

}

+ (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

//from: http://www.cocoadev.com/index.pl?BaseSixtyFour
+ (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}

- (IBAction)cancelButtonAction:(id)sender {
      [commonTextField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [APPDELEGATE createTabView];
}


#pragma mark INSTENCEMETHODS

-(BOOL) validateEmail: (NSString *) email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
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
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Successfully registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        _RELEASE(errorAlert);
        
        [dataImage release];
        
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
        //NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}



@end
