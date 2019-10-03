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

#pragma mark - convert

/// 转换成hex格式的string，方法本身没有检验data的字符是否在范围内
- (NSString*)fj_toHexString;

/// {[MSB], ..., ... ,[LSB]}, 方法本身没有检验data的字符是否在范围内
- (UInt32)fj_toUInt32;

- (int8_t)fj_toByte;





@end
