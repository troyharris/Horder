//
//  RootViewController.m
//  Horder
//
//  Created by Troy HARRIS on 8/6/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import "RootViewController.h"
#import "THUtil.h"
#import "MainMenuScene.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _spriteView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, [THUtil getRealDeviceWidth], [THUtil getRealDeviceHeight])];
        _spriteView.showsNodeCount = YES;
        _spriteView.showsDrawCount = YES;
        _spriteView.showsFPS = YES;
        self.view = _spriteView;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    MainMenuScene *menuScene = [[MainMenuScene alloc] initWithSize:CGSizeMake([THUtil getRealDeviceWidth], [THUtil getRealDeviceHeight])];
    [_spriteView presentScene:menuScene];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
