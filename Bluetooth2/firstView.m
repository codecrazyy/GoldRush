//
//  firstView.m
//  firstpage
//
//  Created by Harish Ramakrishnan on 3/8/13.
//  Copyright (c) 2013 Harish Ramakrishnan. All rights reserved.
//

#import "firstView.h"

@implementation firstView

@synthesize delegate;
-(id) initWithFrame:(CGRect)frame
        andDelegate:(id<firstDelegate>)delegateObject
{
    delegate=delegateObject;
    self=[self initWithFrame:frame];
    return self;
}
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetRGBFillColor(context,1,1,1,1);
    CGContextFillRect(context, rect);
    
    CGRect top=CGRectMake(0, 0, 320, 170);
    // CGRect bottom=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    CGContextAddRect(context, top);
    CGContextSetRGBFillColor(context,135/255.0f,206/255.0f,250/255.0f,1);
    //CGContextSetRGBFillColor(context,102/255.0f,178/255.0f,255/255.0f,1);
    CGContextFillRect(context, top);
    
    [self colorTheView];
    
    /* CGRect top=CGRectMake(0, 0, 320, 170);
     // CGRect bottom=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
     CGContextAddRect(context, top);
     CGContextSetRGBFillColor(context,135/255.0f,206/255.0f,250/255.0f,1);
     CGContextFillRect(context, top);*/
    //color for cave
    [self createView];
    
}
-(void) colorTheView
{
    //
    CGFloat nRed1=218/255.0;
    CGFloat nBlue1=165/255.0;
    CGFloat nGreen1=32/255.0;
    
    //burlywood
    CGFloat nRed2=218/255.0;
    CGFloat nBlue2=145.0/255.0;
    CGFloat nGreen2=20.0/255.0;
    
    /*brick
     CGFloat nRed3=156.0/255.0;
     CGFloat nBlue3=102.0/255.0;
     CGFloat nGreen3=31.0/255.0;*/
    
    //orange 4
    CGFloat nRed4=218/255.0;
    CGFloat nBlue4=120.0/255.0;
    CGFloat nGreen4=10.0/255.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect bottom=CGRectMake(0, 170, 320, 460);
    // CGRect bottom=CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    CGContextAddRect(context, bottom);
    // CGContextSetRGBFillColor(context,218/255.0f,165/255.0f,32/255.0f,1);
    //CGContextFillRect(context, bottom);
    
    
    CGFloat baseViewColors[] =
    {
        nRed1, nBlue1, nGreen1, 1.0,
        nRed2, nBlue2, nGreen2, 1,
        nRed4, nBlue4, nGreen4, 0.1,
    };
    
    CGFloat locations[] = {0.0,0.8, 1.0};
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef viewBackground = CGGradientCreateWithColorComponents(baseSpace, baseViewColors, locations, 3);
    
    
    //CGRect square = CGRectMake(0, 0, 480, 260);
    
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(bottom), CGRectGetMinY(bottom));
    CGPoint endPoint   = CGPointMake(CGRectGetMidX(bottom), CGRectGetMaxY(bottom));
    
    CGContextSaveGState(context);
    //CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, viewBackground, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    
    CGGradientRelease(viewBackground),
    viewBackground = NULL;
    
}

