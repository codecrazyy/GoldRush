//
//  gameView.m
//  Bluetooth2
//
//  Created by Gurupur Sushma Pai & Aparna Srinivasan on 2/19/13.
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.
//

#import "gameView.h"
#import "BluetoothViewController.h"
#import "GoldObject.h"
#import "GameScoreViewController.h"

@implementation gameView

// Generates automatically the setters and getters for instance variables.
@synthesize worker,
            imageholder,
            imagePoints,
            goldPoints,
            pointIndex,
            firstpoint,
            secondpoint,
            minePoints,
            childdelegate,
            turnAlert,
            endAlert,
            pointsCounter;

// Constants and local variables.
const int speed = 5;
bool minePresent = NO;
int stepsX = 0, stepsY = 0, numberInc = 0;
int timeRemaining = 10;
int totalmines=10;
const int totalGameTime = 10;
int livesCount = 0;
int totalGold = 7;
bool backgroundAlreadySet = NO;
const int mineAlert = 1;
const int gameEndAlert = 2;
//const int
//const int peerMoveDone = 1;


// Designated initializer.
-(id) initWithFrame:(CGRect)frame
      andLabel     :(UILabel *) label
      andScore     :(UILabel *)score
      andLives     :(UILabel *) lives
      andMines     :(UILabel *) mines
      andDelegate:(id<childDelegate>)delegateObject
{
    gameLives = lives;
    gameScore = score;
    gameTime = label;
    minesLeft=mines;
    childdelegate = delegateObject;
    self = [self initWithFrame:frame];
    
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Creates the game view.
        [self createTheView];
        
        // Place the worker at start location.
        [self workerAtStartingPosition];
        
        pointsCounter = 0;
        
        timerStarted = NO;
        
        gameScoreCurrentTurn = 0;
        
        livesCount =  gameLives.text.integerValue;
        
        minePoints=[[NSMutableArray alloc]init];
        opponentPoints=[[NSMutableArray alloc]init];
        CGPoint temp;
        temp.x=30;
        temp.y=200;
       
    }
    return self;
}

