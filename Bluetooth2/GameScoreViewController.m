//
//  GameScoreViewController.m
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.

#import "GameScoreViewController.h"


@implementation GameScoreViewController

// Generates the setter and getter methods.
@synthesize message1,
yourScore,
yourGameScore,
opponentGameScore,
totalPlayed,
gamesWon,
message2,
opponentScore;


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


// Displays a message and the scores of the player and the opponent player.
-(void) passScores:(int )myscore peerScore:(int )peerscore
{
    yourGameScore = myscore;
    opponentGameScore = peerscore;
    
    if(yourGameScore > opponentGameScore)
    {
        message1.text = @" Congratulations";
        message2.text = @" You won !";
    }
    if(yourGameScore < opponentGameScore)
    {
        message1.text = @"Sorry. You lost.";
        [message1 adjustsFontSizeToFitWidth];
    }
    if(yourGameScore == opponentGameScore)
    {
        message1.text = @"Its a draw !!";
    }
    
    yourScore.text = [NSString stringWithFormat:@"%d",myscore];
    
    opponentScore.text = [NSString stringWithFormat:@"%d",peerscore];
    
    [self makeEntryToScoreList];
}


// Makes an entry into the plist file.
-(void) makeEntryToScoreList
{
    [self getTotalGamesAndTotalWonData];
    
    NSNumber *newTotalGamesWon;
    
    // Increment the total games played counter.
    //int numberValue = [totalPlayed intValue];
    numberValue = numberValue + 1;
    NSNumber *newTotalGamesPlayed = [NSNumber numberWithInt:numberValue];
    
    // Increment the games won number if the player wins against opponent.
    if(yourGameScore > opponentGameScore)
    {
        numberOfGamesWon = numberOfGamesWon + 1;
    }
    newTotalGamesWon = [NSNumber numberWithInt:numberOfGamesWon];
    
    NSNumber *playerScore = [NSNumber numberWithInt:yourGameScore];
    
    NSNumber *addRecentScore = [NSNumber numberWithInt:yourGameScore];
    
    // Create a array with capacity more than the existing array.
    NSMutableArray *newScoresList = [[NSMutableArray alloc]init];
    newScoresList = _scoresList;
    [newScoresList addObject:playerScore];
    
    
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // get the path to our Data/plist file
    NSString *path = [documentsPath stringByAppendingPathComponent:@"gameScoreList.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"gameScoreList" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath:path error:NULL];
    }
    
    
    NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [plist setValue:newTotalGamesPlayed forKey:@"totalGames"];
    [plist setValue:newTotalGamesWon forKey:@"totalWon"];
    [plist setValue:newScoresList forKey:@"scores"];
    [plist setValue:addRecentScore forKey:@"recentScore"];
    
    // write to file.
    [plist writeToFile:path atomically:YES];
    
    
}

// Get the plist information.
-(void) getTotalGamesAndTotalWonData
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    
    // get the path to our Data/plist file
    plistPath = [documentsPath stringByAppendingPathComponent:@"gameScoreList.plist"];
    
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
    totalPlayed = [temp objectForKey:@"totalGames"];
    gamesWon = [temp objectForKey:@"totalWon"];
    _scoresList = [NSMutableArray arrayWithArray:[temp objectForKey:@"scores"]];
    numberValue = [totalPlayed intValue];
    numberOfGamesWon = [gamesWon intValue];
  
}

// Return to the main menu for different options.
-(IBAction)goToMainMenu:(id)sender
{
   
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

@end
