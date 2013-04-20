//
//  DemoViewController.m
//  GameViewController
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

#import "DemoViewController.h"
#import "demoView.h"

@implementation DemoViewController

// Generates setter and getter methods.
@synthesize demoGameScore,
            demoGameTime,
            demoMinesLeft,
            demoTotalLives;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Add the demo screen view as subview.
    CGRect demoScreen = CGRectMake(0, 60, 480, 260);
    demoView  *screen = [[demoView alloc] initWithFrame:demoScreen andTime:demoGameTime andScore:demoGameScore andLives:demoTotalLives andMines:demoMinesLeft];
    [self.view addSubview:screen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}


// Return to the main menu for different options.
-(IBAction)goToMainMenu:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
