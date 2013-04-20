//
//  DemoViewController.h
//  GameViewController
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan 
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

// This is the view  controller that adds the demo screen as subview.
#import <UIKit/UIKit.h>
#import "demoView.h"

@interface DemoViewController : UIViewController

// Instance variables.
@property(nonatomic, weak) IBOutlet UILabel *demoTotalLives;
@property(nonatomic, weak) IBOutlet UILabel *demoMinesLeft;
@property(nonatomic, weak) IBOutlet UILabel *demoGameScore;
@property(nonatomic, weak) IBOutlet UILabel *demoGameTime;

// Instance methods.
-(IBAction)goToMainMenu:(id)sender;

@end
