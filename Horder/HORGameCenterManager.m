//
//  HORGameCenterManager.m
//  Horder
//
//  Created by Troy HARRIS on 9/4/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "HORGameCenterManager.h"
#import <GameKit/GameKit.h>

@interface HORGameCenterManager ()

@property BOOL gameCenterAvailable;

@end

@implementation HORGameCenterManager

- (id)init {
    if ((self = [super init])) {
        self.gameCenterAvailable = [self checkGameCenterAvailability];
        if (self.gameCenterAvailable) {
            NSNotificationCenter *nc =
            [NSNotificationCenter defaultCenter];
            [nc addObserver:self
                   selector:@selector(authenticationChanged)
                       name:GKPlayerAuthenticationDidChangeNotificationName
                     object:nil];
        }
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)checkGameCenterAvailability {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !self.isUserAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        self.userAuthenticated = TRUE;
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && self.isUserAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        self.userAuthenticated = FALSE;
    }
}

- (void)authenticateUser {
    if (!self.isGameCenterAvailable) return;
    
    NSLog(@"Authenticating local user...");
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:(^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController];
        } else if (localPlayer.authenticated) {
            self.userAuthenticated = YES;
        } else {
            self.userAuthenticated = NO;
        }
    })];
}

+ (void)updateScore:(NSInteger)score {
    GKScore *globalScore = [[GKScore alloc] initWithLeaderboardIdentifier:@"HorderTopScore"];
    globalScore.value = score;
    [GKScore reportScores:@[globalScore] withCompletionHandler:nil];
}

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

@end