// Creates the main game screen.
-(void) createTheView
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
    
    //-------- sushmna update start --
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
    
    
    UIImage *goldBar = [UIImage imageNamed:@"goldBar.png"];
    UIImage *mine = [UIImage imageNamed:@"bomb.png"];
    
    // Add a button to be tapped for picking up the gold.
    goldButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goldButton addTarget:self
                   action:@selector(pickUpGold)
         forControlEvents:UIControlEventTouchUpInside];
    [goldButton setBackgroundImage:goldBar forState:UIControlStateNormal];
    [goldButton setTitle:@"Tap" forState:UIControlStateNormal];
    [goldButton setBackgroundColor:[UIColor brownColor]];
    [goldButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [goldButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    
    goldButton.frame = CGRectMake(0, 0 , 40.0, 40.0);
    [self addSubview:goldButton];
    
    //Add a button to be tapped to place a mine.
    mineButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mineButton addTarget:self
                   action:@selector(placeMine)
         forControlEvents:UIControlEventTouchUpInside];
    
    [mineButton setBackgroundImage:mine forState:UIControlStateNormal];
    // [mineButton setBackgroundColor:[UIColor brownColor]];
    [mineButton setTitle:@"Tap" forState:UIControlStateNormal];
    [mineButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [mineButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    mineButton.frame = CGRectMake(440.0, 0 , 40.0, 40.0);
    [self addSubview:mineButton];
    
    
    
   // NSMutableArray *goldX = [[NSMutableArray alloc]init];
    
    /*---------- end ------
    for(int i = 0; i < totalGold ; i++)
    {
        int randomValuei = 50 + (arc4random() % 410);
        [goldX addObject:[NSNumber numberWithInt:randomValuei]];
    }
    
    
     NSArray *goldX = [NSArray arrayWithObjects:[NSNumber numberWithInt:randomValue1];
     [NSNumber numberWithInt:randomValue],
     [NSNumber numberWithInt:randomValue],
     [NSNumber numberWithInt:randomValue],
     [NSNumber numberWithInt:randomValue],
     [NSNumber numberWithInt:randomValue],
     [NSNumber numberWithInt:randomValue],
     [NSNumber numberWithInt:randomValue],
     nil];
     
    NSArray *goldY = [NSArray arrayWithObjects:[NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      [NSNumber numberWithInt:(arc4random() % 200)],
                      nil];
    
    
    NSLog(@"%d",[goldX count]);
    
    */
    
    // Coordinates where the gold will be placed.
    int xCoordinate[] = {40, 80, 80, 150, 250,350, 400};
    int yCordinate[] = {20, 90, 190, 80, 70, 100, 180};
    
    
    //Array that holds all the gold objects.
    goldPoints = [[NSMutableArray alloc] initWithCapacity:totalGold];
    
    
    // Add the gold icons.
    for(int i = 0; i < totalGold ; ++i)
    {
        GoldObject *goldObjecti = [GoldObject new];
        CGRect goldRectanglei = CGRectMake(xCoordinate[i], yCordinate[i], 25, 25);
        goldObjecti.goldImage = [[UIImageView alloc] initWithFrame:(goldRectanglei)];
        goldObjecti.goldValue = 10;
        UIImage *goldi = [UIImage imageNamed:@"coin.png"];
        [goldObjecti.goldImage setImage:goldi];
        [self addSubview:goldObjecti.goldImage];
        [goldPoints addObject:goldObjecti];
    }
    
    
    
}

-(void) createThePatchesOnGround
{
    // Add the patches to the ground.
    CGRect patchRect = CGRectMake(140, 100, 200, 25);
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
// Check if the worker is near the gold. If yes , pick up gold
// and update score.
-(void) pickUpGold
{
    for(int i = 0; i < totalGold ; ++i)
    {
        GoldObject *goldFound = [goldPoints objectAtIndex:i];
        UIImageView *matched = goldFound.goldImage;
        
        BOOL reachedGold = CGRectIntersectsRect(matched.frame, imageholder.frame);
        
        if(reachedGold)
        {
            if(goldFound.placedByPlayer)
            {
                placedGoldValue.hidden=YES;
            }
            int gameScoreTillDate = gameScore.text.integerValue;
            
            CGPoint sendGoldPoint=CGPointMake(goldFound.goldImage.frame.origin.x, goldFound.goldImage.frame.origin.y);
            
            gameScoreCurrentTurn = gameScoreCurrentTurn + goldFound.goldValue;
            
            // Send the gold point and value to the opponent screen.
            
            [self.childdelegate sendGoldLocation:self position:sendGoldPoint label:goldFound.placedByPlayer];
            
            gameScoreTillDate = gameScoreTillDate + goldFound.goldValue;
            
            gameScore.text = [NSString stringWithFormat:@"%d", gameScoreTillDate];
            
            matched.image = nil;
            [goldPoints removeObjectAtIndex:i];
            totalGold = totalGold - 1;
        }
    }
}

// Place mine at a specific location and then reduce the mines count.
-(void) placeMine
{
    CGRect mineLoction = CGRectMake(imageholder.center.x + 10,imageholder.center.y +10, 20, 20);
    UIImageView *mineHolder = [[UIImageView alloc] initWithFrame:(mineLoction)];
    UIImage *mineImg = [UIImage imageNamed:@"bomb.png"];
    [mineHolder setImage:mineImg];
    [self addSubview:mineHolder];
    
    totalmines = totalmines - 1;
    
    // Send the mine points to opponent screen.
    CGPoint point=CGPointMake(imageholder.center.x + 10,imageholder.center.y+10);
    [self.childdelegate peerMine:self position:point];
    
    // If the player tries to place mines, when there are none, then a alert is
    // displayed indicating there are no more mines.
    if(totalmines < 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"No Mines"
                              message:@"You have no mines left."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        alert.tag = mineAlert;
        [alert show];
    }
    else
    {
        minesLeft.text=[NSString stringWithFormat:@"%d",totalmines];
    }
}


// Place the worker at the start location.
-(void) workerAtStartingPosition
{
    // Add the worker image/icon to view.
    CGRect rectangle = CGRectMake(0, 180, 40, 60);
    imageholder = [[UIImageView alloc] initWithFrame:(rectangle)];
    UIImage *image = [UIImage imageNamed:@"worker.png"];
    [imageholder setImage:image];
    [self addSubview:imageholder];
}

// Draws the contents on the screen.
- (void)drawRect:(CGRect)rect
{
    [self colorTheView];
   
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 2.0);
    if(turn==YES)
    {
        // Draw the line on the screen.
        CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
        
        for(int i=0; i< pointsCounter-1; ++i)
        {
            CGPoint point1 = [[imagePoints objectAtIndex:i] CGPointValue];
            CGPoint point2 = [[imagePoints objectAtIndex:i+1] CGPointValue];
            CGContextMoveToPoint(ctx, point1.x, point1.y);
            CGContextAddLineToPoint(ctx, point2.x, point2.y);
            CGContextStrokePath(ctx);
        }
    }
    else
    {
        // Draw the line on the opponent screen.
        CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] CGColor]);
        int total=[opponentPoints count];
        
        for(int i=0; i< total-1 ; ++i)
        {
            CGPoint point1 = [[opponentPoints objectAtIndex:i] CGPointValue];
            CGPoint point2 = [[opponentPoints objectAtIndex:i+1] CGPointValue];
            CGContextMoveToPoint(ctx, point1.x, point1.y);
            CGContextAddLineToPoint(ctx, point2.x, point2.y);
            CGContextStrokePath(ctx);
        }
    }
}

