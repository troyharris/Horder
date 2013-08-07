//
//  Button.m
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "Button.h"
#import "UIColor+FlatUI.h"
#import <QuartzCore/QuartzCore.h>

@implementation Button

-(id)initWithSize:(CGSize)size {
    //UIColor *boxColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIColor *boxColor = [UIColor sunflowerColor];
    self = [super initWithColor:boxColor size:size];
    if (self) {
//        CGSize buttonSize = CGSizeMake(CGRectGetWidth(self.frame) * 0.8, 100);
//        SKSpriteNode *mainButton = [[SKSpriteNode alloc] initWithColor:[UIColor sunflowerColor] size:size];
//        mainButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.name = @"button";
//        mainButton.name = @"buttonInner";
        
        _buttonTitle = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        _buttonTitle.fontSize = 64;
        _buttonTitle.fontColor = [UIColor whiteColor];
        _buttonTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _buttonTitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:_buttonTitle];
//        [self addChild:mainButton];
        
        //self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        /*
        _letterNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
        _letterNode.fontSize = 44;
        _letterNode.text = [self getRandomLetter];
        _letterNode.position = CGPointMake(0, 0);
        _letterNode.name = @"letter";
        [self addChild:_letterNode];
         */
    }
    return self;
}


@end
