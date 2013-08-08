//
//  GameScene.m
//  Horder
//
//  Created by Troy HARRIS on 8/7/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "GameScene.h"
#import "LetterBox.h"
#import "WordsDatabase.h"

@interface GameScene()
@property BOOL contentCreated;
@property (nonatomic, strong) NSMutableArray *draftWord;
@end

@implementation GameScene

-(void) didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents {
    srand([[NSDate date] timeIntervalSince1970]);
    _draftWord = [[NSMutableArray alloc] init];
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 1/30.0;
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^ (CMDeviceMotion *devMotion, NSError *error){
        CMAttitude *currentAttitude = devMotion.attitude;
        verticalAxis = currentAttitude.roll;
        lateralAxis = currentAttitude.pitch;
        longitudinalAxis = currentAttitude.yaw;
    }];
    self.scaleMode = SKSceneScaleModeAspectFit;
    /*
    SKSpriteNode *bottomBlur = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3] size:CGSizeMake(CGRectGetWidth(self.frame), 200)];
    bottomBlur.position = CGPointMake(CGRectGetMidX(self.frame), 100);
    CIFilter *gBlur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gBlur setValue:@50.0 forKey:@"inputRadius"];
    //[gBlur setDefaults];
    self.shouldEnableEffects = YES;
    SKEffectNode *gBlurBot = [[SKEffectNode alloc] init];
    gBlurBot.filter = gBlur;
    gBlurBot.shouldEnableEffects = YES;
    [gBlurBot addChild:bottomBlur];
    [self addChild:gBlurBot];
     */
    /*
    SKSpriteNode *bg = [[SKSpriteNode alloc] initWithImageNamed:@"treetest-ipadret"];
    bg.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:bg];
     */
    [self addWalls];
}

-(void)addWalls {
    CGFloat edge = CGRectGetWidth(self.frame) / 8;
    SKSpriteNode *floor = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(CGRectGetWidth(self.frame) - (edge * 2), 10)];
    floor.position = CGPointMake(CGRectGetMidX(self.frame), 205);
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    [self addChild:floor];
    
    SKSpriteNode *leftwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(10, CGRectGetHeight(self.frame) - 210)];
    leftwall.position = CGPointMake(edge + 5, CGRectGetMidY(self.frame) + 105);
    leftwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftwall.size];
    leftwall.physicsBody.dynamic = NO;
    [self addChild:leftwall];
    
    SKSpriteNode *rightwall = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(10, CGRectGetHeight(self.frame) - 210)];
    rightwall.position = CGPointMake(CGRectGetMaxX(self.frame) - (edge + 5), CGRectGetMidY(self.frame) + 105);
    rightwall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightwall.size];
    rightwall.physicsBody.dynamic = NO;
    [self addChild:rightwall];
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addBox
{
    LetterBox *box = [[LetterBox alloc] initWithSize:CGSizeMake(96,96)];
    box.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    //box.name = @"rock";
    //box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    //rock.physicsBody.usesPreciseCollisionDetection = YES;
    [self addChild:box];
 /*
    SKLabelNode *letterNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
    letterNode.fontSize = 44;
    //char randomLetter = [self getRandomChar];
    letterNode.text = [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'A'];
    letterNode.position = CGPointMake(0, 0);
    letterNode.name = @"letter";
    [rock addChild:letterNode];
  */
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSArray *nodes = [self nodesAtPoint:[touch locationInNode:self]];
    for (SKNode *node in nodes) {
        if ([node.name isEqualToString:@"box"]) {
            SKLabelNode *nodeLetter = (SKLabelNode *)[node childNodeWithName:@"letter"];
            NSLog(@"Clicked letter: %@", nodeLetter.text);
            [(SKSpriteNode *)node setColor:[UIColor blackColor]];
            [self addLetterToDraft:node];
            /*
             SKAction *zoom = [SKAction scaleBy:8 duration:0.2];
             SKAction *fade = [SKAction fadeOutWithDuration:0.2];
             SKAction *group = [SKAction group:@[zoom, fade]];
             SKAction *remove = [SKAction removeFromParent];
             SKAction *seq = [SKAction sequence:@[group, remove]];
             [node runAction:seq];
             */
        }
    }
    /*
     SKNode *explodeNode = [self childNodeWithName:@"rock"];
     if (explodeNode != nil) {
     SKAction *zoom = [SKAction scaleBy:8 duration:0.2];
     SKAction *fade = [SKAction fadeOutWithDuration:0.2];
     SKAction *group = [SKAction group:@[zoom, fade]];
     SKAction *remove = [SKAction removeFromParent];
     SKAction *seq = [SKAction sequence:@[group, remove]];
     [explodeNode runAction:seq];
     }
     */
}

-(void)addLetterToDraft:(SKNode *)node {
    [_draftWord addObject:node];
    if ([_draftWord count] > 3) {
        NSMutableArray *letters = [[NSMutableArray alloc] init];
        for (LetterBox *n in _draftWord) {
            //SKLabelNode *l = (SKLabelNode *)[n childNodeWithName:@"letter"];
            [letters addObject:n.letterNode.text];
        }
        NSString *theWord = [letters componentsJoinedByString:@""];
        NSLog(@"Word is: %@", theWord);
        if ([WordsDatabase isWord:theWord]) {
            int score = [WordsDatabase wordScore:theWord];
            NSLog(@"This is a valid word and the score is: %d", score);
            for (SKNode *b in _draftWord) {
                SKAction *zoom = [SKAction scaleBy:8 duration:0.2];
                SKAction *fade = [SKAction fadeOutWithDuration:0.2];
                SKAction *group = [SKAction group:@[zoom, fade]];
                SKAction *remove = [SKAction removeFromParent];
                SKAction *seq = [SKAction sequence:@[group, remove]];
                [b runAction:seq];
            }
        } else {
            NSLog(@"Invalid Word");
            for (LetterBox *n in _draftWord) {
                n.color = n.originalColor;
            }
        }
        [_draftWord removeAllObjects];
        
    }
}

-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"box" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}

-(void)update:(CFTimeInterval)currentTime {
    self.physicsWorld.gravity=CGPointMake(verticalAxis*10, -9.8);
}

@end
