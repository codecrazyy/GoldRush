//
//  FaceBookShareViewController.h
//  Bluetooth2
//
//Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.


// Lets the player post the game score to facebook and share with others
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FaceBookShareViewController : UIViewController<FBLoginViewDelegate>
{
    NSString *plistPath;
    NSNumber *score;
}

@property(nonatomic, weak) IBOutlet UILabel *playerScore;

@property (strong, nonatomic) IBOutlet UIButton *buttonPostStatus;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property (strong, nonatomic) IBOutlet UILabel *labelFirstName;

//methods to post update to facebook
- (IBAction)postStatusUpdateClick:(UIButton *)sender;
//alert if the posting to facebook fails
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error;

//to go back to the main menu

-(IBAction)goToMainMenu:(id)sender;
@end
