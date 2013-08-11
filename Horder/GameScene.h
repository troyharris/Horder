//
//  GameScene.h
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    float verticalAxis, lateralAxis, longitudinalAxis;
}

@property (nonatomic, strong) CMMotionManager *motionManager;



@end
