//
//  WordsDatabase.m
//  HelloSprite
//
//  Created by Troy HARRIS on 8/5/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "WordsDatabase.h"

@implementation WordsDatabase

+(BOOL)isWord:(NSString *)word {
    NSString *wordWithWild = [word stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"words"
                                                         ofType:@"sqlite3"];
    sqlite3 *database;
    
    if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    }
    
    int goodID = -1;
    NSString *select = [NSString stringWithFormat:@"SELECT id FROM words WHERE word LIKE '%@'", wordWithWild];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [select UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            goodID = (int)sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    return goodID > 0 ? YES : NO;
}

+(int)wordScore:(NSString *)word {
    int score = 0;
    for (int i=0; i < [word length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
        NSNumber *letterScore = (NSNumber *)[[self letterScores] objectForKey:ichar];
        score = score + [letterScore intValue];
    }
    return score;
}

+(void)testDatabase {
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"words"
                                                         ofType:@"sqlite3"];
    sqlite3 *database;
    
    if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK) {
        NSLog(@"Failed to open database!");
    }
    
    NSString *select = @"SELECT * FROM words WHERE id IN (1, 2, 3)";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [select UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *word = (char *)sqlite3_column_text(statement, 1);
            NSLog(@"Word is: %@", [NSString stringWithUTF8String:word]);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);

}

+(NSDictionary *)letterScores {
    return @{
             @"A": @1,
             @"B": @3,
             @"C": @2,
             @"D": @2,
             @"E": @1,
             @"F": @3,
             @"G": @3,
             @"H": @2,
             @"I": @1,
             @"J": @6,
             @"K": @4,
             @"L": @2,
             @"M": @2,
             @"N": @1,
             @"O": @1,
             @"A": @1,
             @"B": @3,
             @"C": @2,
             @"P": @2,
             @"Q": @10,
             @"R": @1,
             @"S": @1,
             @"T": @1,
             @"U": @2,
             @"V": @5,
             @"W": @4,
             @"X": @5,
             @"Y": @3,
             @"Z": @6,
             @"_": @0,
             @" ": @0,
             @"*": @0
             };
}

@end
