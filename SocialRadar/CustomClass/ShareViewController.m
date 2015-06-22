/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"

NSString *const kPlaceholderPostMessage = @"Say something about this...";

@interface ShareViewController ()
<UITextViewDelegate,
UIAlertViewDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *postImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postNameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (retain, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;



@end

@implementation ShareViewController

@synthesize postMessageTextView;
@synthesize postImageView;
@synthesize postNameLabel;
@synthesize postCaptionLabel;
@synthesize postDescriptionLabel;
@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;
@synthesize post_text_str;


#pragma mark - Helper methods

/*
 * This sets up the placeholder text.
 */
- (void)resetPostMessage
{
    self.postMessageTextView.text = post_text_str;
    self.postMessageTextView.textColor = [UIColor blackColor];
   
}

/*
 * Publish the story
 */
- (void)publishStory
{
    [APPDELEGATE startAnimatingIndicatorView];
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:@"Failed to Post."
                          /*@"error: domain = %@, code = %d",
                          error.domain, error.code*/];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted successfully." /*action, id: %@",
                          [result objectForKey:@"id"]*/];
         }
           [APPDELEGATE stopAnimatingIndicatorView];
         [[self presentingViewController]
//          dismissModalViewControllerAnimated:YES];  // DAJ depricated 
         presentViewController: self animated:YES completion:nil];
         [APPDELEGATE showtabView];
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];
}

#pragma mark - Initialization methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
       /* self.postParams =
        [[NSMutableDictionary alloc] initWithObjectsAndKeys:
         @"https://developers.facebook.com/ios", @"link",
         @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
         @"Social Radar", @"name",
         @"Social Radar Great App", @"caption",
         @"Strike location from any where.", @"description",
         nil];*/
    }
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
      
    



    // Do any additional setup after loading the view from its nib.

//    // Show placeholder text
    [self resetPostMessage];
//     Set up the post information, hard-coded for this sample
//    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
//    self.postCaptionLabel.text =[self.postParams objectForKey:@"caption"];;
//    [self.postCaptionLabel sizeToFit];
//     self.postDescriptionLabel.text = [self.postParams objectForKey:@"description"];;
//     [self.postDescriptionLabel sizeToFit];
    
//     NSMutableArray* arrays2 = [[DataBaseClass getImageName:nearestBeachObj.BeachID] mutableCopy] ;
    
//    [self.postImageView setImage:[UIImage imageNamed:[arrays2 objectAtIndex:0]]];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
 /*   self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest
                                  requestWithURL:
                                  [NSURL URLWithString:
                                   [self.postParams objectForKey:@"picture"]]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest:
                            imageRequest delegate:self];*/
    
   }

- (void)viewDidUnload
{
    [self setPostMessageTextView:nil];
    [self setPostImageView:nil];
    [self setPostNameLabel:nil];
    [self setPostCaptionLabel:nil];
    [self setPostDescriptionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
    
    if(self.post_text_str)
    {
        [post_text_str release];
        post_text_str=nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 * A simple way to dismiss the message text view:
 * whenever the user clicks outside the view.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] &&
        (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

#pragma mark - Action methods
- (IBAction)cancelButtonAction:(id)sender {
    [[self presentingViewController]
//     dismissModalViewControllerAnimated:YES]; // DAJ depricated
     presentViewController: self animated:YES completion:nil];

}

- (IBAction)shareButtonAction:(id)sender {
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text
          isEqualToString:kPlaceholderPostMessage] &&
        ![self.postMessageTextView.text isEqualToString:@""]) {
        [self.postParams setObject:self.postMessageTextView.text
                            forKey:@"message"];
    }

    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession
         requestNewPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error)
        {
            if (!error) {
                // If permissions granted, publish the story
                [self publishStory];
            }
        }];
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
}

#pragma mark - UITextViewDelegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor lightGrayColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done
    // editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

#pragma mark - UIAlertViewDelegate methods
- (void) alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex
{
   // [[self presentingViewController]
    // dismissModalViewControllerAnimated:YES];
}

@end
