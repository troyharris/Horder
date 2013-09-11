//
//  MainMenuScene.h
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>
#import "Button.h"

@interface MainMenuScene : SKScene <AVAudioPlayerDelegate> {
    float verticalAxis, lateralAxis, longitudinalAxis;
}

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) SKSpriteNode *anchor;
@property (nonatomic, strong) Button *startButton;



@end
