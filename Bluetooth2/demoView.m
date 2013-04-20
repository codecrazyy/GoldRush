//
//  demoView.m
//  GameViewController
//
//  Copyright (c) 2013 Aparna Srinivasan & Gurupur Sushma Pai All rights reserved.
//

#import "demoView.h"

@implementation demoView

// Generates automatically the setters and getters for instance variables.
@synthesize demoWorker,
demoImageholder,
demoImagePoints,
demoGoldPoints,
demoGameLives,
demoGameScore,
demoGameTime,
demoGameMines,
goldImageholder,
pointIndex,
firstpoint,
secondpoint,
demoImageholder2,
pointsCounter;


// Constants and local variables.
const int demospeed = 5;
int demostepsX = 0, demostepsY = 0, demoNumber = 0;
int demotimeRemaining = 10;
const int demototalGameTime = 10;
int demolivesCount = 0;
const int demototalGold = 9;
bool changeLabel = NO;

// designated initializer
-(id) initWithFrame:(CGRect)frame
       andTime     :(UILabel *) label
      andScore     :(UILabel *)score
      andLives     :(UILabel *) lives
          andMines :(UILabel *) mines

{
    demoGameLives = lives;
    demoGameScore = score;
    demoGameTime = label;
    demoGameMines = mines;
    
    self = [self initWithFrame:frame];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Add the start banner
        CGRect startRectangle = CGRectMake(0, 140, 40, 30);
        UIImageView *startBanner = [[UIImageView alloc] initWithFrame:(startRectangle)];
        UIImage *start = [UIImage imageNamed:@"start.png"];
        [startBanner setImage:start];
        [self addSubview:startBanner];
        
        
        // Add the entry location.
        CGRect entryRectangle = CGRectMake(0, 170, 50, 80);
        startHolder = [[UIImageView alloc] initWithFrame:(entryRectangle)];
        UIImage *entry = [UIImage imageNamed:@"entry1.png"];
        [startHolder setImage:entry];
        [self addSubview:startHolder];
        
        // Add a gold icon which will be picked up by the worker.
        CGRect goldRectangle = CGRectMake(151, 150, 20, 20);
        goldImageholder = [[UIImageView alloc] initWithFrame:(goldRectangle)];
        UIImage *gold = [UIImage imageNamed:@"coin.png"];
        [goldImageholder setImage:gold];
        [self addSubview:goldImageholder];
        
        
        // Creates the patch effect on the ground.
        [self createThePatchesOnGround];
        
        // Coordinates where the rocks will be placed.
        int rockYCordinate[] = {80, 40, 190, 100, 140};
        int rockXCoordinate[] = {20, 210, 260, 70, 380};
        
        
        // Add the rocks.
        for(int i = 0; i < 5 ; ++i)
        {
            
            CGRect rockRectanglei = CGRectMake(rockXCoordinate[i], rockYCordinate[i], 20, 20);
            UIImageView *rockHolderi = [[UIImageView alloc] initWithFrame:(rockRectanglei)];
            UIImage *rock = [UIImage imageNamed:@"rock.png"];
            [rockHolderi setImage:rock];
            [self addSubview:rockHolderi];
            
        }
        
        // Positions of the shrubs.
        int shrubX[] = {300, 200, 130, 65, 420};
        int shrubY[] = {10, 160, 30, 150, 100};
        
        // Add the shrubs
        for(int i = 0; i < 5 ; i++)
        {
            CGRect shrubRect = CGRectMake(shrubX[i], shrubY[i], 30, 20);
            UIImageView *shrubView = [[UIImageView alloc]initWithFrame:shrubRect];
            UIImage *shrub = [UIImage imageNamed:@"shrub.png"];
            [shrubView setImage:shrub];
            [self addSubview:shrubView];
        }
        
        // Coordinates where the gold will be placed.
        int yCordinate[] = {20, 30, 190, 172, 180,  90, 120, 35, 150};
        int xCoordinate[] = {2, 300, 350, 150, 400,  100, 450, 175, 380};
        
        demoGoldPoints = [[NSMutableArray alloc] initWithCapacity:demototalGold];
        
        // Add the remaining gold icons.
        for(int i = 0; i < demototalGold ; ++i)
        {
            CGRect goldRectanglei = CGRectMake(xCoordinate[i], yCordinate[i], 20, 20);
            UIImageView *goldHolderi = [[UIImageView alloc] initWithFrame:(goldRectanglei)];
            UIImage *goldi = [UIImage imageNamed:@"coin.png"];
            [goldHolderi setImage:goldi];
            [self addSubview:goldHolderi];
            [demoGoldPoints addObject:goldHolderi];
        }
        
        
        // Add labels that will display some help texts.
        CGRect labelRect = CGRectMake(200, 100, 200, 50);
        helpLabel = [[UILabel alloc]initWithFrame:labelRect];
        
        helpLabel.backgroundColor = [UIColor clearColor];
        helpLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
        [helpLabel adjustsFontSizeToFitWidth];
        helpLabel.numberOfLines = 0;
        helpLabel.text = @"Using swip gesture, draw the path for the worker to move.";
        [self addSubview:helpLabel];
        
        // Second label that will display the demo text.
        CGRect labelRect2 = CGRectMake(100, 10, 150, 50);
        helpLabel2 = [[UILabel alloc]initWithFrame:labelRect2];
        helpLabel2.backgroundColor = [UIColor clearColor];
        helpLabel2.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
        [helpLabel2 adjustsFontSizeToFitWidth];
        helpLabel2.numberOfLines = 0;
        [self addSubview:helpLabel2];
        
        // Third label placed near the lives count.
        CGRect labelRect3 = CGRectMake(340, 10, 100, 50);
        helpLabel3 = [[UILabel alloc]initWithFrame:labelRect3];
        helpLabel3.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:13];
        helpLabel3.backgroundColor = [UIColor clearColor];
        [helpLabel3 adjustsFontSizeToFitWidth];
        helpLabel3.numberOfLines = 0;
        [self addSubview:helpLabel3];
        
        UIImage *goldBar = [UIImage imageNamed:@"bar3.jpeg"];
        UIImage *mine = [UIImage imageNamed:@"bomb.png"];
        
        // Add a button to be tapped for picking up the gold.
        UIButton *goldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [goldButton setImage:goldBar forState:UIControlStateNormal];
        goldButton.frame = CGRectMake(0, 0 , 40.0, 40.0);
        [self addSubview:goldButton];
        
        //Add a button to be tapped to place a mine.
        UIButton *mineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [mineButton setImage:mine forState:UIControlStateNormal];
        mineButton.frame = CGRectMake(440.0, 0 , 40.0, 40.0);
        [self addSubview:mineButton];
        pointsCounter = 0;
        
        demoTimerStarted = NO;
        
        demolivesCount = demoGameLives.text.integerValue;
        
        [self workerAtStartingPosition];
        
        NSLog(@"%d,%d,%d",demoGameScore.text.integerValue,demoGameLives.text.integerValue,demoGameTime.text.integerValue);
        
    }
    return self;
}

