//
//  LetterBox.h
//  Horder
//
//  Created by Troy HARRIS on 8/6/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface LetterBox : SKSpriteNode

@property (nonatomic, strong) SKLabelNode *letterNode;
@property (nonatomic, strong) SKColor *originalColor;
@property BOOL hasCollided;
@property BOOL bigBoxes;
@property BOOL explodingBoxes;
@property BOOL wildCard;

-(id)initWithSize:(CGSize)size;

+ (LetterBox *)letterBoxWithSize:(CGSize)size bigBoxes:(BOOL)big explodingBoxes:(BOOL)exploding wildCardBoxes:(BOOL)wildCard;

@end
