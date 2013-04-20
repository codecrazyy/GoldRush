//
//  dummy.m
//  GameViewController
//
//  Created by Estuate on 2/28/13.
//  Copyright (c) 2013 Estuate, Inc. All rights reserved.
//

#import "dummy.h"
#import "DemoViewController.h"

@interface dummy ()

@end

@implementation dummy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)demoview:(id)sender
{
    UIStoryboard *storyboard = self.storyboard;
    DemoViewController *demoVC = [storyboard instantiateViewControllerWithIdentifier:@"demoVC"];
    [self presentViewController:demoVC animated:YES completion:nil];
}
@end