// Display mine at the touch location.
-(void)displayMine:(CGPoint)touchPoint
{
    CGRect minePoint = CGRectMake(touchPoint.x,touchPoint.y, 20, 20);
    UIImageView *mineHolder = [[UIImageView alloc] initWithFrame:(minePoint)];
    UIImage *mineImg = [UIImage imageNamed:@"bomb.png"];
    [mineHolder setImage:mineImg];
    [self addSubview:mineHolder];
    
    // Reduce the mine count.
    minesLeft.text=[NSString stringWithFormat:@"%d",totalmines-1];
}


// Method called when the user first touches the screen.
// Get the location coordinate and save it in a array.
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    imagePoints = [[NSMutableArray alloc]init];
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint touchPosition = [mytouch locationInView: [mytouch view]];
    [imagePoints addObject: [NSValue valueWithCGPoint:[mytouch locationInView:mytouch.view]]];
    NSLog(@"%f",touchPosition.x);
    
    // Start the timer once the touch begins.
    if(timerStarted == NO)
    {
        
       // NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"clock-ticking-1" ofType:@"mp3"];
        //timerSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:NULL];
       // [timerSound play];

        [self  initTimer];
        timerStarted = YES;
    }
    
    turn=YES;
    
}

// Method called when the player moves the finger on the screen.
// The co-ordinates are noted and added to the array.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
       
    pointsCounter = [imagePoints count];
    
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    CGPoint sendPoint=[mytouch locationInView:mytouch.view];
    [imagePoints addObject: [NSValue valueWithCGPoint:[mytouch locationInView:mytouch.view]]];
   
    NSMutableData *data1, *data2;

    //the messagetype to confirm that a peer move is done

    int messageType = 1;
   
    data1 = [NSMutableData dataWithBytes:&messageType length:sizeof(int)];
    data2 = [NSMutableData dataWithBytes:&sendPoint length:sizeof(CGPoint)];
    
    int temp=sizeof(CGPoint);
    [data1 appendData:data2];
    int len=[data1 length];
    NSLog(@"moved msg pt len %d with weight %d",len,temp);
   
    // Send data points to the peer device.
    UIResponder *next = self.nextResponder;
    while (next)
    {
        if ([next isKindOfClass:[BluetoothViewController class]])
        {
            BluetoothViewController *gvc = (BluetoothViewController *) next;
            [gvc mySendDataToPeers:data1];
            break;
        }
        next = next.nextResponder;
    }
    
    
    // Calls the drawRect method - since the screen gets updated.
    
    [self setNeedsDisplay];
        
    
    
}