// creates the patch effect on the view.
-(void) createThePatchesOnGround
{
    // Add the patches to the ground.
    CGRect patchRect = CGRectMake(140, 70, 200, 25);
    UIImageView *patchView = [[UIImageView alloc]initWithFrame:patchRect];
    UIImage *patch = [UIImage imageNamed:@"groundpatch.png"];
    [patchView setImage:patch];
    [self addSubview:patchView];
    
    CGRect patchRect2 = CGRectMake(300, 180, 180, 25);
    UIImageView *patchView2 = [[UIImageView alloc]initWithFrame:patchRect2];
    UIImage *patch2 = [UIImage imageNamed:@"groundpatch.png"];
    [patchView2 setImage:patch2];
    [self addSubview:patchView2];
    
    CGRect patchRect3 = CGRectMake(250, 20, 100, 15);
    UIImageView *patchView3 = [[UIImageView alloc]initWithFrame:patchRect3];
    UIImage *patch3 = [UIImage imageNamed:@"groundpatch.png"];
    [patchView3 setImage:patch3];
    [self addSubview:patchView3];
    
    CGRect patchRect4 = CGRectMake(60, 200, 100, 25);
    UIImageView *patchView4 = [[UIImageView alloc]initWithFrame:patchRect4];
    UIImage *patch4 = [UIImage imageNamed:@"groundpatch.png"];
    [patchView4 setImage:patch4];
    [self addSubview:patchView4];
    
    CGRect patchRect5 = CGRectMake(40, 20, 100, 15);
    UIImageView *patchView5 = [[UIImageView alloc]initWithFrame:patchRect5];
    UIImage *patch5 = [UIImage imageNamed:@"groundpatch.png"];
    [patchView5 setImage:patch5];
    [self addSubview:patchView5];
    
    
    
}



