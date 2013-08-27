//
//  GameScene.h
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "LetterBox.h"

@class LevelSettings;

@interface GameScene : SKScene <SKPhysicsContactDelegate, AVAudioPlayerDelegate, LetterBoxDelegate>

@property (nonatomic, strong) LevelSettings *settings;

+(GameScene *)sceneWithLevelSetup:(LevelSettings *)levelSettings size:(CGSize)size;





@end
