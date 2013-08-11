//
//  GameScene.m
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "GameScene.h"
#import "LetterBox.h"
#import "WordsDatabase.h"
#import "UIColor+FlatUI.h"

@interface GameScene() {
    CGFloat boxWidth;
    CGFloat hudHeight;
    CGFloat hudMargin;
    CGFloat hudFontSize;
    CGFloat hudButtonSize;
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

@end

@implementation GameScene

-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
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
    SKAction *makeBoxes = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addBox) onTarget:self],
                                                [SKAction waitForDuration:2.0 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeBoxes]];
    [self startFoulTimer];
}

-(void)startFoulTimer {
    _foulTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkForFoul) userInfo:nil repeats:YES];
}

-(void)checkForFoul {
    for (SKNode *n in [self children]) {
        if ([n.name isEqualToString:@"box"]) {
            if (CGRectGetMinY(n.frame) < CGRectGetMinY(_foulLine.frame)) {
                NSLog(@"BOX IS TOO HIGH!! ARRHHHH!!!");
            }
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
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"background-level1-hud"];
    background.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
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
    
    _okayButton = [[SKSpriteNode alloc] initWithColor:[UIColor sunflowerColor] size:CGSizeMake(hudButtonSize, hudButtonSize)];
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
    [self addChild:floor];
    
    SKSpriteNode *leftwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(thickness, CGRectGetHeight(self.frame) - hudHeight + thickness)];
    leftwall.position = CGPointMake(-(thickness / 2), CGRectGetMidY(self.frame) + (hudHeight + thickness) / 2);
    leftwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftwall.size];
    leftwall.physicsBody.dynamic = NO;
    [self addChild:leftwall];
    
    SKSpriteNode *rightwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(thickness, CGRectGetHeight(self.frame) - 210)];
    rightwall.position = CGPointMake(CGRectGetMaxX(self.frame) + (thickness / 2), CGRectGetMidY(self.frame) + (hudHeight + thickness) / 2);
    rightwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightwall.size];
    rightwall.physicsBody.dynamic = NO;
    [self addChild:rightwall];
}

-(void)addHiddenFoulLine {
    _foulLine = [[SKSpriteNode alloc] initWithColor:[SKColor clearColor] size:CGSizeMake(CGRectGetWidth(self.frame), 1)];
    _foulLine.position = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame) - boxWidth);
    [self addChild:_foulLine];
}

-(void)showFoulLine {
    
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
    [self addChild:box];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
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
    _wordLabel.text = @"";
}

-(void)updateScore:(int)addScore {
    int newScore = [_score intValue] + addScore;
    _score = [NSNumber numberWithInt:newScore];
    _scoreLabel.text = [NSString stringWithFormat:@"%d", newScore];
}

-(void)addLetterToDraft:(SKNode *)node {
    [_draftWord addObject:node];
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    self.physicsWorld.gravity=CGPointMake(verticalAxis*10, -9.8);
}

@end
