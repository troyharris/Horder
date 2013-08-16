//
//  GameScene.m
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "GameScene.h"
#import "LetterBox.h"
#import "InstructionBox.h"
#import "EndLevelBox.h"
#import "WordsDatabase.h"
#import "UIColor+FlatUI.h"
#import "NSString+THUtil.h"

@interface GameScene() {
    float verticalAxis, lateralAxis, longitudinalAxis;
}

@property (nonatomic) CGFloat boxWidth;
@property (nonatomic) CGFloat hudHeight;
@property (nonatomic) CGFloat hudMargin;
@property (nonatomic) CGFloat hudFontSize;
@property (nonatomic) CGFloat hudButtonSize;
@property (nonatomic) int foulSeconds;
@property (nonatomic) BOOL lost;
@property (nonatomic) BOOL boxesOnscreen;
@property (nonatomic) BOOL ended;
@property (nonatomic) int clock;
@property BOOL contentCreated;
@property (nonatomic, strong) NSMutableArray *draftWord;
@property (nonatomic, strong) SKLabelNode *wordLabel;
@property (nonatomic, strong) SKLabelNode *scoreLabel;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) SKSpriteNode *okayButton;
@property (nonatomic, strong) SKSpriteNode *clearButton;
@property (nonatomic, strong) SKSpriteNode *foulLine;
@property (nonatomic, strong) NSTimer *foulTimer;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) SKLabelNode *backgroundCounter;
@property (nonatomic, strong) SKLabelNode *gameClock;
@property (nonatomic, strong) InstructionBox *instruct;
@property (nonatomic, strong) EndLevelBox *endBox;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation GameScene

#pragma mark - Statics

static const uint32_t boxCategory   =  0x1 << 1;
static const uint32_t wallCategory  =  0x1 << 2;

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
    self.hudMargin = CGRectGetHeight(self.frame) / 64;
    self.hudFontSize = CGRectGetHeight(self.frame) / 32;
    self.hudButtonSize = CGRectGetHeight(self.frame) / 16;
    self.score = @0;
    self.draftWord = [[NSMutableArray alloc] init];
}

-(void)setupMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 1/30.0;
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error){
        CMAttitude *currentAttitude = devMotion.attitude;
        verticalAxis = currentAttitude.roll;
        lateralAxis = currentAttitude.pitch;
        longitudinalAxis = currentAttitude.yaw;
    }];
}

-(void)setupBackgroundMusic {
    NSString *bgMusicPath = [[NSBundle mainBundle] pathForResource:@"mygrimeydreams-horder" ofType:@"m4a"];
    NSURL *fileURL = [NSURL URLWithString:bgMusicPath];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [self.musicPlayer prepareToPlay];
    self.musicPlayer.delegate = self;
}

-(void)addBackground {
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:self.settings.backgroundName];
    background.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    self.backgroundCounter = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    self.backgroundCounter.fontSize = CGRectGetWidth(self.frame) - 20;
    self.backgroundCounter.text = @"5";
    self.backgroundCounter.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
    self.backgroundCounter.fontColor = [SKColor clearColor];
    self.backgroundCounter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.backgroundCounter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [background addChild:self.backgroundCounter];
    [self addChild:background];
}

-(void)addWalls {
    CGFloat thickness = 10.0;
    SKSpriteNode *floor = [[SKSpriteNode alloc] initWithColor:[SKColor cloudsColor] size:CGSizeMake(CGRectGetWidth(self.frame), thickness)];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), self.hudHeight + (thickness / 2));
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = wallCategory;
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
    self.wordLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    self.wordLabel.position = CGPointMake(self.hudMargin, self.hudMargin);
    self.wordLabel.color = [UIColor whiteColor];
    self.wordLabel.fontSize = self.hudFontSize;
    self.wordLabel.text = @" ";
    self.wordLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.wordLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:self.wordLabel];
    
    self.scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    self.scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - self.hudMargin, self.hudMargin + (CGRectGetHeight(self.scoreLabel.frame) /2));
    self.scoreLabel.color = [UIColor whiteColor];
    self.scoreLabel.fontSize = self.hudFontSize;
    self.scoreLabel.text = @"0";
    self.scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [self addChild:self.scoreLabel];
    
    self.okayButton = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(self.hudButtonSize, self.hudButtonSize)];
    self.okayButton.position = CGPointMake(CGRectGetMidX(self.frame), self.hudMargin + (CGRectGetHeight(self.okayButton.frame) /2));
    self.okayButton.name = @"okay";
    [self addChild:self.okayButton];
    
    self.clearButton = [[SKSpriteNode alloc] initWithColor:[UIColor pomegranateColor] size:CGSizeMake(self.hudButtonSize, self.hudButtonSize)];
    self.clearButton.position = CGPointMake(CGRectGetMidX(self.frame) + 70, self.hudMargin + (CGRectGetHeight(self.clearButton.frame) /2));
    self.clearButton.name = @"clear";
    [self addChild:self.clearButton];
}

