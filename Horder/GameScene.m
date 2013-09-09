//
//  GameScene.m
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "GameScene.h"
#import "LevelSettings.h"
#import "InstructionBox.h"
#import "EndLevelBox.h"
#import "WordsDatabase.h"
#import "GlobalScore.h"
#import "HORSong.h"
#import "HORGameCenterManager.h"
#import "UIColor+FlatUI.h"
#import "NSString+THUtil.h"
#import "FISoundEngine.h"

@interface GameScene() {
    float verticalAxis, lateralAxis, longitudinalAxis;
}

@property (nonatomic) CGFloat boxWidth;
@property (nonatomic) CGFloat hudHeight;
@property (nonatomic) CGFloat hudMargin;
@property (nonatomic) CGFloat hudFontSize;
@property (nonatomic) CGFloat hudButtonSize;
@property (nonatomic) CGFloat hudScoreWidth;
@property (nonatomic) CGFloat boxRate;
@property (nonatomic) int foulSeconds;
@property (nonatomic) BOOL lost;
@property (nonatomic) BOOL boxesOnscreen;
@property (nonatomic) BOOL ended;
@property (nonatomic) int clock;
@property BOOL contentCreated;
@property (nonatomic, strong) NSMutableArray *draftWord;
@property (nonatomic, strong) SKSpriteNode *background;
@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *totalScoreLabel;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) SKSpriteNode *okayButton;
@property (nonatomic, strong) SKSpriteNode *clearButton;
@property (nonatomic, strong) SKSpriteNode *foulLine;
@property (nonatomic, strong) NSTimer *foulTimer;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) SKLabelNode *backgroundCounter;
@property (nonatomic, strong) UILabel *gameClock;
@property (nonatomic, strong) InstructionBox *instruct;
@property (nonatomic, strong) EndLevelBox *endBox;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) FISoundEngine *soundEngine;
@property (nonatomic, strong) FISound *boxHitSound;

@end

@implementation GameScene

#pragma mark - Statics

static const uint32_t boxCategory   =  0x1 << 1;
static const uint32_t wallCategory  =  0x1 << 2;
static const uint32_t floorCategory =  0x1 << 3;

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

#pragma mark - SKView methods

- (void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        self.physicsWorld.contactDelegate = self;
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)didSimulatePhysics
{
    verticalAxis = self.motionManager.deviceMotion.attitude.roll;
    CGFloat xForce = self.settings.moonGravity ? -1 : -9.8;
    if (self.lost == YES && self.boxesOnscreen == YES && self.ended == 0) {
        [self removeAllActions];
        xForce = 9.8;
    }
    self.physicsWorld.gravity=CGPointMake(verticalAxis*10, xForce);
    if (self.lost == YES && self.boxesOnscreen == NO && self.ended == 0) {
        [self displayEnd];
        self.ended = 1;
    }
    [self verifiedBoxes:NO];
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        [self verifiedBoxes:YES];
        if (node.position.y > (CGRectGetHeight(self.frame) + self.boxWidth) && self.lost == YES) {
            [node removeFromParent];
        }
    }];
}

#pragma mark - Scene Setup

- (void)setupVars {
    self.clock = self.settings.maxTime;
    self.foulSeconds = 0;
    self.boxWidth = CGRectGetWidth(self.frame) / 8;
    self.hudHeight = CGRectGetHeight(self.frame) / 8;
    self.hudMargin = self.hudHeight / 16;
    self.hudFontSize = self.hudHeight / 2;
    self.hudButtonSize = CGRectGetHeight(self.frame) / 16;
    self.hudScoreWidth = CGRectGetWidth(self.frame) / 4;
    self.score = @0;
    self.draftWord = [[NSMutableArray alloc] init];
    self.globalScore = [GlobalScore sharedScore];
    self.boxRate = self.settings.finalLevel ? 1.3 : 2.0;
}

- (void)setupSoundEngine {
    self.soundEngine = [FISoundEngine sharedEngine];
    self.boxHitSound = [self.soundEngine soundNamed:@"HORBoxClick0.wav" maxPolyphony:16 error:nil];
}

