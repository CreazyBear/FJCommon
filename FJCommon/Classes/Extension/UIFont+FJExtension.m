//
//  UIFont+FJExtension.m
//  FJCommon
//
//  Created by 熊伟 on 2019/10/3.
//

#import "UIFont+FJExtension.h"

@implementation UIFont (FJExtension)

+(UIFont*) fj_pingFangFontOfSize:(CGFloat)fontSize {
    UIFont * font = [self fontWithName:@"PingFangSC-Regular" size:fontSize];
    if (font) {
        font = [self systemFontOfSize:fontSize];
    }
    return font;
}

+(UIFont*) fj_boldPingFangFontOfSize:(CGFloat)fontSize {
    UIFont * font = [self fontWithName:@"PingFangSC-Medium" size:fontSize];
    if (font) {
        font = [self systemFontOfSize:fontSize];
    }
    return font;
}


@end
