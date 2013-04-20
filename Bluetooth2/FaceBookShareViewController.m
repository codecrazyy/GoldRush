//
//  FaceBookShareViewController.m
//  Bluetooth2
//Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.

//

// Post the recent score to the facebook, if wished.
#import "FaceBookShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FaceBookShareViewController

@synthesize playerScore;
@synthesize buttonPostStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//to load the facebook login as part of the view loading and read the recent game score from the plist
- (void)viewDidLoad
{
    [super viewDidLoad];
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];
    
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // get the path to our Data/plist file
    plistPath = [documentsPath stringByAppendingPathComponent:@"gameScoreList.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"gameScoreList" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // read the recent score from the
   score = [temp objectForKey:@"recentScore"];
    
    playerScore.text = [NSString stringWithFormat:@"%d",[score intValue]];
    
	// Do any additional setup after loading the view.
}


// Return to the main menu for different options.
-(IBAction)goToMainMenu:(id)sender
{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    self.buttonPostStatus.enabled = YES;
    
}
//to get user 
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
          self.loggedInUser = user;
}
//to show logged out 
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    BOOL canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
  
    self.buttonPostStatus.enabled = canShareAnyhow;
     
    self.labelFirstName.text = nil;
    self.loggedInUser = nil;
}



- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    //login view error handler
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    //to post to facebook
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
               [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                               
                                            }];
    } else {
        action();
    }
    
}
//button user has to click to post to facebook
- (IBAction)postStatusUpdateClick:(UIButton *)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
      NSLog(@"inside poststatus");
    
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:nil
                                                                          image:nil
                                                                            url:nil
                                                                        handler:nil];
    int yourGameScore=[score intValue];
    if (!displayedNativeDialog) {
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            NSString *message = [NSString stringWithFormat:@"Updating status for %@. Bagged gold worth %d points in Gold Rush ", self.loggedInUser.first_name, yourGameScore];
            
            [FBRequestConnection startForPostStatusUpdate:message
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            
                                            [self showAlert:message result:result error:error];
                                            self.buttonPostStatus.enabled = YES;
                                        }];
            
            self.buttonPostStatus.enabled = NO;
        }];
    }
}
//error when posting to facebook fails
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        //NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'",
                    message];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
