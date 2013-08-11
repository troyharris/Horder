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

    }
    return self;
}

+(EndLevelBox *)endBoxWithPass:(BOOL)pass score:(int)score scoreNeeded:(int)scoreNeeded sceneWidth:(CGFloat)sceneWidth {
    EndLevelBox *elb = [[EndLevelBox alloc] initWithSize:CGSizeMake(sceneWidth / 2, sceneWidth / 2) sceneWidth:sceneWidth];
    if (pass == YES) {
        elb.passFail.text = @"PASS";
        elb.passFail.fontColor = [SKColor sunflowerColor];
    } else {
        elb.passFail.text = @"FAIL";
        elb.passFail.fontColor = [SKColor pomegranateColor];
    }
    return elb;
}

@end
