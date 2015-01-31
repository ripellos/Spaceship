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
@end
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    self.ship.xScale = 0.2;
    self.ship.yScale = 0.2;
    self.ship.position = CGPointMake(CGRectGetMidX(self.frame),
                                   100);
    self.ship.physicsBody = [SKPhysicsBody bodyWithTexture:self.ship.texture size:self.ship.size];
    self.ship.physicsBody.dynamic = NO;
    [self addChild:self.ship];
    
    self.meteor = [SKSpriteNode spriteNodeWithImageNamed:@"Meteor"];
    self.meteor.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.meteor.size.width/2];
    self.meteor.position = CGPointMake(self.ship.position.x, self.ship.position.y + 600);
    [self addChild:self.meteor];
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
}

@end
