//
//  HORSong.h
//  Horder
//
//  Created by Troy HARRIS on 8/30/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HORSong : NSObject

@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *extension;

+ (HORSong *)randomSong;

@end