-(void)setupMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
/*
    self.motionManager.deviceMotionUpdateInterval = 1/30.0;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error){
        CMAttitude *currentAttitude = devMotion.attitude;
        verticalAxis = currentAttitude.roll;
        lateralAxis = currentAttitude.pitch;
        longitudinalAxis = currentAttitude.yaw;
    }];
 */
    [self.motionManager startDeviceMotionUpdates];
}

-(void)setupBackgroundMusic {
    HORSong *song = [HORSong randomSong];
    NSString *bgMusicPath = [[NSBundle mainBundle] pathForResource:song.filename ofType:song.extension];
    NSURL *fileURL = [NSURL URLWithString:bgMusicPath];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [self.musicPlayer prepareToPlay];
    self.musicPlayer.delegate = self;
}

-(void)addBackground {
    self.background = [[SKSpriteNode alloc] initWithImageNamed:self.settings.backgroundName];
    self.background.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.backgroundCounter = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    self.backgroundCounter.fontSize = CGRectGetWidth(self.frame) - 20;
    self.backgroundCounter.text = @"5";
    self.backgroundCounter.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
    self.backgroundCounter.fontColor = [SKColor clearColor];
    self.backgroundCounter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.backgroundCounter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [self.background addChild:self.backgroundCounter];
    [self addChild:self.background];
}

-(void)addWalls {
    CGFloat thickness = 10.0;
    SKColor *hudColor = self.settings.darkHUD ? [SKColor hudDarkColor] : [SKColor hudColor];
    SKSpriteNode *floor = [[SKSpriteNode alloc] initWithColor:hudColor size:CGSizeMake(CGRectGetWidth(self.frame), self.hudHeight)];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), self.hudHeight / 2);
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = floorCategory;
    [self addChild:floor];
    
    SKSpriteNode *leftwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(thickness, CGRectGetHeight(self.frame) - self.hudHeight + thickness)];
    leftwall.position = CGPointMake(-(thickness / 2), CGRectGetMidY(self.frame) + (self.hudHeight + thickness) / 2);
    leftwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftwall.size];
    leftwall.physicsBody.dynamic = NO;
    leftwall.physicsBody.categoryBitMask = wallCategory;
    [self addChild:leftwall];
    
    SKSpriteNode *rightwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(thickness, CGRectGetHeight(self.frame) - 210)];
    rightwall.position = CGPointMake(CGRectGetMaxX(self.frame) + (thickness / 2), CGRectGetMidY(self.frame) + (self.hudHeight + thickness) / 2);
    rightwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightwall.size];
    rightwall.physicsBody.dynamic = NO;
    rightwall.physicsBody.categoryBitMask = wallCategory;
    [self addChild:rightwall];
}

