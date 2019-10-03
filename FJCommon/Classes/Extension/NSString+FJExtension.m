//
//  NSString+BEARExtension.m
//  Habit
//
//  Created by 熊伟 on 2017/10/23.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import "NSString+FJExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSData+FJExtension.h"

@implementation NSString (FJExtension)

-(BOOL)fj_isEmpty
{
    if(!self) return YES;
    
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [self stringByTrimmingCharactersInSet:charSet];
    if([trimmed isEqualToString:@""]) return YES;
    
    return NO;
}

+ (NSString *)fj_stringWithBase64EncodedString:(NSString *)string
{
    NSData *data = [NSData fj_dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)fj_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data fj_base64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *)fj_base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data fj_base64EncodedString];
}

- (NSData *)fj_base64DecodedData
{
    return [NSData fj_dataWithBase64EncodedString:self];
}

- (NSString *)fj_MD5Digest
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

- (NSDictionary *)fj_convertToDictionary
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSString *)fj_stringByTrimingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSUInteger)fj_numberOfLines
{
    return [[self componentsSeparatedByString:@"\n"] count] + 1;
}

- (NSString *)fj_base64DecodedString
{
    return [NSString fj_stringWithBase64EncodedString:self];
}

- (NSInteger)fj_countWord
{
    
    NSInteger i, n = [self length], l = 0, a = 0, b = 0;
    
    unichar c;
    
    for(i=0;i<n;i++){
        
        c=[self characterAtIndex:i];
        
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    
    if(a==0 && l==0) return 0;
    
    return l+(int)ceilf((float)(a+b)/2.0);
    
}

//计算NSString字节长度,汉字占2个，英文占1个
- (NSInteger)fj_convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}

- (NSMutableArray *)fj_itemsForPattern:(NSString *)pattern
{
    return [self fj_itemsForPattern:pattern captureGroupIndex:0];
}

- (NSMutableArray *)fj_itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (result.numberOfRanges > 1) {
                NSRange groupRange =  [result rangeAtIndex:index];
                NSString *match = [self substringWithRange:groupRange];
                [results addObject:match];
            }
        }];
        return results;
    }
    
    return nil;
}

- (NSString *)fj_itemForPatter:(NSString *)pattern
{
    return [self fj_itemForPattern:pattern captureGroupIndex:0];
}

- (NSString *)fj_itemForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSRange searchRange = NSMakeRange(0, [self length]);
        NSTextCheckingResult *result = [regx firstMatchInString:self options:0 range:searchRange];
        NSRange groupRange = [result rangeAtIndex:index];
        NSString *match = [self substringWithRange:groupRange];
        return match;
    }
    
    return nil;
}

- (NSTimeInterval)fj_timeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [[formatter dateFromString:timeString] timeIntervalSince1970];
}

- (NSTimeInterval)fj_localTimeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSTimeInterval timeInterval = [self fj_timeIntervalFromString:timeString withDateFormat:format];
    NSUInteger secondsOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
    return (timeInterval + secondsOffset);
}

- (BOOL)fj_contains:(NSString *)piece
{
    return ( [self rangeOfString:piece].location != NSNotFound );
}

- (NSString *)fj_trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)fj_replaceCharactersAtIndexes:(NSArray *)indexes withString:(NSString *)aString
{
    NSAssert(indexes != nil, @"%s: indexes 不可以为nil", __PRETTY_FUNCTION__);
    NSAssert(aString != nil, @"%s: aString 不可以为nil", __PRETTY_FUNCTION__);
    
    NSUInteger offset = 0;
    NSMutableString *raw = [self mutableCopy];
    
    NSInteger prevLength = 0;
    for(NSInteger i = 0; i < [indexes count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[indexes objectAtIndex:i] rangeValue];
            prevLength = range.length;
            
            range.location -= offset;
            [raw replaceCharactersInRange:range withString:aString];
            offset = offset + prevLength - [aString length];
        }
    }
    
    return raw;
}

- (NSData*)fj_convertToHexStyleData {
    
    if (!self || [self length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([self length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [self length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [self substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


@end
