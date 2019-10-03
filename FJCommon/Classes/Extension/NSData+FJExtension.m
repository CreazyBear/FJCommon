//
//  NSData+FJExtension.m
//  FJHandlToolProject
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 熊伟. All rights reserved.
//

#import "NSData+FJExtension.h"

@implementation NSData (FJExtension)

+ (NSData *)fj_dataWithBase64EncodedString:(NSString *)string
{
    if (![string length]) return nil;
    
    NSData *decoded = nil;
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    
    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        NSString * convertStr = [string stringByReplacingOccurrencesOfString:@"[^A-Za-z0-9+/=]"
                                                                  withString:@""
                                                                     options:NSRegularExpressionSearch
                                                                       range:NSMakeRange(0, [string length])];
        decoded = [[NSData alloc] initWithBase64EncodedString:convertStr options:0];
    }
    else
        
#endif
        
    {
        decoded = [[self alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    return [decoded length]? decoded: nil;
}

- (NSString *)fj_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    if (![self length]) return nil;
    
    NSString *encoded = nil;
    
#if __MAC_OS_X_VERSION_MIN_REQUIRED < __MAC_10_9 || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    
    if (![NSData instancesRespondToSelector:@selector(base64EncodedStringWithOptions:)])
    {
        encoded = [self base64EncodedStringWithOptions:0];
    }
    else
        
#endif
        
    {
        switch (wrapWidth)
        {
            case 64:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            }
            case 76:
            {
                return [self base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
            }
            default:
            {
                encoded = [self base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0];
            }
        }
    }
    
    if (!wrapWidth || wrapWidth >= [encoded length])
    {
        return encoded;
    }
    
    wrapWidth = (wrapWidth / 4) * 4;
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < [encoded length]; i+= wrapWidth)
    {
        if (i + wrapWidth >= [encoded length])
        {
            [result appendString:[encoded substringFromIndex:i]];
            break;
        }
        [result appendString:[encoded substringWithRange:NSMakeRange(i, wrapWidth)]];
        [result appendString:@"\r\n"];
    }
    
    return result;
}

- (NSString *)fj_base64EncodedString
{
    return [self fj_base64EncodedStringWithWrapWidth:0];
}

- (NSString*)fj_toHexString {
    if (!self) {
        return @"";
    }
    Byte * dataByte = (Byte*)self.bytes;
    NSString * hexString = @"";
    for (int i = 0 ; i < self.length; i++) {
        NSString * newHexStr = [NSString stringWithFormat:@"%x",dataByte[i] & 0xff];
        if (newHexStr.length == 1) {
            hexString = [NSString stringWithFormat:@"%@0%@",hexString,newHexStr];
        }
        else {
            hexString = [NSString stringWithFormat:@"%@%@",hexString,newHexStr];
        }
    }
    return hexString;
}

- (UInt32)fj_toUInt32 {
    if (!self || self.length == 0) {
        return 0;
    }
    Byte * dataByte = (Byte*)self.bytes;
    UInt32 convertLong = 0;
    for (int num = 0; num < self.length; num++) {
        convertLong = convertLong | dataByte[num]<<(8*(self.length-1-num));
    }
    return convertLong;
}

- (int8_t)fj_toByte {
    if (self == nil) {
        return 0;
    }
    char val[self.length];
    [self getBytes:&val length:self.length];
    int8_t result = val[0];
    return result;
}

@end
