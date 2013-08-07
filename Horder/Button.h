//
//  Button.h
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Button : SKSpriteNode

@property (nonatomic, strong) SKLabelNode *buttonTitle;

-(id)initWithSize:(CGSize)size;

@end
