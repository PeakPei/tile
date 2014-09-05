//
//  Piece.m
//  ColorMatch
//
//  Created by Dan Jones on 2/27/14.
//  Copyright 2014 Dan Jones. All rights reserved.
//

#import "Piece.h"


@implementation Piece

@synthesize pieceSprite = _pieceSprite;

+ (id)createPiece
{
    return [[[self class] alloc] init];
}

+ (id)createSprite
{
    return [CCSprite spriteWithFile:@"square.png"];
}

+ (void)checkCoordinates
{
    //NSLog(@"my position %f", position.x);
    NSLog(@"rand test");
}

+ (void)checkColor
{
    
}


@end
