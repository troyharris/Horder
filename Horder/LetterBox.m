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
        _letterNode = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-UltraLight"];
        _letterNode.fontSize = 44;
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
    return (UIColor *)[colorArr objectAtIndex:skArcRandi(0, (colorArr.count - 1))];
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
    //NSLog(@"Weighted Letters are: %d", [weightedLetters count]);
    return (NSString *)[weightedLetters objectAtIndex:skArcRandi(0, (weightedLetters.count - 1))];
}

@end