// Creates the background of the demo screen.
-(void) colorTheView
{
    
    CGFloat nRed1= 102.0 /255.0;
    CGFloat nBlue1= 51.0 /255.0;
    CGFloat nGreen1= 0;
    
    
    CGFloat nRed2=139.0/255.0;
    CGFloat nBlue2=105.0/255.0;
    CGFloat nGreen2=20.0/255.0;
    
    /*brick
     CGFloat nRed3=156.0/255.0;
     CGFloat nBlue3=102.0/255.0;
     CGFloat nGreen3=31.0/255.0;*/
    
    //orange 4
    CGFloat nRed4=139.0/255.0;
    CGFloat nBlue4=90.0/255.0;
    CGFloat nGreen4=0.0/255.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGFloat baseViewColors[] =
    {
        nRed1, nBlue1, nGreen1, 1.0,
        nRed2, nBlue2, nGreen2, 1.0,
        nRed4, nBlue4, nGreen4, 0.1,
    };
    
    CGFloat locations[] = {0.0,0.8, 1.0};
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef viewBackground = CGGradientCreateWithColorComponents(baseSpace, baseViewColors, locations, 3);
    
    
    CGRect square = CGRectMake(0, 0, 480, 260);
    
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(square), CGRectGetMinY(square));
    CGPoint endPoint   = CGPointMake(CGRectGetMidX(square), CGRectGetMaxY(square));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, square);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, viewBackground, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    
    CGGradientRelease(viewBackground),
    viewBackground = NULL;
    
}


// Places the worker at the starting position.
-(void) workerAtStartingPosition
{
        
    // Add the worker image/icon to view.
    CGRect rectangle = CGRectMake(50, 180, 40, 60);
    demoImageholder = [[UIImageView alloc] initWithFrame:(rectangle)];
    
    UIImage *image = [UIImage imageNamed:@"worker.png"];
    [demoImageholder setImage:image];
    
    [self addSubview:demoImageholder];
    
}


// Makes the label disappear after sometime.
-(void) makeLabelDisappear
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:
     ^{
         // Fade the label
         [helpLabel setAlpha:0];
     }
                     completion:NULL];
    
}

