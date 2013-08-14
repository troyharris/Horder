//
//  GameScene.h
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "LevelSettings.h"
#import <AVFoundation/AVFoundation.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) LevelSettings *settings;

+(GameScene *)sceneWithLevelSetup:(LevelSettings *)levelSettings size:(CGSize)size;





@end
