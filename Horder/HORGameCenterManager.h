//
//  HORGameCenterManager.h
//  Horder
//
//  Created by Troy HARRIS on 9/4/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HORGameCenterManager : NSObject

@property (readonly, getter = isGameCenterAvailable) BOOL gameCenterAvailable;
@property (getter = isUserAuthenticated) BOOL userAuthenticated;

+ (instancetype)sharedInstance;
- (void)authenticateUser;

@end
