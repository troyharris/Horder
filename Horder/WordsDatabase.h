//
//  WordsDatabase.h
//  HelloSprite
//
//  Created by Troy HARRIS on 8/5/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface WordsDatabase : NSObject

+(void)testDatabase;

+(BOOL)isWord:(NSString *)word;
+(int)wordScore:(NSString *)word;
+(NSDictionary *)letterScores;

@end
