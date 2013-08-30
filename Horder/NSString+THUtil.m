//
//  NSString+THUtil.m
//  Horder
//
//  Created by Troy HARRIS on 8/14/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "NSString+THUtil.h"

@implementation NSString (THUtil)

+ (NSString *)numberToWord:(int)number {
    NSDictionary *baseNumbers = @{
                                  @1:@"one",
                                  @2:@"two",
                                  @3:@"three",
                                  @4:@"four",
                                  @5:@"five",
                                  @6:@"six",
                                  @7:@"seven",
                                  @8:@"eight",
                                  @9:@"nine"
                                  };
    NSDictionary *specialNumbers = @{
                                     @0:@"zero",
                                     @10:@"ten",
                                     @11:@"eleven",
                                     @12:@"twelve",
                                     @13:@"thirteen",
                                     @14:@"fourteen",
                                     @15:@"fifteen",
                                     @16:@"sixteen",
                                     @17:@"seventeen",
                                     @18:@"eighteen",
                                     @19:@"nineteen"
                                     };
    NSDictionary *tenNumbers = @{
                                 @2:@"twenty",
                                 @3:@"thirty",
                                 @4:@"fourty",
                                 @5:@"fifty",
                                 @6:@"sixty",
                                 @7:@"seventy",
                                 @8:@"eighty",
                                 @9:@"ninety"
                                 };
    /*
    NSDictionary *powerNumbers = @{
                                   @1:@"hundred",
                                   @2:@"thousand"
                                   };
     */
    NSNumber *numObject = [NSNumber numberWithInt:number];
    
    NSString *baseString = (NSString *)[baseNumbers objectForKey:numObject];
    
    if (baseString) {
        return baseString;
    }
    
    baseString = (NSString *)[specialNumbers objectForKey:numObject];
    if (baseString) {
        return baseString;
    }
    
    CGFloat powerFloat = number / 10;
    
    if (powerFloat >= 2) {
        int power = (int)floor(powerFloat);
        int rem = number - (power * 10);
        NSString *powerString = (NSString *)[tenNumbers objectForKey:@(power)];
        if (rem > 0) {
            NSString *smallString = (NSString *)[baseNumbers objectForKey:@(rem)];
            powerString = [NSString stringWithFormat:@"%@-%@", powerString, smallString];
        }
        return powerString;
    }
    
    return nil;
}

+ (NSString *)secondsToString:(int)seconds {
    int minutes = seconds / 60;
    int remainingSeconds = seconds % 60;
    NSString *plural = minutes > 1 ? @"s" : @"";
    NSString *minuteString = @"";
    NSString *secondsString = @"";
    NSString *andString = @"";
    if (minutes > 0) {
        minuteString = [NSString stringWithFormat:@"%@ minute%@", [NSString numberToWord:minutes], plural];
    }
    if (remainingSeconds > 0) {
        secondsString = [NSString stringWithFormat:@"%@ seconds", [NSString numberToWord:remainingSeconds]];
    }
    if (minutes > 0 && remainingSeconds > 0) {
        andString = @" and ";
    }
    return [NSString stringWithFormat:@"%@%@%@", minuteString, andString, secondsString];
}

@end
