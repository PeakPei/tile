//
//  Piece.h
//  ColorMatch
//
//  Created by Dan Jones on 2/27/14.
//  Copyright 2014 Dan Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Piece : CCNode {
    
}

@property (nonatomic) ccColor3B SpriteColor;
@property (nonatomic, copy) CCSprite *pieceSprite;

+ (void)checkCoordinates;

@end
