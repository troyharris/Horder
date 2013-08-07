//
//  THUtil.h
//  Paperback Writer
//
//  Created by Troy HARRIS on 5/24/13.
//  Copyright (c) 2013 Lone Yeti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THUtil : NSObject

+(CGFloat)getRealDeviceWidth;
+(CGFloat)getRealDeviceHeight;
+(UIInterfaceOrientation)orientation;
+(CGFloat)getViewBottomOrigin:(UIView *)view;
+(CGPoint)getViewRealCenter:(UIView *)view;
+(UIColor *)getRandomColor:(NSArray *)colors;
+(CGFloat)getFontSizeFromIPadFontSize:(CGFloat)fontSize;
+(CGFloat)getFontSizeFromIPhoneFontSize:(CGFloat)fontSize;

@end