-(void)addHUD {
    CGFloat yOrigin = (CGRectGetHeight(self.frame) - self.hudHeight) + self.hudMargin;
    CGFloat width = 400;
    CGFloat xOrigin = (CGRectGetWidth(self.frame) / 2) - (width / 2);
    CGRect wordFrame = CGRectMake(xOrigin, yOrigin, width, 60);
    self.wordLabel = [[UILabel alloc] initWithFrame:wordFrame];
    //self.wordLabel.position = CGPointMake(self.hudMargin, self.hudMargin);
    //self.wordLabel.color = [UIColor asbestosColor];
    self.wordLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:60];
    self.wordLabel.textColor = [UIColor whiteColor];
    //self.wordLabel.fontSize = self.hudFontSize;
    self.wordLabel.text = @" ";
    //self.wordLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    //self.wordLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.wordLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.wordLabel];
    CGRect scoreTitleFrame = CGRectMake(CGRectGetMaxX(self.frame) - self.hudScoreWidth - self.hudMargin, yOrigin, self.hudScoreWidth, 40);
    UILabel *scoreTitle = [[UILabel alloc] initWithFrame:scoreTitleFrame];
    scoreTitle.textColor = [UIColor whiteColor];
    scoreTitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    scoreTitle.text = @"Level Score";
    scoreTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:scoreTitle];
    //self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    
    CGRect scoreFrame = CGRectMake(CGRectGetMinX(scoreTitle.frame), CGRectGetMaxY(self.frame) - self.hudMargin - 50, self.hudScoreWidth, 50);
    self.scoreLabel = [[UILabel alloc] initWithFrame:scoreFrame];
    self.scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d / %d", 0, self.settings.minScore];
    [self.view addSubview:self.scoreLabel];
    /*
    self.scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - self.hudMargin, self.hudMargin + (CGRectGetHeight(self.scoreLabel.frame) /2));
    self.scoreLabel.color = [UIColor whiteColor];
    self.scoreLabel.fontSize = self.hudFontSize;
    self.scoreLabel.text = @"0";
    self.scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [self addChild:self.scoreLabel];
     */
    
    CGRect globalTitleFrame = CGRectMake(self.hudMargin, yOrigin, self.hudScoreWidth, 40);
    UILabel *globalTitle = [[UILabel alloc] initWithFrame:globalTitleFrame];
    globalTitle.textColor = [UIColor whiteColor];
    globalTitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];
    globalTitle.text = @"Total Score";
    globalTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:globalTitle];
    
    CGRect totalScoreFrame = CGRectMake(self.hudMargin, CGRectGetMaxY(self.frame) - self.hudMargin - 50, self.hudScoreWidth, 50);
    self.totalScoreLabel = [[UILabel alloc] initWithFrame:totalScoreFrame];
    self.totalScoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    self.totalScoreLabel.textAlignment = NSTextAlignmentCenter;
    self.totalScoreLabel.textColor = [UIColor whiteColor];
    self.totalScoreLabel.text = [NSString stringWithFormat:@"%d", [self.globalScore.currentScore intValue]];
    [self.view addSubview:self.totalScoreLabel];
    
    self.clearButton = [[SKSpriteNode alloc] initWithImageNamed:@"cancel"];
    //self.clearButton = [[SKSpriteNode alloc] initWithColor:[UIColor pomegranateColor] size:CGSizeMake(self.hudButtonSize, self.hudButtonSize)];
    self.clearButton.position = CGPointMake(CGRectGetMidX(self.frame) + 35, self.hudMargin + (CGRectGetHeight(self.clearButton.frame) /2));
    self.clearButton.name = @"clear";
    [self addChild:self.clearButton];
    
    [self addOkayButton];
    
    //CGRect clockFrame = CGRectMake(self.hudMargin, CGRectGetMaxY(self.frame) - ((self.hudHeight / 2) + 30), self.hudScoreWidth, 60);
    CGRect clockFrame = CGRectMake(self.hudMargin, self.hudMargin, self.hudScoreWidth / 2, 60);
    self.gameClock = [[UILabel alloc] initWithFrame:clockFrame];
    self.gameClock.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:32];;
    self.gameClock.textColor = self.settings.blackClock ? [UIColor asbestosColor] : [UIColor whiteColor];
    self.gameClock.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.gameClock];
    
}

-(void)addOkayButton {
    self.okayButton = [[SKSpriteNode alloc] initWithImageNamed:@"check"];
    //self.okayButton = [[SKSpriteNode alloc] initWithColor:[UIColor sunflowerColor] size:CGSizeMake(self.hudButtonSize, self.hudButtonSize)];
    self.okayButton.position = CGPointMake(CGRectGetMidX(self.frame) - 35, self.hudMargin + (CGRectGetHeight(self.okayButton.frame) /2));
    self.okayButton.name = @"notOkay";
    //[self addChild:self.okayButton];
}

-(void)addHiddenFoulLine {
    self.foulLine = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(CGRectGetWidth(self.frame), 1)];
    self.foulLine.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - self.boxWidth);
    [self addChild:self.foulLine];
}

-(void)displayInstructions {
    self.instruct = [[InstructionBox alloc] initWithSize:CGSizeMake(CGRectGetWidth(self.frame) / 2, CGRectGetWidth(self.frame) / 2) sceneWidth:CGRectGetWidth(self.frame)];
    if (!self.settings.finalLevel) {
        self.instruct.instructions.text = [NSString stringWithFormat:@"Score at least %d points", self.settings.minScore];
        self.instruct.instructTime.text = [NSString stringWithFormat:@"In %@", [NSString secondsToString:self.settings.maxTime]];
        self.instruct.wordLength.text = [NSString stringWithFormat:@"Words must be at least %@ letters", [NSString numberToWord:self.settings.minLetters]];
    } else {
        self.instruct.instructions.text = @"Final Level";
        self.instruct.instructTime.text = @"There is no time limit";
        self.instruct.wordLength.text = @"Score as many points as you can";
    }
    self.instruct.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:self.instruct];
}

