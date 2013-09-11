//
//  HORSong.m
//  Horder
//
//  Created by Troy HARRIS on 8/30/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "HORSong.h"

@implementation HORSong

+ (HORSong *)songFromFilename:(NSString *)filename extension:(NSString *)extension {
    HORSong *song = [[HORSong alloc] init];
    song.filename = filename;
    song.extension = extension;
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    song.url = [NSURL URLWithString:musicPath];
    return song;
}

+ (NSArray *)arrayOfSongs {
    return @[[HORSong songFromFilename:@"mygrimeydreams-horder" extension:@"m4a"],
             [HORSong songFromFilename:@"longtooth-horder" extension:@"m4a"],
             [HORSong songFromFilename:@"bitsandgods-horder" extension:@"mp3"],
             [HORSong songFromFilename:@"twilight-horder" extension:@"m4a"],
             [HORSong songFromFilename:@"animous-horder" extension:@"mp3"],
             [HORSong songFromFilename:@"mirage-horder" extension:@"mp3"]
             ];
}

+ (HORSong *)randomSong {
    NSArray *songs = [HORSong arrayOfSongs];
    return (HORSong *)[songs objectAtIndex:arc4random_uniform([songs count])];
}

+ (HORSong *)successSong {
    return [HORSong songFromFilename:@"scenery-horder-atlantis" extension:@"mp3"];
}

+ (HORSong *)themeSong {
    return [HORSong songFromFilename:@"scenery-horder-myk" extension:@"mp3"];
}

+ (HORSong *)failSong {
    return [HORSong songFromFilename:@"scenery-horder-orbit" extension:@"mp3"];
}

@end
