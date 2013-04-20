//
//  GoldObject.h
//  GameLogic
//
/// Created by Gurupur Sushma Pai & Aparna Srinivasan
//  Copyright (c) Gurupur Sushma Pai & Aparna Srinivasan All rights reserved.

#import <Foundation/Foundation.h>

// Class that defines the gold object and its properties.
@interface GoldObject :NSObject

// Instance variables.
@property(nonatomic, strong) UIImageView *goldImage;
@property(nonatomic) int goldValue;
@property(nonatomic) BOOL placedByPlayer;

@end
