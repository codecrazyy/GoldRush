//
//  ViewController.m
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

#import "ViewController.h"
#import "HelpViewController.h"
#import "OptionsViewController.h"
#import "ScoreViewController.h"
#import "gameView.h"
#import "BluetoothViewController.h"
#import "DemoViewController.h"
#import "firstView.h"
#import "FaceBookShareViewController.h"

@implementation ViewController

@synthesize start;

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect firstScreen = CGRectMake(0, 0, 320, 480);
    
    firstView *fv=[[firstView alloc]initWithFrame:firstScreen andDelegate:self];
    [self.view addSubview:fv];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction) buttonStart:(firstView *)screen
{
    [firstview removeFromSuperview];
    UIStoryboard *storyboard = self.storyboard;
    BluetoothViewController *blue = [storyboard instantiateViewControllerWithIdentifier:@"blueVC"];
    [self presentViewController:blue animated:YES completion:nil];
  //  [blue bStart:self];
    
}
//method to go to Help view
-(IBAction)goToHelpView:(firstView *)screen
{
    UIStoryboard *storyboard = self.storyboard;
    HelpViewController *helpvc = [storyboard instantiateViewControllerWithIdentifier:@"helpVC"];
    [self presentViewController:helpvc animated:YES completion:nil];
}
//method to go to Options view
-(IBAction)goToShareView:(firstView *)screen
{
    
    
    UIStoryboard *st=self.storyboard;
   FaceBookShareViewController *opt=[st instantiateViewControllerWithIdentifier:@"facebookvc"];
    [self presentViewController:opt animated:(YES) completion:nil];
    
}
//method to go to Score View
-(IBAction)goToScoreView:(firstView *)screen{
    UIStoryboard *st=self.storyboard;
    ScoreViewController *sc=[st instantiateViewControllerWithIdentifier:@"scoreVC"];
    [self presentViewController:sc animated:(YES) completion:nil];
    
    /*
    UIStoryboard *st=self.storyboard;
    FaceBookShareViewController *opt=[st instantiateViewControllerWithIdentifier:@"facebookvc"];
    [self presentViewController:opt animated:(YES) completion:nil];*/

    
}

// method to go to demo view.
-(IBAction)goToDemoView:(firstView *)screen
{
    UIStoryboard *storyboard = self.storyboard;
    DemoViewController *demoVC = [storyboard instantiateViewControllerWithIdentifier:@"demoVC"];
    [self presentViewController:demoVC animated:YES completion:nil];

}
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



@end