// Adds the peers mine points into an array.
-(void)addOpponentMinePosition:(CGPoint)points
{
    
    [minePoints addObject: [NSValue valueWithCGPoint:points]];
}


// Makes the gold disapper once its picked up
-(void)goldDisappear:(CGPoint)point withVal:(BOOL)boolVal
{
    for(int i = 0; i < totalGold ; ++i)
    {
        GoldObject *goldFound = [goldPoints objectAtIndex:i];
        UIImageView *matched = goldFound.goldImage;
        
        BOOL reachedGold = CGRectContainsPoint(matched.frame,point);
        
        if(reachedGold)
        {
            matched.image = nil;
            // Hide the label of the gold, if the gold picked up was placed by the opponent.
            if(boolVal)
            {
                    placedGoldValue.hidden=YES;
            }
        }
                    
    }

}

// Displays a skull , gold and its value if present indicating the death of the opponent.
-(void)displayPeerDeath:(CGPoint)point value:(int)val{
    
    CGRect deadImage = CGRectMake(point.x,point.y, imageholder.frame.size.width - 10, imageholder.frame.size.height - 30);
    UIImageView *deadHolder = [[UIImageView alloc] initWithFrame:(deadImage)];
    UIImage *skull = [UIImage imageNamed:@"opponentSkull.png"];
    [deadHolder setImage:skull];
    [self addSubview:deadHolder];

    // Place gold and label indicating the value of gold.
    if(val>0)
    {
        GoldObject *placeGold = [GoldObject new];
        CGRect goldRectangle = CGRectMake(point.x + 30, point.y, 25, 25);
        placeGold.goldImage = [[UIImageView alloc] initWithFrame:(goldRectangle)];
        placeGold.goldValue = val;
        placeGold.placedByPlayer = YES;
        UIImage *gold = [UIImage imageNamed:@"coin.png"];
        [placeGold.goldImage setImage:gold];
        [self addSubview:placeGold.goldImage];
        [goldPoints addObject:placeGold];
        totalGold = totalGold + 1;
        
        CGRect valueRect = CGRectMake(goldRectangle.origin.x + 30, goldRectangle.origin.y , 20, 20);
        placedGoldValue = [[UILabel alloc] initWithFrame:valueRect];
        placedGoldValue.text = [NSString stringWithFormat:@"%d",val];
        placedGoldValue.backgroundColor = [UIColor clearColor];
        [self addSubview:placedGoldValue];
    }
    
}

// Method called when the touch ends. i.e the player lifts the finger off the screen.
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *aTouch in touches)
    {
        if (aTouch.tapCount == 1)
        {
            NSLog(@"inside random taps");
        }
        else
        {
            pointsCounter = [imagePoints count];
    
            // Call the method to start the movement of the image.
            [self startMovement:(imagePoints)];
        }
    }
}



//Starts the movement of the image by fixing the initial coordinates.
-(void) startMovement:(NSMutableArray *)imageP
{
    
    imagePoints = imageP;
    self.userInteractionEnabled=FALSE;
    
    
    pointIndex = 0;
    
    firstpoint = [[imagePoints objectAtIndex:pointIndex] CGPointValue];
    secondpoint = [[imagePoints objectAtIndex:(pointIndex + 1)] CGPointValue];
    
    stepsX = (secondpoint.x - firstpoint.x) / speed;
    stepsY = (secondpoint.y - firstpoint.y) / speed;
    
    // Timer function to call the move image method.
    imageTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(moveImage) userInfo:nil repeats:YES];
    
}

