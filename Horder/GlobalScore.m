//
//  GlobalScore.m
//  Horder
//
//  Created by Troy HARRIS on 9/3/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "GlobalScore.h"

@implementation GlobalScore

+ (instancetype)sharedScore {
    static id sharedScore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedScore = [[self alloc] init];
    });
    
    return sharedScore;
}

@end
