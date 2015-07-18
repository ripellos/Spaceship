//
//  NewHighScore.m
//  Spaceship
//
//  Created by Rich Pellosie on 3/25/15.
//  Copyright (c) 2015 Rich Pellosie. All rights reserved.
//

#import "NewHighScore.h"
#import "GameOver.h"
@interface NewHighScore()
@property BOOL scoreNeedsToBeAdded;
@end

@implementation NewHighScore

-(instancetype)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        [self addSubmit];
        self.scoreNeedsToBeAdded = YES;
    }
    return self;
}
-(void) addScore
{
    int currentScore = ((NSNumber*)[self.userData objectForKey:@"score"]).intValue;
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %i", currentScore];
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height -60);
    scoreLabel.fontColor = [SKColor whiteColor];
    [self addChild:scoreLabel];
}
-(void) AddTextbox
{
//    UIInputView *text = [[UIInputView alloc]init];
//    text.frame.size = [CGRectMake(self.size.width/2, self.size.height/2+400, 300, 20)];
//    [self addChild:text];
}
-(void) addSubmit
{
    SKLabelNode *submit = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    submit.text = @"Submit";
    submit.position = CGPointMake(self.size.width/2,  100);
    submit.fontColor = [SKColor whiteColor];
    
    [self addChild:submit];
}
-(void)update:(NSTimeInterval)currentTime
{
    if(self.scoreNeedsToBeAdded)
    {
        self.scoreNeedsToBeAdded=NO;
        [self addScore];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameOver *showHighscores = [GameOver sceneWithSize:self.size];
    [self.view presentScene:showHighscores transition:[SKTransition doorsOpenHorizontalWithDuration:1.0]];
}


@end