// Resets the frame of the image within the given timer interval.
-(void)moveImage
{
    if(firstpoint.x < secondpoint.x)
    {
        UIImage *workerRight = [UIImage imageNamed:@"worker.png"];
        [imageholder setImage:workerRight];
    }
    if(firstpoint.x > secondpoint.x)
    {
        UIImage *workerLeft = [UIImage imageNamed:@"workerleft.png"];
        [imageholder setImage:workerLeft];
    }
    imageholder.center = CGPointMake(firstpoint.x + (numberInc * speed), firstpoint.y + (numberInc * speed));
    
    
    if([minePoints count]>0)
        [self checkIfSteppedOnMine];
        
    numberInc = numberInc + 1;
    
    if(numberInc >= stepsX)
    {
        pointIndex++;
        if (pointIndex >= (pointsCounter - 1))
        {
            [imageTimer invalidate];
            self.userInteractionEnabled=TRUE;
            mineButton.enabled = YES;
        
            return;
        }
        
        numberInc = 0;
        
        firstpoint = [[imagePoints objectAtIndex:pointIndex] CGPointValue];
        secondpoint = [[imagePoints objectAtIndex:(pointIndex + 1)] CGPointValue];
        
        stepsX = (secondpoint.x - firstpoint.x) / speed;
        stepsY = (secondpoint.y - firstpoint.y) / speed;
        
    }
    
    
}

// Makes the opponent player move.
-(void) opponentMove:(CGPoint)point
{
    turn=NO;
    NSLog(@"CGpoints %f %f",point.x,point.y);
    [opponentPoints addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}


// Initialize the timer.
-(void) initTimer
{
        opponentPoints=[[NSMutableArray alloc]init];
        gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
}

// Start the game timer.
-(void) startTimer
{
    timeRemaining = timeRemaining - 1;
    
    
    // If the timer reaches zero, then a skull appears
    if(timeRemaining < 0)
    {
        [gameTimer invalidate];
        [imageTimer invalidate];
         imageholder.image = nil;
        timerStarted = NO;
        [timerSound stop];
      
        
        //once timer expires change the turn of user
        [self turnChange];
        mineButton.enabled = NO;
        
        NSLog(@"my score sent to peer %d",gameScore.text.integerValue);
      //  [self.childdelegate opponentDeath:<#(gameView *)#> position:<#(CGPoint)#> goldValue:<#(int)#>];
        
        bool reachedStartPoint = CGRectIntersectsRect(startHolder.frame, imageholder.frame);
        
        NSLog(@"reaches = %d",reachedStartPoint);
        
        if (livesCount==1 && reachedStartPoint!=YES)
        {
            ;
        }
        else
        {
            // Send a messgae to the peer indiacating his/her move and also your score.
            [self.childdelegate peerMoveDone:self score:gameScore.text.integerValue];
        }
        if(reachedStartPoint)
        {
            // Reset the timer 
            timeRemaining = totalGameTime;
            gameTime.text = [NSString stringWithFormat:@"%d",totalGameTime];
            gameScoreCurrentTurn=0;
            UIImage *workerRight = [UIImage imageNamed:@"worker.png"];
            [imageholder setImage:workerRight];
            
        }
        else
        {
            [self mineOrTimerLogic];
            
        }
      //  return;
    }
    else
    {
        gameTime.text = [NSString stringWithFormat:@"%d", timeRemaining];
    }
}




-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==mineAlert)
    {
        ;
    }
    else if (alertView.tag==gameEndAlert)
    {
       // Send message to parent indicating end of game and to display score.
        [self.childdelegate displayScoreView:self andFinalScore:gameScore.text.intValue];

    }
   
    else
        ;
       
}


// Sets the turn change.
-(void)turnChange
{
    self.userInteractionEnabled=FALSE;
}

