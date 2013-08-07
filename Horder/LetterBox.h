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

-(id)initWithSize:(CGSize)size;

@end
