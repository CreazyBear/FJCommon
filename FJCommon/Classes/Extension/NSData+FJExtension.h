//
//  NSData+FJExtension.h
//  FJHandlToolProject
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 熊伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (FJExtension)

+ (NSData *)fj_dataWithBase64EncodedString:(NSString *)string;
- (NSString *)fj_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)fj_base64EncodedString;

- (BOOL)fj_isGIF;

+ (NSString *)fj_contentTypeForImageData:(NSData *)data __deprecated_msg("Use `sd_contentTypeForImageData:`");



@end
