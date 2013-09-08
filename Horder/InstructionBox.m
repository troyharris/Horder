//
//  InstructionBox.m
//  Horder
//
//  Created by Troy HARRIS on 8/11/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "InstructionBox.h"
#import "UIColor+FlatUI.h"

@implementation InstructionBox

-(id)initWithSize:(CGSize)size sceneWidth:(CGFloat)width {
    NSString *fontName = @"HelveticaNeue-UltraLight";
    //CGFloat rowHeight = size.height / 8;
    UIColor *boxColor = [UIColor colorWithWhite:0 alpha:0.6];
    self = [super initWithColor:boxColor size:size];
    if (self) {
        self.name = @"instructions";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(width, CGRectGetHeight(self.frame))];
        _instructions = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _instructions.fontSize = 24;
        _instructions.position = CGPointMake(CGRectGetMidX(self.frame), 100);
        _instructions.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        [self addChild:_instructions];
        
        _instructTime = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _instructTime.fontSize = 24;
        _instructTime.position = CGPointMake(CGRectGetMidX(self.frame), 50);
        _instructions.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:_instructTime];
        
        _wordLength = [[SKLabelNode alloc] initWithFontNamed:fontName];
        _wordLength.fontSize = 20;
        _wordLength.position = CGPointMake(CGRectGetMidX(self.frame), 0);
        _instructions.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
        [self addChild:_wordLength];
        
        SKColor *buttonColor = [SKColor orangeColor];
        
        _okayButton = [[SKSpriteNode alloc] initWithColor:buttonColor size:CGSizeMake(size.width / 2, 75)];
        _okayButton.position = CGPointMake(CGRectGetMidX(self.frame), -100);
        _okayButton.name = @"beginButton";
        
        SKLabelNode *okayText = [[SKLabelNode alloc] initWithFontNamed:@"HelveticaNeue-UltraLight"];
        okayText.fontSize = 30;
        okayText.text = @"Begin";
        okayText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        okayText.position = CGPointMake(CGRectGetMidX(okayText.frame), CGRectGetMidY(okayText.frame));
        [_okayButton addChild:okayText];
        [self addChild:_okayButton];
    }
    return self;
}

@end
