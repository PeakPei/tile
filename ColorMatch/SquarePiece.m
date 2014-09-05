//
//  SquarePiece.m
//  ColorMatch
//
//  Created by Dan Jones on 3/2/14.
//  Copyright (c) 2014 Dan Jones. All rights reserved.
//

#import "SquarePiece.h"

@implementation SquarePiece


- (void)squarePieceInit
{
    
    squareSprite =  [CCSprite spriteWithFile:@"square2.png"];
    [self addChild:squareSprite];
}

/*
- (id)init
{
    squareSprite =  [CCSprite spriteWithFile:@"square2.png"];

    return self;
}
*/

- (CCSprite *)getSprite
{
    return squareSprite;
}

- (id)initWithPosition:(CGPoint)newPosition andScale:(CGPoint)newScale andRotation:(float)newRotation
{
    self = [super init];
    
    self.position = newPosition;
    self.scaleX = newScale.x;
    self.scaleY = newScale.y;
    self.rotation = newRotation;
    
    squareSprite =  [CCSprite spriteWithFile:@"square2.png"];
    [self addChild:squareSprite z:1];
    
    return self;
}

- (CCSprite *)pieceSprite
{
    return squareSprite;
}

+ (id)createSquareAtPoint:(CGPoint)newPoint andScale:(CGPoint)newScale andRotation:(float)newRotation
{
    //return [[self alloc] initWithFile:@"square2.png"];
    //return [[self alloc] initWithFile:@"square2.png"];
    return [[[self class] alloc] initWithPosition:newPoint andScale:newScale andRotation:newRotation];
}
/*
- (CCSprite *)squareSprite
{
    return [CCSprite spriteWithFile:@"square2.png"];
}
*/

@end