- (void)drawRect:(CGRect)rect
{
    // Set the background color of the view.
    [self colorTheView];
    
    
    // Draw the line indicating the path that the image worker needs to follow
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    
    CGContextMoveToPoint(ctx, (demoImageholder.center.x + 20),(demoImageholder.center.y + 30) );
    CGContextAddLineToPoint(ctx, 160, 150);
    CGContextStrokePath(ctx);
    
    
    // Update the label for the next message.
    [helpLabel performSelector:@selector(setText:)
                    withObject:@"The worker moves along the path"
                    afterDelay:2.0];
    
    // Timer function to call the move image method.
    demoImageTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(moveImage) userInfo:nil repeats:YES];
    
    // Update the label to pick up the gold.
    [helpLabel performSelector:@selector(setText:)
                    withObject:@" Tap on the gold bar on left corner to pick up the gold"
                    afterDelay:7.0];
    
    [NSTimer scheduledTimerWithTimeInterval:8.5 target:self selector:@selector(goldPicked) userInfo:nil repeats:NO];
    
    [helpLabel performSelector:@selector(setText:)
                    withObject:@" "
                    afterDelay:11.5];
    
    // Update the second help label near the score.
    [helpLabel2 performSelector:@selector(setText:)
                     withObject:@" After the gold is picked, the score is updated."
                     afterDelay:11.5];
    
    [demoGameScore performSelector:@selector(setText:)
                        withObject:@"10"
                        afterDelay:13.5];
    
    [helpLabel2 performSelector:@selector(setText:)
                     withObject:@" "
                     afterDelay:16.5];
    
    
    // Rules for placing mines.
    [helpLabel performSelector:@selector(setText:)
                    withObject:@" The player can place the mines on the way by tapping on mine icon on the top right corner."
                    afterDelay:16.5];
    
    
    [NSTimer scheduledTimerWithTimeInterval:18.5 target:self selector:@selector(placeMines) userInfo:nil repeats:NO];
    
    // Update the label if the user does not reach the base before time.
    [helpLabel performSelector:@selector(setText:)
                    withObject:@" Before the timer reaches zero, the worker needs to reach the start with gold"
                    afterDelay:21.0];
    
    [helpLabel performSelector:@selector(setText:)
                    withObject:@" Else a skull appears indicating that the player has lost a chance"                    afterDelay:23.0];
    
    [demoGameTime performSelector:@selector(setText:)
                       withObject:@"0"
                       afterDelay:25.0];
    
    // Indicates the player lost a chance by placing a skull image at the postion of worker image.
    [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(lostChance) userInfo:nil repeats:NO];
    
    [helpLabel performSelector:@selector(setText:)
                    withObject:@" "
                    afterDelay:28.0];
    
    // The total lives is reduced by one.
    [helpLabel3 performSelector:@selector(setText:)
                     withObject:@" The lives count is reduced by one."
                     afterDelay:28.5];
    
    [demoGameLives performSelector:@selector(setText:)
                        withObject:@"2"
                        afterDelay:30.0];
    
    [helpLabel3 performSelector:@selector(setText:)
                     withObject:@""
                     afterDelay:33.5];
    
    // Indicates end of game.
    [helpLabel performSelector:@selector(setText:)
                    withObject:@"When the lives count reaches zero or "
                    afterDelay:33.5];
    [helpLabel performSelector:@selector(setText:)
                    withObject:@"killed by stepping on peer's mines"
                    afterDelay:35.5];
    
    [helpLabel performSelector:@selector(setText:)
                    withObject:@"The game comes to an end "
                    afterDelay:37.5];
}

// Make the gold icon hidden , indicating the gold has been picked up by the worker.

-(void) goldPicked
{
    goldImageholder.image = nil;
}


// Resets the frame of the image within the given timer interval.
-(void)moveImage
{
    demoImageholder.center = CGPointMake(150,150);
    
}


// Places a skull image in place of the worker image when the timer expires.
-(void)lostChance
{
    demoImageholder.image = nil;
    
    // Add the skull image/icon to view.
    CGRect rectangle = CGRectMake(demoImageholder.center.x - 10, demoImageholder.center.y - 10, demoImageholder.frame.size.width - 20, demoImageholder.frame.size.height - 20);
    demoImageholder2 = [[UIImageView alloc] initWithFrame:(rectangle)];
    UIImage *image = [UIImage imageNamed:@"sk(1).jpg"];
    [demoImageholder2 setImage:image];
    
    [self addSubview:demoImageholder2];
    
    
}

// Places the mine at the specific location.
- (void) placeMines
{
    
    // Add mine to the view.
    CGRect mineRect = CGRectMake(demoImageholder.center.x + 5, demoImageholder.center.y - 10, demoImageholder.frame.size.width - 20, demoImageholder.frame.size.height - 30);
    goldImageholder = [[UIImageView alloc]initWithFrame:mineRect];
    UIImage *image = [UIImage imageNamed:@"bomb.png"];
    [goldImageholder setImage:image];
    
    [self addSubview:goldImageholder];
    
    demoGameMines.text = @"9";
    
}
@end
