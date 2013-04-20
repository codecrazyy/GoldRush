//
//  announcementLabel.m
//  Bluetooth2
//
//  Created by Harish Ramakrishnan on 3/1/13.
//  Copyright (c) 2013 Harish Ramakrishnan. All rights reserved.
//

#import "AnnouncementLabel.h"

@implementation AnnouncementLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *yourLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
                                              // aLabel.center = CGPointMake(aLabel.center.x,aLabel.center.y - 23.0);
                                                                       [yourLabel setTextColor:[UIColor blackColor]];
                                                                       [yourLabel setBackgroundColor:[UIColor clearColor]];
                                                                       
                                                                       //[yourSuperView addSubview:yourLabel];
    }
    return self;
}
/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        // Add the start icon.
        CGRect startRectangle = CGRectMake(0, 180, 50, 70);
        startHolder = [[UIImageView alloc] initWithFrame:(startRectangle)];
        UIImage *start = [UIImage imageNamed:@"start.jpeg"];
        [startHolder setImage:start];
        [self addSubview:startHolder];
        
        
        // Coordinates where the gold will be placed.
        int yCordinate[] = {20, 30, 190, 80, 180, 135, 90, 120, 35, 150};
        int xCoordinate[] = {2, 300, 350, 40, 400, 150, 100, 450, 175, 380};
        
        goldPoints = [[NSMutableArray alloc] initWithCapacity:totalGold];
        
        
        // Add the gold icons.
        for(int i = 0; i < totalGold ; ++i)
        {
            CGRect goldRectanglei = CGRectMake(xCoordinate[i], yCordinate[i], 20, 20);
            UIImageView *goldHolderi = [[UIImageView alloc] initWithFrame:(goldRectanglei)];
            UIImage *goldi = [UIImage imageNamed:@"coin1.jpeg"];
            [goldHolderi setImage:goldi];
            [self addSubview:goldHolderi];
            [goldPoints addObject:goldHolderi];
        }
        
        [self workerAtStartingPosition];
        
        self.backgroundColor = [UIColor whiteColor];
        
        pointsCounter = 0;
        
        timerStarted = NO;
        
        livesCount = gameLives.text.integerValue;
        
        
    }
    return self;
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
