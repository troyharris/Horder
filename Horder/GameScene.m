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

@interface GameScene() {
    CGFloat boxWidth;
    CGFloat hudHeight;
    CGFloat hudMargin;
    CGFloat hudFontSize;
    CGFloat hudButtonSize;
    int foulSeconds;
    BOOL lost;
    BOOL boxesOnscreen;
    BOOL ended;
    int clock;
}

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

@end

@implementation GameScene

static const uint32_t boxCategory        =  0x1 << 1;
static const uint32_t wallCategory    =  0x1 << 2;

-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        self.physicsWorld.contactDelegate = self;
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
    clock = 120;
    [self startGameTimer];
    foulSeconds = 0;
    boxWidth = CGRectGetWidth(self.frame) / 8;
    hudHeight = CGRectGetHeight(self.frame) / 8;
    hudMargin = CGRectGetHeight(self.frame) / 64;
    hudFontSize = CGRectGetHeight(self.frame) / 32;
    hudButtonSize = CGRectGetHeight(self.frame) / 16;
    srand([[NSDate date] timeIntervalSince1970]);
    _score = @0;
    _draftWord = [[NSMutableArray alloc] init];
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1/30.0;
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error){
        CMAttitude *currentAttitude = devMotion.attitude;
        verticalAxis = currentAttitude.roll;
        lateralAxis = currentAttitude.pitch;
        longitudinalAxis = currentAttitude.yaw;
    }];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self addBackground];
    [self addWalls];
    [self addHUD];
    [self addHiddenFoulLine];
    [self displayInstructions];
    
    /*
    SKAction *makeBoxes = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addBox) onTarget:self],
                                                [SKAction waitForDuration:2.0 withRange:0.15]
                                                ]];
    //[self runAction: [SKAction repeatActionForever:makeBoxes]];
     */
    [self startFoulTimer];
}

-(void)startGameTimer {
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(incrementClock) userInfo:nil repeats:YES];
}

-(void)incrementClock {
    clock--;
    if (clock <= 0) {
        _gameClock.text = @"0:00";
        [_gameTimer invalidate];
        lost = YES;
        return;
    }
    int seconds = clock % 60;
    int minutes = clock / 60;
    NSString *secString;
    if (seconds < 10) {
        secString = [NSString stringWithFormat:@"0%d", seconds];
    } else {
        secString = [NSString stringWithFormat:@"%d", seconds];
    }
    NSLog(@"Clock: %d:%@", minutes, secString);
    _gameClock.text = [NSString stringWithFormat:@"%d:%@", minutes, secString];
}

-(void)startFoulTimer {
    _foulTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkForFoul) userInfo:nil repeats:YES];
}

-(void)displayInstructions {
    _instruct = [[InstructionBox alloc] initWithSize:CGSizeMake(CGRectGetWidth(self.frame) / 2, CGRectGetWidth(self.frame) / 2) sceneWidth:CGRectGetWidth(self.frame)];
    _instruct.instructions.text = @"Score at least 50 points";
    _instruct.instructTime.text = @"In two minutes";
    _instruct.wordLength.text = @"Words must be at least three letters";
    
    _instruct.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:_instruct];
}

-(void)startBoxes {
    SKAction *makeBoxes = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addBox) onTarget:self],
                                                [SKAction waitForDuration:2.0 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeBoxes]];
}

-(void)checkForFoul {
    BOOL didFoul = NO;
    for (SKNode *n in [self children]) {
        if ([n.name isEqualToString:@"box"]) {
            LetterBox *lb = (LetterBox *)n;
            if (CGRectGetMaxY(lb.frame) > CGRectGetMaxY(_foulLine.frame) && lb.hasCollided == YES) {
                didFoul = YES;
                NSLog(@"BOX IS TOO HIGH!! ARRHHHH!!! For %d seconds", foulSeconds);
            }
        }
    }
    if (didFoul == YES) {
        foulSeconds++;
        [self showFoulLine];
    }
    if (didFoul == YES && foulSeconds > 1) {
        int countdown = 7 - foulSeconds;
        if (countdown <= 0) {
            countdown = 0;
           // [self removeAllActions];
            lost = YES;
            
        }
        _backgroundCounter.text = [NSString stringWithFormat:@"%d", countdown];
        _backgroundCounter.fontColor = [SKColor whiteColor];
    }
    if (didFoul == NO) {
        if (foulSeconds > 0) {
            foulSeconds = 0;
            _backgroundCounter.fontColor = [SKColor clearColor];
            [self hideFoulLine];
            NSLog(@"Out of Foul Trouble");
        }
    }
}

