//
//  EndLevelBox.m
//  Horder
//
//  Created by Troy HARRIS on 8/11/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "EndLevelBox.h"
#import "UIColor+FlatUI.h"

@implementation EndLevelBox

-(id)initWithSize:(CGSize)size sceneWidth:(CGFloat)width {
    NSString *fontName = @"HelveticaNeue-UltraLight";
    UIColor *boxColor = [UIColor colorWithWhite:0 alpha:0.6];
    self = [super initWithColor:boxColor size:size];
    if (self) {
        self.name = @"end";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width, CGRectGetHeight(self.frame))];
        _passFail = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _passFail.fontSize = 50;
        _passFail.position = CGPointMake(CGRectGetMidX(self.frame), 100);
        [self addChild:_passFail];
        
        _score = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _score.fontSize = 30;
        _score.position = CGPointMake(CGRectGetMidX(self.frame), 50);
        _score.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:_score];
        
        _scoreNeeded = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _scoreNeeded.fontSize = 20;
        _scoreNeeded.position = CGPointMake(CGRectGetMidX(self.frame), 0);
        _scoreNeeded.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        [self addChild:_scoreNeeded];
        
        SKColor *buttonColor = [SKColor orangeColor];
        
        _okayButton = [[SKSpriteNode alloc] initWithColor:buttonColor size:CGSizeMake(size.width / 2, 75)];
        _okayButton.position = CGPointMake(CGRectGetMidX(self.frame), -100);
        _okayButton.name = @"beginButton";
        
        _okayText = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        _okayText.fontSize = 30;
        _okayText.text = @"Next >";
        _okayText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _okayText.position = CGPointMake(CGRectGetMidX(_okayText.frame), CGRectGetMidY(_okayText.frame));
        [_okayButton addChild:_okayText];
        [self addChild:_okayButton];

    }
    return self;
}

+(EndLevelBox *)endBoxWithPass:(BOOL)pass score:(int)score scoreNeeded:(int)scoreNeeded sceneWidth:(CGFloat)sceneWidth {
    EndLevelBox *elb = [[EndLevelBox alloc] initWithSize:CGSizeMake(sceneWidth / 2, sceneWidth / 2) sceneWidth:sceneWidth];
    if (pass == YES) {
        elb.passFail.text = @"PASS";
        elb.passFail.fontColor = [SKColor sunflowerColor];
        elb.okayText.text = @"Next >";
        elb.okayButton.name = @"nextButton";
    } else {
        elb.passFail.text = @"FAIL";
        elb.passFail.fontColor = [SKColor pomegranateColor];
        elb.okayText.text = @"Try Again";
        elb.okayButton.name = @"retryButton";
    }
    elb.score.text = [NSString stringWithFormat:@"Score: %d", score];
    elb.scoreNeeded.text = [NSString stringWithFormat:@"Score Needed: %d", scoreNeeded];
    return elb;
}

@end
