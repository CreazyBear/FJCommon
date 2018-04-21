//
//  UIColor+FJExtension.m
//  FJHandlToolProject
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 熊伟. All rights reserved.
//

#import "UIColor+FJExtension.h"

#define GREY(color) [UIColor colorWithRed:color/255.0 green:color/255.0 blue:color/255.0 alpha:1]

@implementation UIColor (FJExtension)


+ (id)fj_colorWithHex:(unsigned int)hex{
    return [UIColor fj_colorWithHex:hex alpha:1];
}

+ (id)fj_colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha{
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor*)fj_randomColor{
    
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    
}

+ (UIColor *)fj_colorwithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&hex];
    return [UIColor fj_colorWithHex:hex alpha:alpha];
}

/**
 根据16进制数设置颜色
 
 @param hex 16进制数，rgba
 @return uicolor
 */
+ (UIColor *)fj_colorWithHex:(unsigned int)hex withType:(int)hexType{
    
    if (hexType == 8) {
        return [UIColor colorWithRed:((float)((hex & 0xFF000000) >> 24)) / 255.0
                               green:((float)((hex & 0xFF0000) >> 16)) / 255.0
                                blue:((float)((hex & 0xFF00) >> 8)) / 255.0
                               alpha:(float)(hex & 0xFF) / 255.0];
        
    }
    else{
        return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                               green:((float)((hex & 0xFF00) >> 8)) / 255.0
                                blue:((float)(hex & 0xFF)) / 255.0
                               alpha:1];
    }
    
    
}

/**
 根据16进制字符串设置颜色
 
 @param hexString "#rgba"
 @return uicolor
 */
+ (UIColor *)fj_colorWithHexString:(NSString *)hexString
{
    if (hexString.length == 0) {
        return [UIColor blackColor];
    }
    unsigned int hex = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&hex];
    return [UIColor fj_colorWithHex:hex withType:(int)(hexString.length-1)];
}



@end
