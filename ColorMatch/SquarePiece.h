//
//  SquarePiece.h
//  ColorMatch
//
//  Created by Dan Jones on 3/2/14.
//  Copyright (c) 2014 Dan Jones. All rights reserved.
//

#import "Piece.h"

@interface SquarePiece : Piece
{
    CCSprite *squareSprite;
    
}

//+ (id)createSquare;
+ (id)createSquareAtPoint:(CGPoint)newPoint andScale:(CGPoint)newScale andRotation:(float)newRotation;
- (void)squarePieceInit;
- (CCSprite *)getSprite;
    
@end
