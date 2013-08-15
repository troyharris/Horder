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

@interface MainMenuScene ()
@property BOOL contentCreated;
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
    [self createBackground];
    [self createAnchor];
    [self createLogo];
    [self createButton];
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
    for (NSString *l in name) {
        LetterBox *lb = [[LetterBox alloc] initWithSize:boxSize];
        lb.letterNode.text = l;
        lb.position = CGPointMake(xOffSet, CGRectGetMidY(self.frame) + boxWidth);
        xOffSet = xOffSet + boxWidth + margin;
        [self addChild:lb];
        SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:_anchor.physicsBody bodyB:lb.physicsBody anchorA:CGPointMake(CGRectGetMidX(_anchor.frame), CGRectGetMidY(_anchor.frame)) anchorB:CGPointMake(CGRectGetMidY(lb.frame), CGRectGetMidY(lb.frame))];
        joint.maxLength = 50;
        [self.physicsWorld addJoint:joint];
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
    
    self.physicsWorld.gravity=CGPointMake(verticalAxis*2, -9.8);
    
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
            [self.view presentScene:game transition:trans];
        }
    }
}

@end