- (void) stopFoulTimer {
    //reset timer
    if (_foulTimer != nil) {
        [_foulTimer invalidate];
        _foulTimer = nil;
    }
}

-(void)addBackground {
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"bokehtest"];
    background.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    _backgroundCounter = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    _backgroundCounter.fontSize = CGRectGetWidth(self.frame) - 20;
    _backgroundCounter.text = @"5";
    _backgroundCounter.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
    _backgroundCounter.fontColor = [SKColor clearColor];
    _backgroundCounter.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _backgroundCounter.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [background addChild:_backgroundCounter];
    [self addChild:background];
}

-(void)addHUD {
    /*
    CGSize hudSize = CGSizeMake(CGRectGetWidth(self.frame), hudHeight);
    CGPoint hudPosition = CGPointMake(CGRectGetMidX(self.frame), hudHeight / 2);
    CGPoint hudViewPosition = CGPointMake(0, CGRectGetMaxY(self.frame) - hudHeight);
     */
    
    _wordLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    _wordLabel.position = CGPointMake(hudMargin, hudMargin);
    _wordLabel.color = [UIColor whiteColor];
    _wordLabel.fontSize = hudFontSize;
    _wordLabel.text = @" ";
    _wordLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _wordLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    [self addChild:_wordLabel];
    
    _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-Black"];
    _scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame) - hudMargin, hudMargin + (CGRectGetHeight(_scoreLabel.frame) /2));
    _scoreLabel.color = [UIColor whiteColor];
    _scoreLabel.fontSize = hudFontSize;
    _scoreLabel.text = @"0";
    _scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [self addChild:_scoreLabel];
    
    _okayButton = [[SKSpriteNode alloc] initWithColor:[UIColor clearColor] size:CGSizeMake(hudButtonSize, hudButtonSize)];
    _okayButton.position = CGPointMake(CGRectGetMidX(self.frame), hudMargin + (CGRectGetHeight(_okayButton.frame) /2));
    _okayButton.name = @"okay";
    [self addChild:_okayButton];
    
    _clearButton = [[SKSpriteNode alloc] initWithColor:[UIColor pomegranateColor] size:CGSizeMake(hudButtonSize, hudButtonSize)];
    _clearButton.position = CGPointMake(CGRectGetMidX(self.frame) + 70, hudMargin + (CGRectGetHeight(_clearButton.frame) /2));
    _clearButton.name = @"clear";
    [self addChild:_clearButton];
    
    
}

-(void)addWalls {
    CGFloat thickness = 10.0;
//    CGFloat edge = CGRectGetWidth(self.frame) / 8;
    SKSpriteNode *floor = [[SKSpriteNode alloc] initWithColor:[SKColor cloudsColor] size:CGSizeMake(CGRectGetWidth(self.frame), thickness)];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), hudHeight + (thickness / 2));
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.physicsBody.categoryBitMask = wallCategory;
    [self addChild:floor];
    
    SKSpriteNode *leftwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(thickness, CGRectGetHeight(self.frame) - hudHeight + thickness)];
    leftwall.position = CGPointMake(-(thickness / 2), CGRectGetMidY(self.frame) + (hudHeight + thickness) / 2);
    leftwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftwall.size];
    leftwall.physicsBody.dynamic = NO;
    leftwall.physicsBody.categoryBitMask = wallCategory;
    [self addChild:leftwall];
    
    SKSpriteNode *rightwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(thickness, CGRectGetHeight(self.frame) - 210)];
    rightwall.position = CGPointMake(CGRectGetMaxX(self.frame) + (thickness / 2), CGRectGetMidY(self.frame) + (hudHeight + thickness) / 2);
    rightwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightwall.size];
    rightwall.physicsBody.dynamic = NO;
    rightwall.physicsBody.categoryBitMask = wallCategory;
    [self addChild:rightwall];
}

