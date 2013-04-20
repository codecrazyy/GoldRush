//
//  gameView.h
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.//

// This view is the main game screen.

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class gameView;

// Protocol defined which is used to communicate with the bluetooth view controller.
@protocol childDelegate
@required
-(void) displayScoreView:(gameView *)gameScreen andFinalScore:(int) finalScore;
-(void) peerMoveDone:(gameView *)gameScreen score:(int)myscore;
-(void) peerMine:(gameView *)gameScreen position:(CGPoint)point;
-(void) sendGoldLocation:(gameView *)gameScreen position:(CGPoint)point label:(BOOL)goldLabel;
-(void) opponentDeath:(gameView *)gameScreen position:(CGPoint)point goldValue:(int)val andScore:(int)score;
@end

@interface gameView : UIView<UIAlertViewDelegate,AVAudioPlayerDelegate>
{
    // Instance variables.
    NSTimer *imageTimer;
    NSTimer *gameTimer;
    UILabel *gameTime;
    UILabel *gameScore;
    UILabel *gameLives;
    UILabel *minesLeft;
    BOOL timerStarted;
    UIImageView *startHolder;
    UIImageView *startLocationHolder;
    NSMutableArray *goldPoints;
    BOOL turn;
    BOOL single;
    NSMutableArray *opponentPoints;
    __weak id<childDelegate> childdelegate;
    UIAlertView *turnAlert;
    int gameScoreCurrentTurn;
    UILabel *placedGoldValue;
    CGPoint mineCheck;
    AVAudioPlayer *timerSound;
    AVAudioPlayer *blastSound;
    
    UIButton *goldButton;
    UIButton *mineButton;
    
}

// Instance variables.
@property(strong, nonatomic) IBOutlet UIImageView *worker;
@property(strong,nonatomic) UIImageView *imageholder;
@property(retain,nonatomic) NSMutableArray *imagePoints;
@property(retain,nonatomic) NSMutableArray *goldPoints;
@property(retain,nonatomic) NSMutableArray *minePoints;

@property (nonatomic, weak) id<childDelegate> childdelegate;

@property() int pointsCounter;
@property() int pointIndex;
@property() CGPoint firstpoint;
@property() CGPoint secondpoint;
@property (nonatomic, strong) UIAlertView *turnAlert;
@property (nonatomic, strong) UIAlertView *endAlert;


//Instance methods.
-(void) moveImage;
-(void) startMovement:(NSMutableArray *)imageP;
-(void) opponentMove:(CGPoint)array;
-(void) addOpponentMinePosition:(CGPoint)points;
-(void) turnChange;
-(void) enableView;
-(void) goldDisappear:(CGPoint)point withVal:(BOOL)boolVal;
-(void) displayPeerDeath:(CGPoint)point value:(int)val;
-(void) initTimer;
-(void) startTimer;
-(void) workerAtStartingPosition;

// Designated initializers.
-(id) initWithFrame:(CGRect)frame
      andLabel     :(UILabel *) label
      andScore     :(UILabel *) score
      andLives     :(UILabel *) lives
      andMines     :(UILabel *) mines
      andDelegate:(id<childDelegate>)delegateObject;

@end