-(void)addHiddenFoulLine {
    self.foulLine = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(CGRectGetWidth(self.frame), 1)];
    self.foulLine.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - self.boxWidth);
    [self addChild:self.foulLine];
}

-(void)displayInstructions {
    self.instruct = [[InstructionBox alloc] initWithSize:CGSizeMake(CGRectGetWidth(self.frame) / 2, CGRectGetWidth(self.frame) / 2) sceneWidth:CGRectGetWidth(self.frame)];
    self.instruct.instructions.text = [NSString stringWithFormat:@"Score at least %d points", self.settings.minScore];
    self.instruct.instructTime.text = [NSString stringWithFormat:@"In %@", [NSString secondsToString:self.settings.maxTime]];
    self.instruct.wordLength.text = [NSString stringWithFormat:@"Words must be at least %@ letters", [NSString numberToWord:self.settings.minLetters]];
    self.instruct.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:self.instruct];
}

-(void)createSceneContents {
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self setupVars];
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
    NSLog(@"Clock: %d:%@", minutes, secString);
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
    self.foulLine.color = [SKColor sunflowerColor];
}

-(void)hideFoulLine {
    self.foulLine.color = [SKColor clearColor];
}

# pragma mark - Letter Box Management

-(void)startBoxes {
    SKAction *makeBoxes = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addBox) onTarget:self],
                                                [SKAction waitForDuration:2.0 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeBoxes]];
}

- (void)addBox
{
    LetterBox *box = [[LetterBox alloc] initWithSize:CGSizeMake(self.boxWidth,self.boxWidth)];
    box.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    box.physicsBody.categoryBitMask = boxCategory;
    box.physicsBody.contactTestBitMask = boxCategory;
    [self addChild:box];
}

-(void)verifiedBoxes:(BOOL)thereAreBoxes {
    self.boxesOnscreen = thereAreBoxes;
}


#pragma mark - Physics, Touches & Collisions

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"beginButton"]) {
            [self.instruct removeFromParent];
            [self startBoxes];
            [self startGameTimer];
            [self.musicPlayer play];
        } else if ([node.name isEqualToString:@"nextButton"]) {
            [self.endBox removeFromParent];
            NSNumber *nextLevel = @([self.settings.levelNumber intValue] + 1);
            [self goToLevel:nextLevel];
        } else if ([node.name isEqualToString:@"retryButton"]) {
            [self.endBox removeFromParent];
            [self goToLevel:self.settings.levelNumber];
        }
        if ([node.name isEqualToString:@"okay"]) {
            [self submitWord];
        }
        else if ([node.name isEqualToString:@"clear"]) {
            [self clearWordWithWin:NO];
        }
        else if ([node.name isEqualToString:@"box"]) {
            SKLabelNode *nodeLetter = (SKLabelNode *)[node childNodeWithName:@"letter"];
            self.wordLabel.text = [NSString stringWithFormat:@"%@%@", self.wordLabel.text, nodeLetter.text];
            [(SKSpriteNode *)node setColor:[UIColor blackColor]];
            [self addLetterToDraft:node];
        }
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
//    NSLog(@"Box collided with Box");
    LetterBox *lb1, *lb2;
    lb1 = (LetterBox *)contact.bodyA.node;
    lb2 = (LetterBox *)contact.bodyB.node;
    lb1.hasCollided = YES;
    lb2.hasCollided = YES;
}

-(void)update:(CFTimeInterval)currentTime {
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
        }
    }
    [self.draftWord removeAllObjects];
    self.okayButton.color = [UIColor clearColor];
    self.wordLabel.text = @"";
}

-(void)updateScore:(int)addScore {
    int newScore = [self.score intValue] + addScore;
    self.score = [NSNumber numberWithInt:newScore];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", newScore];
}

-(void)addLetterToDraft:(SKNode *)node {
    [self.draftWord addObject:node];
    if (self.draftWord.count >= self.settings.minLetters) {
        self.okayButton.color = [UIColor sunflowerColor];
    }
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
    self.endBox = [EndLevelBox endBoxWithPass:passFail score:[self.score intValue] scoreNeeded:self.settings.minScore sceneWidth:CGRectGetWidth(self.frame)];
    self.endBox.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:self.endBox];
}

-(void)goToLevel:(NSNumber *)levelNum {
    LevelSettings *settings = [LevelSettings levelWithNumber:levelNum];
    SKScene *game = [GameScene sceneWithLevelSetup:settings size:self.size];
    CIFilter *blurTrans = [CIFilter filterWithName:@"CIModTransition"];
    [blurTrans setDefaults];
    self.shouldEnableEffects = YES;
    SKTransition *trans = [SKTransition transitionWithCIFilter:blurTrans duration:1.0];
    [self.view presentScene:game transition:trans];
}

#pragma - Class Methods

+(GameScene *)sceneWithLevelSetup:(LevelSettings *)levelSettings size:(CGSize)size {
    GameScene *gs = [[GameScene alloc] initWithSize:size];
    gs.settings = levelSettings;
    return gs;
}

@end