-(void)addHiddenFoulLine {
    _foulLine = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(CGRectGetWidth(self.frame), 1)];
    _foulLine.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - boxWidth);
    [self addChild:_foulLine];
}

-(void)showFoulLine {
    _foulLine.color = [SKColor sunflowerColor];
}

-(void)hideFoulLine {
    _foulLine.color = [SKColor clearColor];
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addBox
{
    LetterBox *box = [[LetterBox alloc] initWithSize:CGSizeMake(boxWidth,boxWidth)];
    box.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    box.physicsBody.categoryBitMask = boxCategory;
    box.physicsBody.contactTestBitMask = boxCategory;
    [self addChild:box];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"beginButton"]) {
            [_instruct removeFromParent];
            [self startBoxes];
        }
        if ([node.name isEqualToString:@"okay"]) {
            [self submitWord];
        }
        else if ([node.name isEqualToString:@"clear"]) {
            [self clearWordWithWin:NO];
        }
        else if ([node.name isEqualToString:@"box"]) {
            SKLabelNode *nodeLetter = (SKLabelNode *)[node childNodeWithName:@"letter"];
            _wordLabel.text = [NSString stringWithFormat:@"%@%@", _wordLabel.text, nodeLetter.text];
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

-(void)submitWord {
    NSMutableArray *letters = [[NSMutableArray alloc] init];
    for (LetterBox *n in _draftWord) {
        [letters addObject:n.letterNode.text];
    }
    NSString *theWord = [letters componentsJoinedByString:@""];
    NSLog(@"Word is: %@", theWord);
    if ([WordsDatabase isWord:theWord]) {
        [self updateScore:[WordsDatabase wordScore:theWord]];
        for (SKNode *b in _draftWord) {
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
        for (LetterBox *n in _draftWord) {
            n.color = n.originalColor;
        }
    }
    [_draftWord removeAllObjects];
    _okayButton.color = [UIColor clearColor];
    _wordLabel.text = @"";
}

-(void)updateScore:(int)addScore {
    int newScore = [_score intValue] + addScore;
    _score = [NSNumber numberWithInt:newScore];
    _scoreLabel.text = [NSString stringWithFormat:@"%d", newScore];
}

-(void)addLetterToDraft:(SKNode *)node {
    [_draftWord addObject:node];
    if (_draftWord.count >= 3) {
        _okayButton.color = [UIColor sunflowerColor];
    }
}

-(void)didSimulatePhysics
{
    [self verifiedBoxes:NO];
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        [self verifiedBoxes:YES];
        if (node.position.y > (CGRectGetHeight(self.frame) + boxWidth) && lost == YES) {
            [node removeFromParent];
        }
    }];
}

-(void)verifiedBoxes:(BOOL)thereAreBoxes {
    boxesOnscreen = thereAreBoxes;
}

-(void)displayEnd {
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    BOOL passFail;
    if ([_score intValue] > 50) {
        passFail = YES;
    } else {
        passFail = NO;
    }
    _endBox = [EndLevelBox endBoxWithPass:passFail score:[_score intValue] scoreNeeded:100 sceneWidth:CGRectGetWidth(self.frame)];
    _endBox.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    [self addChild:_endBox];
}

-(void)update:(CFTimeInterval)currentTime {
    CGFloat xForce = -9.8;
    if (lost == YES && boxesOnscreen == YES && ended == 0) {
        [self removeAllActions];
        xForce = 9.8;
    }
    self.physicsWorld.gravity=CGPointMake(verticalAxis*10, xForce);
    if (lost == YES && boxesOnscreen == NO && ended == 0) {
        [self displayEnd];
        ended = 1;
    }
}

@end