-(void)createView
{
    CGRect boulderRect = CGRectMake(250,90, 80, 90);
    caveView = [[UIImageView alloc] initWithFrame:(boulderRect)];
    UIImage *boulder = [UIImage imageNamed:@"boulder2.png"];
    [caveView setImage:boulder];
    [self addSubview:caveView];
    
    
    CGRect caveRect = CGRectMake(0,30, 320, 250);
    caveView = [[UIImageView alloc] initWithFrame:(caveRect)];
    UIImage *cave = [UIImage imageNamed:@"cave.png"];
    [caveView setImage:cave];
    [self addSubview:caveView];
    
    
    
    CGRect treeRect = CGRectMake(0,90, 70, 180);
    treeView = [[UIImageView alloc] initWithFrame:(treeRect)];
    UIImage *tree1 = [UIImage imageNamed:@"tree2.gif"];
    [treeView setImage:tree1];
    [self addSubview:treeView];
    
    CGRect treeRect2 = CGRectMake(290,110, 50, 80);
    treeView = [[UIImageView alloc] initWithFrame:(treeRect2)];
    UIImage *tree2 = [UIImage imageNamed:@"tree3.png"];
    [treeView setImage:tree2];
    [self addSubview:treeView];
    
    treeRect2 = CGRectMake(205,178, 55, 25);
    treeView = [[UIImageView alloc] initWithFrame:(treeRect2)];
    UIImage *danger = [UIImage imageNamed:@"danger1.jpeg"];
    [treeView setImage:danger];
    [self addSubview:treeView];
    
    CGRect treeRect3 = CGRectMake(190,100, 80, 80);
    treeView = [[UIImageView alloc] initWithFrame:(treeRect3)];
    UIImage *tree3 = [UIImage imageNamed:@"shrub.png"];
    [treeView setImage:tree3];
    [self addSubview:treeView];
    
     treeRect3 = CGRectMake(240,270, 40, 40);
    treeView = [[UIImageView alloc] initWithFrame:(treeRect3)];
    tree3 = [UIImage imageNamed:@"shrubmain.png"];
    [treeView setImage:tree3];
    [self addSubview:treeView];
    
    treeRect3 = CGRectMake(40,270, 40, 40);
    treeView = [[UIImageView alloc] initWithFrame:(treeRect3)];
    tree3 = [UIImage imageNamed:@"shrubmain.png"];
    [treeView setImage:tree3];
    [self addSubview:treeView];

    
    CGRect sunRect = CGRectMake(250,20, 50, 50);
    sunView = [[UIImageView alloc] initWithFrame:(sunRect)];
    UIImage *sun = [UIImage imageNamed:@"sun3.png"];
    [sunView setImage:sun];
    [self addSubview:sunView];
    
    CGRect cloudRect = CGRectMake(200,10, 70, 30);
    cloudView = [[UIImageView alloc] initWithFrame:(cloudRect)];
    UIImage *cloud = [UIImage imageNamed:@"cloudmain.png"];
    [cloudView setImage:cloud];
    [self addSubview:cloudView];
    
    cloudRect = CGRectMake(20,10, 60, 40);
    cloudView = [[UIImageView alloc] initWithFrame:(cloudRect)];
    cloud = [UIImage imageNamed:@"cloudmain.png"];
    [cloudView setImage:cloud];
    [self addSubview:cloudView];
    
   CGRect woodRect=CGRectMake(60, 115, 140, 50);//(45, 40, 210, 60);
    //UIImage *wood=[UIImage imageNamed:@"woodmain.png"];*/
    UILabel *placard=[[UILabel alloc]initWithFrame:woodRect];
    placard.text=@" Gold Rush";
    [placard setFont:[UIFont fontWithName:@"Noteworthy-Bold" size:29]];//boldSystemFontOfSize:21]];
    //placard.textColor=[UIColor colorWithRed:51/255.0f green:25/255.0f blue:0 alpha:1.0f];
    placard.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"placard1.png"]];
    placard.textColor=UIColor.blackColor;
    //placard.textColor=[UIColor colorWithRed:255/255.0f green:215/255.0f blue:0/255.0f alpha:0.6f];
    //placard.backgroundColor = [UIColor clearColor];
    [self addSubview:placard];
    
     woodRect=CGRectMake(70, 115, 140, 60);
    UIImage *name=[UIImage imageNamed:@"goldmine.png"];
    cloudView = [[UIImageView alloc] initWithFrame:(woodRect)];
    //name = [UIImage imageNamed:@"cloudmain.png"];
    [cloudView setImage:name];
    //[self addSubview:cloudView];

    
    UIImage *rock = [UIImage imageNamed:@"rockmain.png"];
    // Add a button to start the game.
    UIButton *rockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rockButton addTarget:self
                   action:@selector(gostart)
         forControlEvents:UIControlEventTouchUpInside];
    [rockButton setBackgroundImage:rock forState:UIControlStateNormal];
    [rockButton setTitle:@"Start" forState:UIControlStateNormal];
    [rockButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [rockButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    rockButton.titleLabel.textColor = UIColor.blackColor;
    
    rockButton.frame = CGRectMake(110,300, 100, 40);
    [self addSubview:rockButton];
    
       // Add a button to goto Help
    UIButton *helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton addTarget:self
                   action:@selector(goHelp)
         forControlEvents:UIControlEventTouchUpInside];
    [helpButton setBackgroundImage:rock forState:UIControlStateNormal];
    [helpButton setTitle:@"Help" forState:UIControlStateNormal];
    [helpButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [helpButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
   
    helpButton.titleLabel.textColor = UIColor.blackColor;
    
    helpButton.frame = CGRectMake(20,340, 100, 40);
    [self addSubview:helpButton];

    // Add a button to goto option 
    UIButton *optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [optionButton addTarget:self
                   action:@selector(goOption)
         forControlEvents:UIControlEventTouchUpInside];
    [optionButton setBackgroundImage:rock forState:UIControlStateNormal];
    [optionButton setTitle:@"Share" forState:UIControlStateNormal];
    [optionButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [optionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    optionButton.titleLabel.textColor = UIColor.blackColor;
    
    optionButton.frame = CGRectMake(210,340, 100, 40);
    [self addSubview:optionButton];
    
    // Add a button to goto Demo
    UIButton *demoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [demoButton addTarget:self
                     action:@selector(goDemo)
           forControlEvents:UIControlEventTouchUpInside];
    [demoButton setBackgroundImage:rock forState:UIControlStateNormal];
    [demoButton setTitle:@"Demo" forState:UIControlStateNormal];
    [demoButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [demoButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    demoButton.titleLabel.textColor = UIColor.blackColor;
    
    demoButton.frame = CGRectMake(20,390, 100, 40);
    [self addSubview:demoButton];

    // Add a button to goto scores
    UIButton *scoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scoreButton addTarget:self
                     action:@selector(goScore)
           forControlEvents:UIControlEventTouchUpInside];
    [scoreButton setBackgroundImage:rock forState:UIControlStateNormal];
    [scoreButton setTitle:@"Scores" forState:UIControlStateNormal];
    [scoreButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [scoreButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
    scoreButton.titleLabel.textColor = UIColor.blackColor;
    
    scoreButton.frame = CGRectMake(210,390, 100, 40);
    [self addSubview:scoreButton];


    //  [self addSubview:treeView];
}
-(void)gold
{
    //inside the game
}
-(void)gostart
{
    [self.delegate buttonStart:self];
    NSLog(@"clicked the button");
}
-(void)goHelp
{
    [self.delegate goToHelpView:self];
    NSLog(@"clicked the button");
}

-(void)goOption
{
    [self.delegate goToShareView:self];
    NSLog(@"clicked the button");
}

-(void)goDemo
{
    [self.delegate goToDemoView:self];
    NSLog(@"clicked the button");
}

-(void)goScore
{
    [self.delegate goToScoreView:self];
    NSLog(@"clicked the button");
}



@end
