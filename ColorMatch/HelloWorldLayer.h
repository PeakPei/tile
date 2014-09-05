//
//  HelloWorldLayer.h
//  ColorMatch
//
//  Created by Dan Jones on 1/13/14.
//  Copyright Dan Jones 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "SquarePiece.h"
#import "SquareSprite.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32



// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref

  
    SquareSprite *fadedSprite;
    
    SquareSprite *finalsprite;
    //SquarePiece *sprite1;
    //SquarePiece *sprite2;
    //CCSprite *sprite1;
    //CCSprite *sprite2;
    UITouch *firstTouch;
    CGPoint startTouchLocation;
    
    bool touchDown;
    CGFloat timeHeldDown;
    CCSprite *colorChooser;
    CGPoint touchDownPoint;
    
    NSMutableArray *allSprites;
    
}



// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