-(void)createSceneContents {
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self setupVars];
    [self setupSoundEngine];
    [self setupMotionManager];
    [self setupBackgroundMusic];
    [self addBackground];
    [self addWalls];
    [self addHUD];
    [self addHiddenFoulLine];
    [self displayInstructions];
    [self startFoulTimer];
}

#pragma mark - Game Timer

-(void)startGameTimer {
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementClock) userInfo:nil repeats:YES];
}

-(void)incrementClock {
    self.clock--;
    if (self.clock <= 0) {
        self.gameClock.text = @"0:00";
        [self.gameTimer invalidate];
        self.lost = YES;
        NSLog(@"You lost and the timer should be stopped here.");
        return;
    }
    int seconds = self.clock % 60;
    int minutes = self.clock / 60;
    NSString *secString;
    if (seconds < 10) {
        secString = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        secString = [NSString stringWithFormat:@"%d", seconds];
    }
    //NSLog(@"Clock: %d:%@", minutes, secString);
    self.gameClock.text = [NSString stringWithFormat:@"%d:%@", minutes, secString];
}

#pragma mark - Foul line

-(void)startFoulTimer {
    self.foulTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkForFoul) userInfo:nil repeats:YES];
}

-(void)checkForFoul {
    BOOL didFoul = NO;
    for (SKNode *n in [self children]) {
        if ([n.name isEqualToString:@"box"]) {
            LetterBox *lb = (LetterBox *)n;
            if (CGRectGetMaxY(lb.frame) > CGRectGetMaxY(self.foulLine.frame) && lb.hasCollided == YES) {
                didFoul = YES;
                NSLog(@"BOX IS TOO HIGH!! ARRHHHH!!! For %d seconds", self.foulSeconds);
            }
        }
    }
    if (didFoul == YES) {
        self.foulSeconds++;
        [self showFoulLine];
    }
    if (didFoul == YES && self.foulSeconds > 1) {
        int countdown = 7 - self.foulSeconds;
        if (countdown <= 0) {
            countdown = 0;
           // [self removeAllActions];
            self.lost = YES;
            
        }
        self.backgroundCounter.text = [NSString stringWithFormat:@"%d", countdown];
        self.backgroundCounter.fontColor = [SKColor whiteColor];
    }
    if (didFoul == NO) {
        if (self.foulSeconds > 0) {
            self.foulSeconds = 0;
            self.backgroundCounter.fontColor = [SKColor clearColor];
            [self hideFoulLine];
            NSLog(@"Out of Foul Trouble");
        }
    }
}

- (void) stopFoulTimer {
    //reset timer
    if (self.foulTimer != nil) {
        [self.foulTimer invalidate];
        self.foulTimer = nil;
    }
}

-(void)showFoulLine {
    //self.foulLine.color = [SKColor sunflowerColor];
    SKAction *colorChange = [SKAction colorizeWithColor:[UIColor sunflowerColor] colorBlendFactor:0.9 duration:0.5];
    SKAction *colorChangeWhite = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:0.9 duration:0.5];
    SKAction *seq = [SKAction sequence:@[colorChange, colorChangeWhite]];
    [self.background runAction:[SKAction repeatActionForever:seq]];
}

-(void)hideFoulLine {
    //self.foulLine.color = [SKColor clearColor];
    [self.background removeAllActions];
}

# pragma mark - Letter Box Management

-(void)startBoxes {
    SKAction *makeBoxes = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addBox) onTarget:self],
                                                [SKAction waitForDuration:self.boxRate withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeBoxes]];
}

