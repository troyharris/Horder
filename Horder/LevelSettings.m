//
//  LevelSettings.m
//  Horder
//
//  Created by Troy HARRIS on 8/13/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "LevelSettings.h"

@implementation LevelSettings

+ (NSString *)levelBackgroundNameWithNumber:(NSNumber *)levelNumber {
    return [NSString stringWithFormat:@"ipad-lvl%d", [levelNumber intValue]];
}

+ (LevelSettings *)levelWithNumber:(NSNumber *)levelNumber {
    switch ([levelNumber intValue]) {
        case 1:
            return [LevelSettings levelOne];
            break;
        case 2:
            return [LevelSettings levelTwo];
            break;
        default:
            return [LevelSettings levelOne];
            break;
    }
    return [LevelSettings levelOne];
}

+ (LevelSettings *)levelOne {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @1;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 3;
    ls.minScore = 30;
    ls.explodingBoxes = NO;
    ls.wideBoxes = NO;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    return ls;
}

+ (LevelSettings *)levelTwo {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @2;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 3;
    ls.minScore = 40;
    ls.explodingBoxes = NO;
    ls.wideBoxes = NO;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    return ls;
}

+ (LevelSettings *)levelThree {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @3;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 4;
    ls.minScore = 30;
    ls.explodingBoxes = NO;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    return ls;
}

+ (LevelSettings *)levelFour {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @4;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 150;
    ls.minLetters = 4;
    ls.minScore = 50;
    ls.explodingBoxes = NO;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    return ls;
}

@end
