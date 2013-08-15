//
//  LevelSettings.m
//  Horder
//
//  Created by Troy HARRIS on 8/13/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "LevelSettings.h"

@implementation LevelSettings

+ (LevelSettings *)levelWithNumber:(NSNumber *)levelNumber {
    switch ([levelNumber intValue]) {
        case 1:
            return [LevelSettings levelOne];
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
    ls.backgroundName = @"bokehtest";
    ls.hinderSprites = nil;
    ls.maxTime = 120;
    ls.minLetters = 3;
    ls.minScore = 50;
    ls.explodingBoxes = NO;
    ls.wideBoxes = NO;
    ls.moonGravity = NO;
    ls.wildCard = NO;
    return ls;
}

@end
