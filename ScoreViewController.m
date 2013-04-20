//
//  ScoreViewController.m
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

#import "ScoreViewController.h"


@implementation ScoreViewController


// Generates the setter and getter methods automatically.
@synthesize totalGamesPlayed,
totalGamesWon,
bestScoreTillDate,
plistGamesPlayed,
plistGamesWon,
scoresList;


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
    
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"gameScoreList.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"gameScoreList" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // assign values
    plistGamesPlayed = [temp objectForKey:@"totalGames"];
    plistGamesWon = [temp objectForKey:@"totalWon"];
    
    scoresList = [NSMutableArray arrayWithArray:[temp objectForKey:@"scores"]];
    NSLog(@"%d",[scoresList count]);
    // display values
    
    totalGamesWon.text = plistGamesWon.stringValue;
    totalGamesPlayed.text = plistGamesPlayed.stringValue;
    
    // pick up the best score from the list.
    int maxValue = 0;
    for(int i = 0 ; i < [scoresList count]; i++)
    {
        
        NSNumber *score  = [scoresList objectAtIndex:i];
        int currentValue = score.intValue;
        
        if(currentValue > maxValue)
            maxValue = currentValue;
    }
    // NSNumber *maximum = [scoresList valueForKeyPath:@"@max.self"];
    bestScoreTillDate.text = [NSString stringWithFormat:@"%d",maxValue];
    
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
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationLandscapeRight);
}

//to go back to the main menu
-(IBAction)goToMainMenu:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
