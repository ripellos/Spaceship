//
//  GameOver.m
//  Spaceship
//
//  Created by Rich Pellosie on 1/31/15.
//  Copyright (c) 2015 Rich Pellosie. All rights reserved.
//

#import "GameOver.h"
#import "GameViewController.h"

@interface GameOver()
@property BOOL scoreNeedsToBeAdded;
@end
@implementation GameOver
-(instancetype)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        //self.backgroundColor = [SKColor blackColor];
        self.scoreNeedsToBeAdded=YES;

        SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        gameOver.text = @"GAME OVER";
        gameOver.fontSize = 44;
        gameOver.fontColor = [SKColor whiteColor];
        gameOver.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+5);
        [self addChild:gameOver];
        
        SKLabelNode *restart = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        restart.text = @"tap to try again!";
        restart.fontColor = [SKColor whiteColor];
        restart.fontSize = 22;
        restart.position = CGPointMake(size.width/2, -300);
        SKAction *slideUp = [SKAction moveToY:CGRectGetMidY(self.frame)-40 duration:0.7];
        [restart runAction:slideUp];
        
        [self addChild:restart];
    }
    return self;
}
-(void)showHighScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *highscores = [defaults objectForKey:@"highscores"];
    NSArray *highscoreNames = [defaults objectForKey:@"highscoreNames"];
    NSString *highscoreText;
    
    if(highscoreNames && highscores)
    {
        for(int i=0; i<highscoreNames.count; i++)
        {
            NSString *highscoreLine = [NSString stringWithFormat:@"%@: %@\n", [highscoreNames objectAtIndex:i], [highscores objectAtIndex: i]];
            highscoreText = [highscoreText stringByAppendingString:highscoreLine];
        }
        NSLog(@"%@",highscoreText);
    }
    else
    {
        NSMutableArray *highscores;
        for(int i=10; i>0; i--)
        {
            [highscores addObject:[NSNumber numberWithInt:5*i]];
        }
        NSMutableArray *highscoreNames = [NSMutableArray arrayWithObjects:
                                          @"Mal",
                                          @"Jean-Luke",
                                          @"Turanga",
                                          @"",
                                          @"",
                                          @"",
                                          @"",
                                          @"",
                                          @"",
                                          @"", nil];
    }
}
-(void)addScore
{
    //NSNumber *scoreData = [self.userData objectForKey:@"score"];
    int currentScore = ((NSNumber*)[self.userData objectForKey:@"score"]).intValue;
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %i", currentScore];
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height -100);
    scoreLabel.fontColor = [SKColor whiteColor];
    [self addChild:scoreLabel];
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
    GameScene *newGame = [GameScene sceneWithSize:self.size];
    [self.view presentScene:newGame transition:[SKTransition doorsOpenVerticalWithDuration:0.9]];
}
@end
