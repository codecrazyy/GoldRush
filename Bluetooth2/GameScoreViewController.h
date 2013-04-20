//
//  GameScoreViewController.h
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.


// Displays the scores after the game ends.

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>


@interface GameScoreViewController : UIViewController
{
    int listCapacity;
    NSString *plistPath;
    int numberValue;
    int numberOfGamesWon;
}

// Instance variables.

@property (nonatomic, weak) IBOutlet UILabel *message1;
@property (nonatomic, weak) IBOutlet UILabel *message2;
@property(nonatomic, weak) IBOutlet UILabel *yourScore;
@property(nonatomic, weak) IBOutlet UILabel *opponentScore;

@property(nonatomic, assign)NSNumber *gamesWon;
@property(nonatomic, assign) NSNumber *totalPlayed;
@property(nonatomic,strong) NSMutableArray *scoresList;
@property(nonatomic, assign) NSMutableArray *gameScoreList;
@property() int yourGameScore;
@property() int opponentGameScore;


// Instance method.
-(void) passScores:(int )myscore peerScore:(int )peerscore;
-(IBAction)goToMainMenu:(id)sender;
-(void) getTotalGamesAndTotalWonData;
-(void) makeEntryToScoreList;

@end