- (void)addBox {
    LetterBox *box = [LetterBox letterBoxWithSize:CGSizeMake(self.boxWidth, self.boxWidth) bigBoxes:self.settings.wideBoxes explodingBoxes:self.settings.explodingBoxes wildCardBoxes:self.settings.wildCard];
    box.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    box.physicsBody.categoryBitMask = boxCategory;
    box.physicsBody.contactTestBitMask = boxCategory | floorCategory;
    box.delegate = self;
    [self addChild:box];
}

-(void)verifiedBoxes:(BOOL)thereAreBoxes {
    self.boxesOnscreen = thereAreBoxes;
}

-(void)removedLetterBoxFromParent:(LetterBox *)letterBox {
    if (letterBox.inWord) {
        [self.draftWord removeObjectIdenticalTo:letterBox];
        [self updateWordLabel];
    }
}


#pragma mark - Physics, Touches & Collisions

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"beginButton"]) {
            [self.instruct removeFromParent];
            [self startBoxes];
            if (self.settings.maxTime > 0) {
                [self startGameTimer];
            }
            [self.musicPlayer play];
        } else if ([node.name isEqualToString:@"nextButton"]) {
            [self.endBox removeFromParent];
            NSNumber *nextLevel = @([self.settings.levelNumber intValue] + 1);
            NSLog(@"Going to Level %d", [nextLevel intValue]);
            self.globalScore.currentScore = @([self.globalScore.currentScore intValue] + [self.score intValue]);
            NSLog(@"Global Score is now %d", [self.globalScore.currentScore intValue]);
            [self goToLevel:nextLevel];
        } else if ([node.name isEqualToString:@"retryButton"]) {
            [HORGameCenterManager updateScore:[self.globalScore.currentScore integerValue]];
            [self.endBox removeFromParent];
            self.globalScore.currentScore = @0;
            //[self goToLevel:self.settings.levelNumber];
            [self goToLevel:@1];
        }
        if ([node.name isEqualToString:@"okay"]) {
            [self submitWord];
        }
        else if ([node.name isEqualToString:@"clear"]) {
            [self clearWordWithWin:NO];
        }
        else if ([node.name isEqualToString:@"box"]) {
            LetterBox *selectBox = (LetterBox *)node;
            [self addLetterToDraft:selectBox];
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
//    NSLog(@"Box collided with Box");
//    NSLog(@"contact impulse: %f", contact.collisionImpulse);
    if (contact.bodyA.categoryBitMask == floorCategory || contact.bodyB.categoryBitMask == floorCategory) {
        if (contact.collisionImpulse > 40) {
            //[self runAction:[SKAction playSoundFileNamed:[self clickSound] waitForCompletion:YES]];
            [self clickSoundWithImpulse:contact.collisionImpulse];
        }
    }
    if (contact.bodyA.categoryBitMask == boxCategory && contact.bodyB.categoryBitMask == boxCategory) {
        if (contact.collisionImpulse > 40) {
            //[self runAction:[SKAction playSoundFileNamed:[self clickSound] waitForCompletion:YES]];
            [self clickSoundWithImpulse:contact.collisionImpulse];
        }
        LetterBox *lb1, *lb2;
        lb1 = (LetterBox *)contact.bodyA.node;
        lb2 = (LetterBox *)contact.bodyB.node;
        lb1.hasCollided = YES;
        lb2.hasCollided = YES;
        if ([lb1.letterNode.text isEqualToString:@"*"] || [lb2.letterNode.text isEqualToString:@"*"]) {
            [lb2 hitByExploder];
            [lb1 hitByExploder];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /*
    CGFloat xForce = -9.8;
    if (self.lost == YES && self.boxesOnscreen == YES && self.ended == 0) {
        [self removeAllActions];
        xForce = 9.8;
    }
    self.physicsWorld.gravity=CGPointMake(verticalAxis*10, xForce);
    if (self.lost == YES && self.boxesOnscreen == NO && self.ended == 0) {
        [self displayEnd];
        self.ended = 1;
    }
     */
}
     

#pragma mark - Word Management

-(void)submitWord {
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    for (LetterBox *n in self.draftWord) {
        [letters addObject:n.letterNode.text];
    }
    NSString *theWord = [letters componentsJoinedByString:@""];
    NSLog(@"Word is: %@", theWord);
    if ([WordsDatabase isWord:theWord]) {
        [self updateScore:[WordsDatabase wordScore:theWord]];
        for (SKNode *b in self.draftWord) {
            SKAction *zoom = [SKAction scaleBy:8 duration:0.2];
            SKAction *fade = [SKAction fadeOutWithDuration:0.2];
            SKAction *group = [SKAction group:@[zoom, fade]];
            SKAction *remove = [SKAction removeFromParent];
            SKAction *seq = [SKAction sequence:@[group, remove]];
            [b runAction:seq];
        }
        [self clearWordWithWin:YES];
    } else {
        NSLog(@"Invalid Word");
        [self clearWordWithWin:NO];
    }
}

-(void)clearWordWithWin:(BOOL)win {
    if (!win) {
        for (LetterBox *n in self.draftWord) {
            n.color = n.originalColor;
            n.inWord = NO;
        }
    }
    [self.draftWord removeAllObjects];
    [self.okayButton removeFromParent];
    self.okayButton.name = @"notOkay";
    self.wordLabel.text = @"";
}

-(void)updateScore:(int)addScore {
    int newScore = [self.score intValue] + addScore;
    self.score = [NSNumber numberWithInt:newScore];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d / %d", newScore, self.settings.minScore];
}

-(void)addLetterToDraft:(LetterBox *)node {
    if (!node.inWord) {
        self.wordLabel.text = [NSString stringWithFormat:@"%@%@", self.wordLabel.text, node.letterNode.text];
        node.color = [UIColor blackColor];
        [self.draftWord addObject:node];
        node.inWord = YES;
    }
    if (self.draftWord.count >= self.settings.minLetters && [self.okayButton.name isEqualToString:@"notOkay"]) {
        [self addChild:self.okayButton];
        self.okayButton.name = @"okay";
    }
}

- (void)clickSoundWithImpulse:(CGFloat)impulse {
    CGFloat volume = (impulse - 60) / 100;
    volume = volume > 1 ? 1.0 : volume;
    volume = volume < 0 ? 0.0 : volume;
    volume = volume * 0.6;
//    NSLog(@"Volume is: %f", volume);
    [self.boxHitSound playWithGain:volume];
}

-(void)updateWordLabel {
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    for (LetterBox *lb in self.draftWord) {
        [letters addObject:lb.letterNode.text];
    }
    self.wordLabel.text = [letters componentsJoinedByString:@""];
}

#pragma - Game Flow

-(void)displayEnd {
        [self.musicPlayer stop];
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    BOOL passFail;
    if ([self.score intValue] >= self.settings.minScore) {
        passFail = YES;
    } else {
        passFail = NO;
    }
    if (!self.settings.finalLevel) {
        self.endBox = [EndLevelBox endBoxWithPass:passFail score:[self.score intValue] scoreNeeded:self.settings.minScore sceneWidth:CGRectGetWidth(self.frame)];
    } else {
        self.endBox = [EndLevelBox finalLevelEndBoxWithScore:[self.globalScore.currentScore intValue] + [self.score intValue] sceneWidth:CGRectGetWidth(self.frame)];
    }
    self.endBox.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:self.endBox];
}

-(void)goToLevel:(NSNumber *)levelNum {
    LevelSettings *settings = [LevelSettings levelWithNumber:levelNum];
    GameScene *game = [GameScene sceneWithLevelSetup:settings size:self.size];
    CIFilter *blurTrans = [CIFilter filterWithName:@"CIModTransition"];
    [blurTrans setDefaults];
    self.shouldEnableEffects = YES;
    SKTransition *trans = [SKTransition transitionWithCIFilter:blurTrans duration:1.0];
    NSLog(@"GOING TO LEVEL %d NOW", [game.settings.levelNumber intValue]);
    [self.view presentScene:game transition:trans];
}

#pragma - Class Methods

+(GameScene *)sceneWithLevelSetup:(LevelSettings *)levelSettings size:(CGSize)size {
    GameScene *gs = [[GameScene alloc] initWithSize:size];
    gs.settings = levelSettings;
    return gs;
}

@end
