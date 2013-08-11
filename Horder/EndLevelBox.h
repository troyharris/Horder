//
//  EndLevelBox.h
//  Horder
//
//  Created by Troy HARRIS on 8/11/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EndLevelBox : SKSpriteNode

@property (nonatomic, strong) SKLabelNode *passFail;
@property (nonatomic, strong) SKLabelNode *score;
@property (nonatomic, strong) SKLabelNode *scoreNeeded;
@property (nonatomic, strong) SKLabelNode *okayButton;

-(id)initWithSize:(CGSize)size sceneWidth:(CGFloat)width;

+(EndLevelBox *)endBoxWithPass:(BOOL)pass score:(int)score scoreNeeded:(int)scoreNeeded sceneWidth:(CGFloat)sceneWidth;

@end
