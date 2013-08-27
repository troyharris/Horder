//
//  LetterBox.m
//  Horder
//
//  Created by Troy HARRIS on 8/6/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "LetterBox.h"
#import "UIColor+FlatUI.h"
#import "WordsDatabase.h"

@implementation LetterBox

-(id)initWithSize:(CGSize)size {
    UIColor *boxColor = [self getRandomColor];
    self = [super initWithColor:boxColor size:size];
    if (self) {
        self.name = @"box";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.originalColor = boxColor;
        self.hasCollided = NO;
        _letterNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
        _letterNode.fontSize = size.height / 2;
        _letterNode.text = [self getRandomLetter];
        _letterNode.position = CGPointMake(0, 0);
        _letterNode.name = @"letter";
        [self addChild:_letterNode];
    }
    return self;
}

static inline CGFloat skArcRandi(NSInteger low, NSInteger high) {
    int interval = high - low;
    return (arc4random() % interval) + low;
}

static inline BOOL skSpecialRoll() {
    CGFloat roll = skArcRandi(1, 100);
    if (roll > 90) {
        return YES;
    }
    return NO;
}

-(UIColor *)getRandomColor {
#warning CLEANUP - Move colorArr function somewhere else to support reuse.
    NSArray *colorArr = @[
                          [UIColor emerlandColor],
                          [UIColor turquoiseColor],
                          [UIColor carrotColor],
                          //[UIColor midnightBlueColor],
                          [UIColor pomegranateColor],
                          [UIColor orangeColor],
                          [UIColor greenSeaColor],
                          [UIColor peterRiverColor],
                          [UIColor belizeHoleColor],
                          [UIColor nephritisColor],
                          [UIColor wisteriaColor],
                          [UIColor amethystColor],
                          [UIColor asbestosColor],
                          [UIColor concreteColor],
                          [UIColor wetAsphaltColor],
                          [UIColor alizarinColor],
                          [UIColor sunflowerColor],
                          [UIColor pumpkinColor]
                          ];
    //return (UIColor *)[colorArr objectAtIndex:skArcRandi(0, (colorArr.count - 1))];
    return (UIColor *)[colorArr objectAtIndex:arc4random_uniform([colorArr count])];
}

-(NSArray *)getAlphabet {
    NSMutableArray *alphaCaps = [[NSMutableArray alloc] init];
    for(char a = 'A'; a <= 'Z'; a++)
    {
        [alphaCaps addObject:[NSString stringWithFormat:@"%c", a]];
    }
    return alphaCaps;
}

-(NSString *)getRandomLetter {
    int base = 11;
    NSMutableArray *weightedLetters = [[NSMutableArray alloc] init];
    NSDictionary *letterScores = [WordsDatabase letterScores];
    int times;
    for (NSString *letter in [self getAlphabet]) {
        NSNumber *score = letterScores[letter];
        times = base - [score intValue];
        for (int i = 0; i < times; i++) {
            [weightedLetters addObject:letter];
        }
    }
    [weightedLetters addObjectsFromArray:@[@"A", @"E", @"I", @"O", @"U"]];
    //NSLog(@"Weighted Letters are: %d", [weightedLetters count]);
    //return (NSString *)[weightedLetters objectAtIndex:skArcRandi(0, (weightedLetters.count - 1))];
    return (NSString *)[weightedLetters objectAtIndex:arc4random_uniform([weightedLetters count])];
}

-(void)hitByExploder {
    // Boy is this embarassingly ugly code. Fix!
    SKAction *blinkOn = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0 duration:0.25];
    SKAction *blinkOff = [SKAction colorizeWithColor:self.originalColor colorBlendFactor:1.0 duration:0.25];
    SKAction *blinkOnQuick = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0 duration:0.125];
    SKAction *blinkOffQuick = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0 duration:0.125];
    SKAction *zoom = [SKAction scaleBy:8 duration:0.2];
    SKAction *fade = [SKAction fadeOutWithDuration:0.2];
    SKAction *group = [SKAction group:@[zoom, fade]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *seq = [SKAction sequence:@[blinkOn, blinkOff, blinkOnQuick, blinkOffQuick, group, remove]];
    [self runAction:seq completion:^(void){
        [self.delegate removedLetterBoxFromParent:self];
    }];
}

+ (LetterBox *)letterBoxWithSize:(CGSize)size bigBoxes:(BOOL)big explodingBoxes:(BOOL)exploding wildCardBoxes:(BOOL)wildCard {
    if (big) {
        if (skSpecialRoll()) {
            size.width = size.width * 2;
        }
    }
    LetterBox *box = [[LetterBox alloc] initWithSize:size];
    if (wildCard) {
        if (skSpecialRoll()) {
            box.letterNode.text = @"_";
            return box;
        }
    } if (exploding) {
        if (skSpecialRoll()) {
            box.letterNode.text = @"*";
        }
    }
    return box;
}

@end
