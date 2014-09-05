//
//  HelloWorldLayer.mm
//  ColorMatch
//
//  Created by Dan Jones on 1/13/14.
//  Copyright Dan Jones 2014. All rights reserved.
//


// todo
// find what piece you touched
// find bordering pieces to the piece you touched
// check bordering colors




// Import the interfaces
#import "HelloWorldLayer.h"

// Not included in "cocos2d.h"
#import "CCPhysicsSprite.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "SquarePiece.h"
#import "SquareSprite.h"
#import "SimpleAudioEngine.h"

enum {
	kTagParentNode = 1,
};


struct spriteSize {
    CGPoint pos;
    CGPoint spriteScale;
    float spriteRotation;
    int spriteZ;
};

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(75,196,230,255)])) {
		
		// enable events
		
		self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
		CGSize s = [CCDirector sharedDirector].winSize;
		
		// init physics
		[self initPhysics];
		//[self drawShapes];
		// create reset button
		//[self createMenu];
		
		//Set up sprite
		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
		
		touchDown = false;
        timeHeldDown = 0.0f;
        
        colorChooser = [CCSprite spriteWithFile:@"colors.png"];
        colorChooser.opacity = 0;
        colorChooser.position = CGPointMake(0.0f, 0.0f);
        [self addChild:colorChooser z:199];
        
		//[self addNewSpriteAtPosition:ccp(s.width/2, s.height/2)];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
		//[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width/2, s.height-50);
		
        
        allSprites = [[NSMutableArray alloc] init];

        // faded sprite that fades in as you touch a square
        fadedSprite = [SquareSprite createSquareSpriteAtPoint:ccp(0,0) andScale:ccp(0, 0) andRotation:0 andZ:0];
        fadedSprite.opacity = 0;
        //fadedSprite.opacity = 80;
        fadedSprite.color = ccc3(0, 0, 0);
        [self addChild:fadedSprite];
        
        
        // get plist, read it and create sprites with the values from the list
        NSString *path = [[NSBundle mainBundle] pathForResource: @"PropertyList" ofType: @"plist"];
        NSMutableDictionary *dictplist =[[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        for (NSDictionary *d in [dictplist allValues]) {
            CGFloat x = [[d valueForKey:@"XPos"] floatValue];
            CGFloat y = [[d valueForKey:@"YPos"] floatValue];
            CGFloat scaleX = [[d valueForKey:@"XScale"] floatValue];
            CGFloat scaleY = [[d valueForKey:@"YScale"] floatValue];
            int rot = [[d valueForKey:@"Rotation"] intValue];
            int zorder = [[d valueForKey:@"ZOrder"] intValue];
            
            SquareSprite *s = [SquareSprite createSquareSpriteAtPoint:ccp(x, y)
                                                             andScale:ccp(scaleX,scaleY)
                                                          andRotation:rot
                                                                 andZ:zorder];
           
            [self addChild:s];
            [allSprites addObject:s];
        }
        
        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost:3000/articles"]];
        NSString *stuff = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://localhost:3000/articles"] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"data %@", stuff);
        
        [self scheduleUpdate];
	}
	return self;
}
/*
- (void)makeNewSquare
{
    newSprite7 = [SquareSprite createSquareSpriteAtPoint:ccp(100,410) andScale:ccp(340.0f,345.0f) andRotation:0 andZ:6];
    newSprite7.name = @"seven";
    [self addChild:newSprite7];
    [allSprites addObject:newSprite7];
}
*/
-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
    
    [allSprites dealloc];
    allSprites = NULL;
	
	[super dealloc];
}	
/*
- (void)addBoxBodyForSprite:(CCSprite *)sprite withXScale:(float)x andYScale:(float)y andRotation:(float)r
{
    
    b2BodyDef spriteBodyDef;
    spriteBodyDef.type = b2_staticBody;
    spriteBodyDef.position.Set(sprite.position.x/PTM_RATIO,
                               sprite.position.y/PTM_RATIO);
    spriteBodyDef.angle = CC_DEGREES_TO_RADIANS(-45);
    spriteBodyDef.userData = sprite;
    b2Body *spriteBody = world->CreateBody(&spriteBodyDef);
    
    b2PolygonShape spriteShape;
    spriteShape.SetAsBox((sprite.contentSize.width * x)/PTM_RATIO/2,
                         (sprite.contentSize.height * y)/PTM_RATIO/2);
    
    b2FixtureDef spriteShapeDef;
    spriteShapeDef.shape = &spriteShape;
    //spriteShapeDef.density = 10.0;
    //spriteShapeDef.isSensor = true;
    spriteBody->CreateFixture(&spriteShapeDef);
    
}
*/
/*
-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [HelloWorldLayer scene]];
	}];

	// to avoid a retain-cycle with the menuitem and blocks
	__block id copy_self = self;

	// Achievement Menu Item using blocks
	CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
		
		
		GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
		achivementViewController.achievementDelegate = copy_self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:achivementViewController animated:YES];
		
		[achivementViewController release];
	}];
	
	// Leaderboard Menu Item using blocks
	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
		
		
		GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
		leaderboardViewController.leaderboardDelegate = copy_self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:leaderboardViewController animated:YES];
		
		[leaderboardViewController release];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];	
}
*/
-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
   // glDisable(GL_TEXTURE_2D);
	//glDisableClientState(GL_COLOR_BUFFER_BIT);
	//glDisableClientState(GL_TEXTURE_COORD_ARRAY);Ï
	world->DrawDebugData();
    //glEnable(GL_TEXTURE_2D);

    
    /*
    CGPoint points[] = {ccp(20,100), ccp(20,200), ccp(100,200), ccp(100,100) };
    ccDrawPoly(points, 4, YES);
    
    CGPoint points2[] = {ccp(100,100), ccp(100,260), ccp(150,260), ccp(150,100) };
    ccDrawPoly(points2, 4, YES);
	
    CGPoint points3[] = {ccp(20,200), ccp(20,360), ccp(310,360), ccp(310,100) , ccp(150, 100)};
    ccDrawPoly(points3, 5, YES);
    */
    
    //glColor4f(0, 1.0, 0, 1.0);
    //glLineWidth(2.0f);
    //[super draw];
    
    /*
    CGPoint verts[4] = {
        ccp(newSprite2.boundingBox.origin.x, newSprite2.boundingBox.origin.y),
        ccp(newSprite2.boundingBox.origin.x + newSprite2.boundingBox.size.width, newSprite2.boundingBox.origin.y),
        ccp(newSprite2.boundingBox.origin.x + newSprite2.boundingBox.size.width, newSprite2.boundingBox.origin.y + newSprite2.boundingBox.size.height),
        ccp(newSprite2.boundingBox.origin.x, newSprite2.boundingBox.origin.y + newSprite2.boundingBox.size.height)
    };
    */
    //ccDrawPoly(verts, 4, YES);
    
    //kmGLPopMatrix();
}
/*
-(void) addNewSpriteAtPosition:(CGPoint)p
{
	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	

	CCNode *parent = [self getChildByTag:kTagParentNode];
	
	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
	//just randomly picking one of the images
	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
	CCPhysicsSprite *sprite = [CCPhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
	[parent addChild:sprite];
	
	[sprite setPTMRatio:PTM_RATIO];
	[sprite setB2Body:body];
	[sprite setPosition: ccp( p.x, p.y)];

}
*/
-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    
    if(touchDown)
    {
        timeHeldDown += dt;
        
        if(timeHeldDown > 0.11f)
        {
            timeHeldDown = 0.0f;
            [self showColorChoices];
            
        }
    }
}

