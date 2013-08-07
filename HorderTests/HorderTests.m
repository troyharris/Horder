//
//  HorderTests.m
//  HorderTests
//
//  Created by Troy HARRIS on 8/6/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LetterBox.h"
#import "WordsDatabase.h"

@interface HorderTests : XCTestCase

@end

@implementation HorderTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    LetterBox *box;
    NSMutableDictionary *letterCounts = [[NSMutableDictionary alloc] init];
    NSNumber *count;
    for (int i = 0; i < 10000; i++) {
        box = [[LetterBox alloc] initWithSize:CGSizeMake(64, 64)];
        count = (NSNumber *)[letterCounts objectForKey:box.letterNode.text];
        if (count == nil) {
            count = [NSNumber numberWithInt:0];
        }
        count = @([count intValue] + 1);
        [letterCounts setObject:count forKey:box.letterNode.text];
        //NSLog(@"Box Letter is: %@", box.letterNode.text);
        XCTAssertTrue([box.name isEqualToString:@"box"], @"Box is misnamed");
    }
    for (NSString *key in letterCounts) {
        int perc = ((11.0f - [(NSNumber *)[[WordsDatabase letterScores] objectForKey:key] floatValue]) / 212.0f) * 1000.0f;
        NSNumber *count = [letterCounts objectForKey:key];
        if ([count intValue] == 0) {
            XCTFail(@"Letter: %@ never appeared in 10000 tries", key);
        }
        if ([count intValue] < (perc * 8)) {
            XCTFail(@"Letter: %@ appeared %d times. Too little", key, [count intValue]);
        }
        if ([count intValue] > (perc * 12)) {
            XCTFail(@"Letter: %@ appeared %d times. Too many", key, [count intValue]);
        }
    }
    box = [[LetterBox alloc] initWithSize:CGSizeMake(64, 64)];
    NSLog(@"Box Letter is: %@", box.letterNode.text);
    XCTAssertTrue([box.name isEqualToString:@"box"], @"Box is misnamed");
}

@end
