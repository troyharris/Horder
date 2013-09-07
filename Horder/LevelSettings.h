//
//  LevelSettings.h
//  Horder
//
//  Created by Troy HARRIS on 8/13/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelSettings : NSObject

@property (nonatomic, strong) NSNumber *levelNumber;
@property (nonatomic, strong) NSArray *hinderSprites;
@property (nonatomic, strong) NSString *backgroundName;
@property (nonatomic) int maxTime;
@property (nonatomic) int minScore;
@property (nonatomic) int minLetters;
@property (nonatomic) BOOL blackClock;
@property (nonatomic) BOOL explodingBoxes;
@property (nonatomic) BOOL wideBoxes;
@property (nonatomic) BOOL moonGravity;
@property (nonatomic) BOOL wildCard;

+ (LevelSettings *)levelWithNumber:(NSNumber *)levelNumber;

+ (LevelSettings *)levelOne;


@end