- (void)showColorChoices
{
    touchDown = false;
    colorChooser.position = startTouchLocation;
    [colorChooser runAction:[CCFadeIn actionWithDuration:0.2f]];
}

- (void)hideColorChoices
{
    [colorChooser runAction:[CCFadeOut actionWithDuration:0.2f]];
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches )
    {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
  
        NSInteger spriteZIndex = 0;
        for(SquareSprite *spri in allSprites)
        {
            CGPoint newLoc = [spri convertToNodeSpace:location];
            if(CGRectContainsPoint(spri.textureRect, newLoc))
            {
                if(spri.zOrder >= spriteZIndex)
                {
                    spriteZIndex = spri.zOrder;
                    finalsprite = spri;
                }
            }
        }
        
        fadedSprite.opacity = 0;
        fadedSprite.scaleX = finalsprite.scaleX;
        fadedSprite.scaleY = finalsprite.scaleY;
        fadedSprite.position = finalsprite.position;
        fadedSprite.zOrder = finalsprite.zOrder + 0.1;
        //[fadedSprite runAction:[CCFadeOutBLTiles actionWithDuration:1.8]];
        [fadedSprite runAction:[CCFadeTo actionWithDuration:0.6 opacity:55]];
        //[fadedSprite runAction:[CCScaleTo actionWithDuration:0.4 scaleX:finalsprite.scaleX scaleY:finalsprite.scaleY]];
       // NSLog(@"TOUCHDOWNNNNN %f %f %hhu %f", fadedSprite.scaleX, fadedSprite.scaleY, fadedSprite.opacity, fadedSprite.position.x);
        
        startTouchLocation = location;
        timeHeldDown = 0.0f;
        touchDown = true;
        touchDownPoint = location;
        //timeHeldDown +=
        
        
        /*
         //works
         for(Piece *obj in allSprites)
         {
         CCArray *childpieces = [obj children];
         for(CCSprite *spr in childpieces)
         {
         CGPoint sprPoint = [spr convertToNodeSpace:location];
         if(CGRectContainsPoint(spr.textureRect, sprPoint))
         {
         NSLog(@"touched in sprite child %f", obj.position.x);
         }
         }
         }
         */
        

	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL: location];
        //finalsprite.position = location;
        //NSLog(@"x: %f y: %f", location.x, location.y);
        
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL: location];
        
        touchDown = false;
        
        BOOL canColor = NO;
        ccColor3B destinationColor = ccc3(255,255,255);
    
        CGFloat xChange = fabs(location.x - startTouchLocation.x);
        CGFloat yChange = fabs(location.y - startTouchLocation.y);
        
        
        CGFloat maxYCanTravel = 15.0;
        CGFloat minXToTravel = 25.0;
        
        if(yChange < maxYCanTravel && xChange > minXToTravel)
        {
            if(location.x > startTouchLocation.x)
            {
                // right green
                destinationColor = ccc3(0, 255, 0);
            }
            if(location.x < startTouchLocation.x)
            {
                // left red
                destinationColor = ccc3(255, 0, 0);
            }
        }
        
        CGFloat xThreshold = 15.0;
        CGFloat yThreshold = 25.0;
        
        // only went a little bit x, so still a vertical swipe,
        // and vertical swipte distance was long enough
        if(xChange < xThreshold && yChange > yThreshold)
        {
            if(location.y > startTouchLocation.y)
            {
                // up blue
                destinationColor = ccc3(0, 0, 255);
            }
            if(location.y < startTouchLocation.y)
            {
                // down purple
                destinationColor = ccc3(255, 0, 255);
            }
        }
        
        if(finalsprite != NULL)
        {
            canColor = [finalsprite checkBoundsWith:allSprites andColor:destinationColor];
    
            if(canColor)
            {
                [finalsprite runAction:[CCTintTo actionWithDuration:1 red:destinationColor.r green:destinationColor.g blue:destinationColor.b]];
            }
            else
            {
                [self shakeAndSplit];
            }
            
            //for(SquareSprite *sp in allSprites)
            //{
            //    if(sp != finalsprite)
            //    {
            // check to see if the sprite you touched intersects with others
            //        [sp checkBoundsWith:finalsprite];
            //    }
            // }
        }
        
        fadedSprite.zOrder = -1;
        [self hideColorChoices];
    }
}

