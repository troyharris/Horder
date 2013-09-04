//
//  GlobalScore.h
//  Horder
//
//  Created by Troy HARRIS on 9/3/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalScore : NSObject

@property (nonatomic, strong) NSNumber *currentScore;
@property (nonatomic, strong) NSNumber *bestScore;

+ (instancetype)sharedScore;

@end
