//
//  SquareSprite.h
//  ColorMatch
//
//  Created by Dan Jones on 3/4/14.
//  Copyright (c) 2014 Dan Jones. All rights reserved.
//

#import "CCSprite.h"

//@protocol testprotocol <NSObject>
//- (void)respondToProtocol;

//@end

@interface SquareSprite : CCSprite
{
    SquareSprite *bg;
}

@property (nonatomic, retain) NSString *name;
//@property (nonatomic) ccColor3B color;


- (id)initWithPosition:(CGPoint)newPosition andScale:(CGPoint)newScale andRotation:(float)newRotation andZ:(int)z;
+ (id)createSquareSpriteAtPoint:(CGPoint)newPoint andScale:(CGPoint)newScale andRotation:(float)newRotation andZ:(int)z;

//- (void)checkBoundsWith:(SquareSprite *)touchedSprite;
- (BOOL)checkBoundsWith:(NSMutableArray *)allSprites andColor:(ccColor3B)thisColor;
//+ (void)checkBoundsWith:(CCSprite *)touchedSprite;
//+ (void)testok;

@end
