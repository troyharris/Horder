//
//  MainMenuScene.m
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "MainMenuScene.h"
#import "UIColor+FlatUI.h"
#import "LetterBox.h"
#import <CoreImage/CoreImage.h>
#import "GameScene.h"
#import "LevelSettings.h"
#import "HORSong.h"

@interface MainMenuScene ()
@property BOOL contentCreated;
@property (nonatomic, strong) AVAudioPlayer *themePlayer;
@end

@implementation MainMenuScene

-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
    NSLog(@"Screen Width is %f and Height is %f", self.frame.size.width, self.frame.size.height);
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1/30.0;
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error){
        CMAttitude *currentAttitude = devMotion.attitude;
        verticalAxis = currentAttitude.roll;
        lateralAxis = currentAttitude.pitch;
        longitudinalAxis = currentAttitude.yaw;
    }];
    self.scaleMode = SKSceneScaleModeAspectFit;
    [self playTheme];
    [self createBackground];
    [self createAnchor];
    [self createLogo];
    [self createButton];
}

- (void)playTheme {
    HORSong *themeSong = [HORSong themeSong];
    self.themePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:themeSong.url error:nil];
    self.themePlayer.delegate = self;
    [self.themePlayer prepareToPlay];
    [self.themePlayer play];
}

-(void)createBackground {
    SKSpriteNode *background = [[SKSpriteNode alloc] initWithImageNamed:@"treetest-ipad-preblur"];
    background.size = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
}

-(void)createButton {
    _startButton = [[Button alloc] initWithSize:CGSizeMake(CGRectGetWidth(self.frame), 100)];
    _startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(_startButton.frame));
    _startButton.buttonTitle.text = @"Start Game";
    [self addChild:_startButton];
}

-(void)createLogo {
    CGFloat margin = 10;
    NSArray *name = @[@"H", @"O", @"R", @"D", @"E", @"R"];
    CGFloat boxWidth = (CGRectGetWidth(self.frame) / [name count]) - margin;
    CGSize boxSize = CGSizeMake(boxWidth, boxWidth);
    CGFloat xOffSet = (boxWidth / 2) + margin;
    CGFloat maxLength = 20;
    LetterBox *lastLb;
    for (NSString *l in name) {
        SKNode *previous;
        LetterBox *lb = [[LetterBox alloc] initWithSize:boxSize];
        if (!lastLb) {
            NSLog(@"No anchor");
            previous = _anchor;
        } else {
            previous = lastLb;
        }
        lb.letterNode.text = l;
        lb.position = CGPointMake(xOffSet, CGRectGetMinY(self.frame) + (boxWidth / 2));
        xOffSet = xOffSet + boxWidth + margin;
        [self addChild:lb];
        SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:_anchor.physicsBody bodyB:lb.physicsBody anchorA:CGPointMake(CGRectGetMidX(_anchor.frame), CGRectGetMidY(_anchor.frame)) anchorB:CGPointMake(CGRectGetMidY(lb.frame), CGRectGetMidY(lb.frame))];
        joint.maxLength = maxLength;
        [self.physicsWorld addJoint:joint];
        lastLb = lb;
        margin = margin + boxWidth + 5;
        maxLength = maxLength + boxWidth;
    }
}

-(void)createAnchor {
    _anchor = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(8, 8)];
    _anchor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame));
    _anchor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_anchor.size];
    _anchor.physicsBody.dynamic = NO;
    [self addChild:_anchor];
}

-(void)update:(CFTimeInterval)currentTime {
    
    self.physicsWorld.gravity=CGVectorMake(verticalAxis*2, -9.8);
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"button"]) {
            LevelSettings *settings = [LevelSettings levelWithNumber:@1];
            SKScene *game = [GameScene sceneWithLevelSetup:settings size:self.size];
            CIFilter *blurTrans = [CIFilter filterWithName:@"CIModTransition"];
            [blurTrans setDefaults];
            self.shouldEnableEffects = YES;
            SKTransition *trans = [SKTransition transitionWithCIFilter:blurTrans duration:1.0];
            [self.themePlayer stop];
            [self.view presentScene:game transition:trans];
        }
    }
}

@end
