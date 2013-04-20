//
//  BluetoothViewController.h
//  Bluetooth1
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//


#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "gameView.h"

// Does the bluetooth connection between two devices and also does sending data between these devices.

@interface BluetoothViewController : UIViewController <GKPeerPickerControllerDelegate, GKSessionDelegate, childDelegate>
{
    GKSession *currentSession;
    gameView *game;
    NSString *gkpeerId;
    int myRandNo;
    UILabel *announcementLabel;
    NSTimer *gameTimer;
    int opponentScore;
   }

//GkSession iVars to establish connection between two iOS devices
@property (nonatomic, retain) GKSession *currentSession;


@property (nonatomic,retain) NSString *gkpeerId;
@property(nonatomic,retain) gameView *game;
@property(nonatomic, weak) IBOutlet UILabel *totalLives;
@property(nonatomic, weak) IBOutlet UILabel *minesLeft;
@property(nonatomic, weak) IBOutlet UILabel *gameScore;
@property(nonatomic, weak) IBOutlet UILabel *gameTime;


//instance methods

-(void) mySendDataToPeers:(NSData *) data;
-(void)disconnectSession;

@end

