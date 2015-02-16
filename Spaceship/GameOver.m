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
@property int userScore;
@end
@implementation GameOver
-(instancetype)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor blackColor];
        self.scoreNeedsToBeAdded=YES;

        SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        gameOver.text = @"GAME OVER";
        gameOver.fontSize = 44;
        gameOver.fontColor = [SKColor whiteColor];
        gameOver.position = CGPointMake(CGRectGetMidX(self.frame), 200);
        [self addChild:gameOver];
        
        SKLabelNode *restart = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        restart.text = @"tap to try again!";
        restart.fontColor = [SKColor whiteColor];
        restart.fontSize = 22;
        restart.position = CGPointMake(size.width/2, -300);
        SKAction *slideUp = [SKAction moveToY:160 duration:0.7];
        [restart runAction:slideUp];
        
        [self addChild:restart];
    }
    return self;
}
-(NSArray *) insertInto:(NSArray *)highscores value:(id)object atIndex:(int)index
{
    NSRange beforeRange;
    beforeRange.location = 0;
    beforeRange.length = index;
    NSArray *before = [highscores subarrayWithRange:beforeRange];
    NSRange afterRange;
    afterRange.location = index;
    afterRange.length = highscores.count - index;
    NSArray *after = [highscores subarrayWithRange:afterRange];
    NSMutableArray *shiftArray = [before mutableCopy];
    [shiftArray addObject:object];
    [shiftArray addObjectsFromArray:after];
    return [shiftArray copy];
}
-(void) updateHighscore:(NSArray *)highscores withNames:(NSArray *)highscoreNames
{
    int currentIndex = -1;
    for (NSNumber *score in highscores) {
        if(score.intValue < self.userScore)
        {
            currentIndex = [highscores indexOfObject:score];
            break;
        }
    }
    if(currentIndex >-1)
    {
        highscores = [self insertInto:highscores value:[NSNumber numberWithInt:self.userScore] atIndex:currentIndex];
        highscoreNames = [self insertInto:highscoreNames value:@"You" atIndex:currentIndex];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:highscores forKey:@"highscores"];
        [defaults setObject:highscoreNames forKey:@"highscoreNames"];
    }
    [self postionScores:highscores highscoreNames:highscoreNames withNewScoreAtIndex:currentIndex];
    
}
- (void)postionScores:(NSArray *)highscores highscoreNames:(NSArray *)highscoreNames withNewScoreAtIndex:(int)index
{
    for(int i=0; i<10; i++)
    {
        SKLabelNode *highscoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        highscoreLabel.fontSize=18;
        highscoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        NSString *highscoreLine = [NSString stringWithFormat:@"%@: %@\n", [highscoreNames objectAtIndex:i], [highscores objectAtIndex: i]];
        highscoreLabel.text = highscoreLine;
        highscoreLabel.position = CGPointMake(self.size.width/2 + 50, self.size.height - (90 + 22*i));
        
        highscoreLabel.fontColor = (index==i) ? [SKColor yellowColor]:[SKColor whiteColor];
        
        [self addChild:highscoreLabel];
    }
}

-(void)showHighScore
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *highscores = [defaults objectForKey:@"highscores"];
    NSArray *highscoreNames = [defaults objectForKey:@"highscoreNames"];
    
    if(!highscoreNames && !highscores)
    {
        //NSLog(@"Creating new highscore");
        NSMutableArray *highscoresInitial = [NSMutableArray array];
        for(int i=10; i>0; i--)
        {
            [highscoresInitial addObject:[NSNumber numberWithInt:5*i]];
        }
        NSMutableArray *highscoreNamesInitial = [NSMutableArray arrayWithObjects:
                                          @"Mal",
                                          @"Jean-Luke",
                                          @"Turanga",
                                          @"Han",
                                          @"Zehpod",
                                          @"William",
                                          @"Duck",
                                          @"Horatio",
                                          @"Jack",
                                          @"Zapp", nil];
        highscoreNames = [highscoreNamesInitial copy];
        highscores = [highscoresInitial copy];
        [defaults setObject:highscores forKey:@"highscores"];
        [defaults setObject:highscoreNames forKey:@"highscoreNames"];
    }
    [self updateHighscore:highscores withNames:highscoreNames];
    
    //SKLabelNode *highscoreList = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    //NSLog(@"%@",highscoreText);
    
}
-(void)addScore
{
    //NSNumber *scoreData = [self.userData objectForKey:@"score"];
    int currentScore = ((NSNumber*)[self.userData objectForKey:@"score"]).intValue;
    self.userScore = currentScore;
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
    scoreLabel.text = [NSString stringWithFormat:@"Score: %i", currentScore];
    scoreLabel.position = CGPointMake(self.size.width/2, self.size.height -60);
    scoreLabel.fontColor = [SKColor whiteColor];
    [self addChild:scoreLabel];
}
-(void)update:(NSTimeInterval)currentTime
{
    if(self.scoreNeedsToBeAdded)
    {
        self.scoreNeedsToBeAdded=NO;
        [self addScore];
        [self showHighScore];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    GameScene *newGame = [GameScene sceneWithSize:self.size];
    [self.view presentScene:newGame transition:[SKTransition doorsOpenVerticalWithDuration:0.9]];
}
@end
