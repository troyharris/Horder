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
            return [LevelSettings levelThirteen];
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
        case 11:
            return [LevelSettings levelEleven];
            break;
        case 12:
            return [LevelSettings levelTwelve];
            break;
        case 13:
            return [LevelSettings levelThirteen];
            break;
        case 14:
            return [LevelSettings levelFourteen];
            break;
        case 15:
            return [LevelSettings levelFifteen];
            break;
        case 16:
            return [LevelSettings levelSixteen];
            break;
        default:
            return [LevelSettings levelSixteen];
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
    ls.moonGravity = YES;
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
    ls.darkHUD = YES;
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 4;
    ls.minScore = 60;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = YES;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelEleven {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @11;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 3;
    ls.minScore = 70;
    ls.explodingBoxes = YES;
    ls.wideBoxes = NO;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelTwelve {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @12;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 180;
    ls.minLetters = 3;
    ls.minScore = 100;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelThirteen {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @13;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.darkHUD = YES;
    ls.hinderSprites = nil;
    ls.maxTime = 150;
    ls.minLetters = 3;
    ls.minScore = 100;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = YES;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelFourteen {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @14;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 3;
    ls.minScore = 80;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelFifteen {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @15;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 240;
    ls.minLetters = 4;
    ls.minScore = 250;
    ls.explodingBoxes = YES;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = YES;
    return ls;
}

+ (LevelSettings *)levelSixteen {
    LevelSettings *ls = [[LevelSettings alloc] init];
    ls.levelNumber = @16;
    ls.backgroundName = [LevelSettings levelBackgroundNameWithNumber:ls.levelNumber];
    ls.hinderSprites = nil;
    ls.maxTime = 0;
    ls.minLetters = 3;
    ls.minScore = 0;
    ls.explodingBoxes = NO;
    ls.wideBoxes = YES;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    ls.finalLevel = YES;
    return ls;
}

@end