- (void)shakeAndSplit
{
    
    CGPoint pos = finalsprite.position;
    id moveLeft= [CCMoveTo actionWithDuration:0.1 position:ccp(pos.x - 10, pos.y)];
    id moveRight= [CCMoveTo actionWithDuration:0.1 position:ccp(pos.x + 10, pos.y)];
    id moveBack = [CCMoveTo actionWithDuration:0.1 position:pos];
    //id menuItem1easeLeft = [CCEaseInOut actionWithAction:menuItem1ActLeft rate:2];
    //id menuItem1easeRight = [CCEaseInOut actionWithAction:menuItem1ActRight rate:2];
    id seq1 = [CCSequence actions:moveLeft, moveRight, moveBack, nil];
    [finalsprite runAction:seq1];
    
    
    
    [finalsprite setBlendFunc:(ccBlendFunc){GL_ONE, GL_ONE}];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"MySong.mp3"];
    /*
    CCParticleExplosion *exp = [CCParticleExplosion particleWithFile:@"bluedot-alpha.png"];
    exp.position = ccp(300, 300);
    [self addChild:exp];
    */
    CCParticleSystemQuad *myEmitter;
    
    myEmitter = [[CCParticleExplosion alloc] initWithTotalParticles:50];
    
    //star.png is my particle image
    myEmitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"bluedot-alpha.png"];
    myEmitter.position = ccp(250, 500);
    
    myEmitter.life =0.5;
    myEmitter.duration = 0.9;
    myEmitter.scale = 0.7;
    myEmitter.speed = 100;
    
    //For not showing color
    myEmitter.blendAdditive = NO;
    [self addChild:myEmitter z:55];
    myEmitter.autoRemoveOnFinish = YES;
    
    // below is code to split square in half
    /*
    SquareSprite *split1 = [SquareSprite createSquareSpriteAtPoint:ccp(finalsprite.position.x + finalsprite.scaleX/8, finalsprite.position.y)
                                                          andScale:ccp(finalsprite.scaleX/2, finalsprite.scaleY/2)
                                                       andRotation:0
                                                              andZ:(int)finalsprite.zOrder];
    [self addChild:split1];
    [allSprites addObject:split1];
    
    
    SquareSprite *split2 = [SquareSprite createSquareSpriteAtPoint:ccp(finalsprite.position.x - finalsprite.scaleX/8, finalsprite.position.y)
                                                          andScale:ccp(finalsprite.scaleX/2, finalsprite.scaleY/2)
                                                       andRotation:0
                                                              andZ:(int)finalsprite.zOrder];
    [self addChild:split2];
    [allSprites addObject:split2];
    
                            
    
    [self removeChild:finalsprite];
    [allSprites removeObject:finalsprite];
    
    */
    
}

// x 20 to 290
// y 30 to 520
/*
- (void)generateLevel
{
    
    newSprite6 = [SquareSprite createSquareSpriteAtPoint:ccp(165,420) andScale:ccp(1.5f,0.7f) andRotation:0 andZ:5];
    newSprite6.name = @"six";
    [self addChild:newSprite6];
    [allSprites addObject:newSprite6];
}
*/
#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
