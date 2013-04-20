//
//  firstView.h
//  firstpage
//
//  Created by Harish Ramakrishnan on 3/8/13.
//  Copyright (c) 2013 Harish Ramakrishnan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class firstView;

@protocol firstDelegate <NSObject>
@required
-(void)goToHelpView:(firstView *)screen;
-(void)goToShareView:(firstView *)screen;
-(void)goToScoreView:(firstView *)screen;
-(void) buttonStart:(firstView *)screen;
-(void)goToDemoView:(firstView *)screen;

@end

@interface firstView : UIView
{
    UIImageView *treeView;
    UIImageView *caveView;
    UIImageView *sunView;
    UIImageView *cloudView;
    UIImageView *rockView;
    __weak id<firstDelegate> delegate;
}

@property (nonatomic,weak) id<firstDelegate> delegate;
-(id) initWithFrame:(CGRect)frame
        andDelegate:(id<firstDelegate>)delegateObject;
@end
