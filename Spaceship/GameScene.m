//
//  GameScene.m
//  Spaceship
//
//  Created by Rich Pellosie on 1/31/15.
//  Copyright (c) 2015 Rich Pellosie. All rights reserved.
//

#import "GameScene.h"
@interface GameScene()
@property SKSpriteNode *ship;
@property SKSpriteNode *meteor;
@property SKLabelNode *score;
@property int count;
@end

static const UInt32 shipCategory = 0x1;
static const UInt32 meteorCategory = 0x1 << 1;

@implementation GameScene

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //Prep next scene
}
- (void)addShip {
    self.ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    self.ship.xScale = 0.2;
    self.ship.yScale = 0.2;
    self.ship.position = CGPointMake(CGRectGetMidX(self.frame), 100);
    self.ship.physicsBody = [SKPhysicsBody bodyWithTexture:self.ship.texture size:self.ship.size];
    self.ship.physicsBody.dynamic = NO;
    self.ship.physicsBody.categoryBitMask = shipCategory;
    [self addChild:self.ship];
}

- (void)addMeteor {
    self.meteor = [SKSpriteNode spriteNodeWithImageNamed:@"Meteor"];
    self.meteor.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.meteor.size.width/2];
    self.meteor.physicsBody.linearDamping = 0;
    self.meteor.position = CGPointMake(self.ship.position.x, self.ship.position.y + 600);
    self.meteor.physicsBody.categoryBitMask = meteorCategory;
    [self addChild:self.meteor];
    
    CGVector push = CGVectorMake(0,-9.8);
    [self.meteor.physicsBody applyImpulse:push];
}

-(void)addHUD{
    self.score = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    self.score.text = [NSString stringWithFormat:@"Meteors dodged: %i",self.count];
    self.score.fontColor = [SKColor whiteColor];
    self.score.fontSize = 20;
   // score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.score.position = CGPointMake(self.frame.size.width - self.score.frame.size.width/2 - 20, self.frame.size.height - self.score.frame.size.height/2 -20);
    [self addChild:self.score];
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.physicsWorld.gravity = CGVectorMake(0,-0.1);
    self.physicsWorld.contactDelegate=self;
    
    [self addShip];
    [self addMeteor];
    [self addHUD];
    
    self.count = 0;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        CGPoint newLocation = CGPointMake(location.x, self.ship.position.y);
        if(newLocation.x <self.ship.size.width/2)
            newLocation.x=self.ship.size.width/2;
        if(newLocation.x > self.frame.size.width - (self.ship.size.width/2))
            newLocation.x = self.frame.size.width - (self.ship.size.width/2);
       //NSLog(@"X position: %g",newLocation.x);
        self.ship.position = newLocation;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
   // NSLog(@"meteor.y: %g",self.meteor.position.y);
    if(self.meteor.position.y < 0)
    {
        self.count++;
        int range = self.size.width - self.meteor.size.width;
        int offset = self.meteor.size.width/2;
        //self.meteor.physicsBody.velocity = CGVectorMake(0, self.meteor.physicsBody.velocity.dy*1.1);
        self.meteor.position = CGPointMake(rand() % range + offset, self.frame.size.height +100);
        NSLog(@"New velocity: %g", self.meteor.physicsBody.velocity.dy);
    }
}

@end
