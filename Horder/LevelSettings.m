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
        case 3:
            return [LevelSettings levelThree];
            break;
        case 4:
            return [LevelSettings levelFour];
            break;
        case 5:
            return [LevelSettings levelFive];
            break;
        case 6:
            return [LevelSettings levelSix];
            break;
        case 7:
            return [LevelSettings levelSeven];
            break;
        case 8:
            return [LevelSettings levelEight];
            break;
        case 9:
            return [LevelSettings levelNine];
            break;
        case 10:
            return [LevelSettings levelTen];
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
    ls.blackClock = YES;
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
    ls.maxTime = 120;
    ls.minLetters = 4;
    ls.minScore = 40;
    ls.darkHUD = YES;
    ls.explodingBoxes = NO;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    return ls;
}

+ (LevelSettings *)levelFive {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @5;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 150;
    ls.minLetters = 4;
    ls.minScore = 50;
    ls.explodingBoxes = NO;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelSix {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @6;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 3;
    ls.minScore = 50;
    ls.explodingBoxes = NO;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelSeven {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @7;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 90;
    ls.minLetters = 3;
    ls.minScore = 40;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelEight {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @8;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 4;
    ls.minScore = 50;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelNine {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @9;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 180;
    ls.minLetters = 4;
    ls.minScore = 75;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelTen {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @10;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 4;
    ls.minScore = 60;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

@end
