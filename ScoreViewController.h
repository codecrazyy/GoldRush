//
//  ScoreViewController.h
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

#import <UIKit/UIKit.h>

// Displays the score
@interface ScoreViewController : UIViewController


// Instance variables.
@property(nonatomic, weak) IBOutlet UILabel *totalGamesPlayed;
@property(nonatomic, weak) IBOutlet UILabel *totalGamesWon;
@property(nonatomic, weak) IBOutlet UILabel *bestScoreTillDate;

@property(nonatomic, assign) NSNumber *plistGamesPlayed;
@property(nonatomic, assign) NSNumber *plistGamesWon;
@property() NSMutableArray *scoresList;

// Instance method.
-(IBAction)goToMainMenu:(id)sender;


@end