// Enables the view to play.
-(void)enableView
{
    self.userInteractionEnabled=TRUE;
    turnAlert = [[UIAlertView alloc]initWithTitle:@"Turn" message:@"It is your turn to play now" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [turnAlert show];

}


// Creates the background of the demo screen.
-(void) colorTheView
{
    //
    CGFloat nRed1= 102.0 /255.0;    //205.0/255.0;
    CGFloat nBlue1= 51.0 /255.0;   //149.0/255.0;
    CGFloat nGreen1=  0;  //12.0/255.0;

    
    //burlywood
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

// checks if the player has stepped on mine.
-(void) checkIfSteppedOnMine
{
    for(int i = 0 ; i <[minePoints count] - 1; i++)
    {
        NSValue *minePoint = [minePoints objectAtIndex:i];
        mineCheck = [minePoint CGPointValue];
        BOOL checkIfMinePresent = CGRectContainsPoint(imageholder.frame,mineCheck);
        
        // If stepped , then invaliate the timers and send message to peer to indicate the turn.
        if (checkIfMinePresent)
        {
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"blast" ofType:@"mp3"];
            blastSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:NULL];
            [blastSound play];
            
            [gameTimer invalidate];
            [imageTimer invalidate];
            timerStarted = NO;
            minePresent = YES;
            
            
            
            [self turnChange];
            NSLog(@"my score sent to peer %d",gameScore.text.integerValue);
            [self mineOrTimerLogic];
            if(livesCount!=0)
                [self.childdelegate peerMoveDone:self score:gameScore.text.integerValue];
        
            
        }
    }
}


// Method called when a player steps on a mine or
// when the timer goes to zero and the player has not reached the start location.
-(void) mineOrTimerLogic
{
    CGRect deadImage;
    CGPoint current;
    
    // Place a skull indicating that the player is dead
    if(minePresent)
    {
        current=mineCheck;
    }
    else
    {
        current=imageholder.frame.origin;
    }
    
    deadImage = CGRectMake(current.x, current.y, imageholder.frame.size.width - 10, imageholder.frame.size.height - 30);

    minePresent = NO;
    
    UIImageView *lostHolder = [[UIImageView alloc] initWithFrame:(deadImage)];
    UIImage *lost = [UIImage imageNamed:@"sk(1).jpg"];
    [lostHolder setImage:lost];
    [self addSubview:lostHolder];
    
    // Reset the timer.
    timeRemaining = totalGameTime;
    gameTime.text = [NSString stringWithFormat:@"%d",totalGameTime];
   // [timerSound stop];
    imageholder.image = nil;
    
    // Decrement the lives count.
    livesCount --;
    gameLives.text = [NSString stringWithFormat:@"%d",livesCount];
    
    // Decrease the score by how much gold was picked up in that turn.
    int newGameScore = gameScore.text.integerValue;
    newGameScore = newGameScore - gameScoreCurrentTurn ;
    gameScore.text = [NSString stringWithFormat:@"%d",newGameScore];
    
    
    // Place the gold and also display its value, incase picked.
    if(gameScoreCurrentTurn>0)
    {
        GoldObject *placeGold = [GoldObject new];
        CGRect goldRectangle = CGRectMake(imageholder.frame.origin.x + 30, imageholder.frame.origin.y, 25, 25);
        placeGold.goldImage = [[UIImageView alloc] initWithFrame:(goldRectangle)];
        placeGold.goldValue = gameScoreCurrentTurn;
        placeGold.placedByPlayer = YES;
        UIImage *gold = [UIImage imageNamed:@"coin.png"];
        [placeGold.goldImage setImage:gold];
        [self addSubview:placeGold.goldImage];
        [goldPoints addObject:placeGold];
        totalGold = totalGold + 1;
        
        CGRect valueRect = CGRectMake(goldRectangle.origin.x + 30, goldRectangle.origin.y , 20, 20);
        placedGoldValue = [[UILabel alloc] initWithFrame:valueRect];
        placedGoldValue.text = [NSString stringWithFormat:@"%d",gameScoreCurrentTurn];
        
        
        placedGoldValue.backgroundColor = [UIColor clearColor];
        [self addSubview:placedGoldValue];
    }
    if (livesCount!=0)
    {
        [self.childdelegate opponentDeath:self position:current goldValue:gameScoreCurrentTurn andScore:gameScore.text.intValue];//send skull position and gold
    }
   // [blastSound stop];
    gameScoreCurrentTurn = 0;
    
    // Game comes to an end when lives count becomes zero.
    if (livesCount==0)
    {
        gameTime.text = @"0";
        gameLives.text = @"0";
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"You have reached the end of the game. View scores" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [timerSound stop];
        alert.tag=gameEndAlert;
        [alert show];
    }
    else
    {
        [self workerAtStartingPosition];
    }
}



@end



