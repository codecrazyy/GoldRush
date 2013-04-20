//
//  ViewController.h
//  Bluetooth2
//
//  CCreated by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

//the main view controller is bluetooth view controller
#import <UIKit/UIKit.h>
#import "firstView.h"

@interface ViewController : UIViewController
{
    // Instance variables.
    IBOutlet UIButton *start;
    firstView *firstview;
}

@property(nonatomic,retain) UIButton *start;


@end
