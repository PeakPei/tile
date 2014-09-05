//
//  SquareSprite.m
//  ColorMatch
//
//  Created by Dan Jones on 3/4/14.
//  Copyright (c) 2014 Dan Jones. All rights reserved.
//

#import "SquareSprite.h"



@implementation SquareSprite

//@synthesize color = _color;
@synthesize name = _name;

- (id)initWithPosition:(CGPoint)newPosition andScale:(CGPoint)newScale andRotation:(float)newRotation andZ:(int)z
{
    self = [super init];
    
    self = [SquareSprite spriteWithFile:@"w.png"];
    //self = [CCSprite spriteWithFile:@"square2.png"];
    bg = [CCSprite spriteWithFile:@"b.png"];
    [self addChild:bg z:-155];
    
    self.position = newPosition;
    self.scaleX = newScale.x;
    self.scaleY = newScale.y;
    self.rotation = newRotation;
    self.zOrder = z;
    
    float bgScale = (newScale.x + 8) / newScale.x;
    bg.scaleX = bgScale;
    bg.scaleY = bgScale;
    bg.position = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyThis) name:@"testAnnounce" object:nil];
    
    
    
    
    return self;
}
/*
- (void)notifyThis:(id)notification
{
    NSLog(@"notifyingoiokok");
}
*/
+ (id)createSquareSpriteAtPoint:(CGPoint)newPoint andScale:(CGPoint)newScale andRotation:(float)newRotation andZ:(int)z
{
    //return [[self alloc] initWithFile:@"square2.png"];
    //return [[self alloc] initWithFile:@"square2.png"];
    return [[[self class] alloc] initWithPosition:newPoint andScale:newScale andRotation:newRotation andZ:z];
}

// we know this is going to be a square shape
/*
- (void)checkBoundsWith:(SquareSprite *)touchedSprite
{
   if(CGRectIntersectsRect(self.boundingBox, touchedSprite.boundingBox))
    {
        if(self.color.r == touchedSprite.color.r
           && self.color.g == touchedSprite.color.g
           && self.color.b == touchedSprite.color.b)
        {
            NSLog(@" colors are the same");
        }
        //NSLog(@" one %f two %f", self.position.x, touchedSprite.position.x);
        //NSLog(@"intersect");
    }
}
*/

- (BOOL)checkBoundsWith:(NSMutableArray *)allSprites andColor:(ccColor3B)thisColor
{
    for(SquareSprite *sp in allSprites)
    {
        if(sp.position.x != self.position.x)
        {
            if(CGRectIntersectsRect(self.boundingBox, sp.boundingBox))
            {
                if(sp.color.r == thisColor.r
                   && sp.color.g == thisColor.g
                   && sp.color.b == thisColor.b)
                {
                    return NO;
                }
            }
        }
    }
    return YES;
}
/*
- (void)respondToProtocol
{
    NSLog(@"responsed to protocol");
}

+ (void)testok
{
    NSLog(@"send test message");
}
 */
@end
