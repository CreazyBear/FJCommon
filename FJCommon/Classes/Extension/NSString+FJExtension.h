//
//  NSString+BEARExtension.h
//  Habit
//
//  Created by 熊伟 on 2017/10/23.
//  Copyright © 2017年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FJExtension)

/*
 * Returns YES if string nil or empty
 */
- (BOOL)fj_isNilOrEmpty;

/**
 *  Returns a copy of the receiver with all whitespaced removed from the front and back.
 *
 *  @return A copied string with all leading and trailing whitespace removed.
 */
- (NSString *)fj_stringByTrimingWhitespace;

/**
 *  Returns the number of lines in the receiver by counting the number of occurences of the newline character, `\n`.
 *
 *  @return An unsigned integer describing the number of lines in the string.
 */
- (NSUInteger)fj_numberOfLines;

- (BOOL)fj_contains:(NSString *)piece;

// 删除字符串开头与结尾的空白符与换行
- (NSString *)fj_trim;

- (NSString *)fj_replaceCharactersAtIndexes:(NSArray *)indexes
                                 withString:(NSString *)aString;

- (NSInteger)fj_countWord;

#pragma mark - convert
- (NSDictionary *)fj_convertToDictionary;

- (NSString *)fj_MD5Digest;

- (NSInteger)fj_convertToInt:(NSString*)strtemp;

- (NSData*)fj_convertToHexStyleData;

#pragma mark - Base64
+ (NSString *)fj_stringWithBase64EncodedString:(NSString *)string;

- (NSString *)fj_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)fj_base64EncodedString;

- (NSString *)fj_base64DecodedString;

- (NSData *)fj_base64DecodedData;

#pragma mark - rich text
/*** 返回符合 pattern 的所有 items */
- (NSMutableArray *)fj_itemsForPattern:(NSString *)pattern;

/*** 返回符合 pattern 的 捕获分组为 index 的所有 items */
- (NSMutableArray *)fj_itemsForPattern:(NSString *)pattern
                     captureGroupIndex:(NSUInteger)index;

/*** 返回符合 pattern 的第一个 item */
- (NSString *)fj_itemForPatter:(NSString *)pattern;

/*** 返回符合 pattern 的 捕获分组为 index 的第一个 item */
- (NSString *)fj_itemForPattern:(NSString *)pattern
              captureGroupIndex:(NSUInteger)index;

/*** 按 format 格式化字符串生成 NSDate 类型的对象，返回 timeString 时间与 1970年1月1日的时间间隔
 * @discussion 格式化后的 NSDate 类型对象为 +0000 时区时间
 */
- (NSTimeInterval)fj_timeIntervalFromString:(NSString *)timeString
                             withDateFormat:(NSString *)format;

/*** 按 format 格式化字符串生成 NSDate 类型的对象，返回当前时间距给定 timeString 之间的时间间隔
 * @discussion 格式化后的 NSDate 类型对象为本地时间
 */
- (NSTimeInterval)fj_localTimeIntervalFromString:(NSString *)timeString
                                  withDateFormat:(NSString *)format;

@end
