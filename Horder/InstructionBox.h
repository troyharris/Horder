//
//  InstructionBox.h
//  Horder
//
//  Created by Troy HARRIS on 8/11/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface InstructionBox : SKSpriteNode

@property (nonatomic, strong) SKLabelNode *instructions;
@property (nonatomic, strong) SKLabelNode *instructTime;
@property (nonatomic, strong) SKLabelNode *wordLength;
@property (nonatomic, strong) SKSpriteNode *okayButton;

-(id)initWithSize:(CGSize)size sceneWidth:(CGFloat)width;

@end
