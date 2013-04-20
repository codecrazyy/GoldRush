//
//  demoView.h
//  GameViewController
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan 
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

#import <UIKit/UIKit.h>

// View that displays the demo or tutorial of the game.
@interface demoView : UIView
{
    NSTimer *demoImageTimer;
    NSTimer *demoGameTimer;
    NSTimer *helpLabelTimer;
    
    BOOL demoTimerStarted;
    UIImageView *demoStartHolder;
    NSMutableArray *demoGoldPoints;
    
    UILabel *helpLabel;
    UILabel *helpLabel2;
    UILabel *helpLabel3;
    UIColor *viewColor;
    UIImageView *startHolder;

    
}

// Instance variables.
@property(strong, nonatomic) IBOutlet UIImageView *demoWorker;
@property(strong,nonatomic) UIImageView *demoImageholder;
@property(strong,nonatomic) UIImageView *demoImageholder2;
@property(strong,nonatomic) UIImageView *goldImageholder;

@property(retain,nonatomic) NSMutableArray *demoImagePoints;
@property(retain,nonatomic) NSMutableArray *demoGoldPoints;
@property(weak,nonatomic) UILabel *demoGameScore;
@property(weak,nonatomic) UILabel *demoGameTime;
@property(weak,nonatomic) UILabel *demoGameLives;
@property(weak,nonatomic) UILabel *demoGameMines;

@property() int pointsCounter;
@property() int pointIndex;
@property() CGPoint firstpoint;
@property() CGPoint secondpoint;


// Designated initializer.
-(id) initWithFrame:(CGRect)frame
       andTime     :(UILabel *) time
      andScore     :(UILabel *) score
      andLives     :(UILabel *) lives
      andMines     :(UILabel *) mines;


@end
