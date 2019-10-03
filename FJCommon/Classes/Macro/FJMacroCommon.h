//
//  FJMacroCommon.h
//  FJCommonProject
//
//  Created by 熊伟 on 2018/4/21.
//  Copyright © 2018年 熊伟. All rights reserved.
//

#ifndef FJMacroCommon_h
#define FJMacroCommon_h


#pragma mark - NSLog

#ifdef DEBUG
#define FJLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FJDebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(...) NSLog(__VA_ARGS__);
#define FJNSLog(FORMAT, ...) fprintf(stderr,"[%s]:[line %d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define FJLog(...)
#define FJDebugLog(...)
#define NSLog(...)
#define FJNSLog(FORMAT, ...)
#endif

#pragma mark end

#pragma mark - Frame

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height


#define SafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
#pragma mark end

#pragma mark - 单例

#define SINGLETON_INTERFACE(className) +(className *)shared;
#define SINGLETON_IMPLEMENTION(className)\
\
static className *_##shared = nil;\
\
+ (className *)shared\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_##shared = [[super allocWithZone:NULL] init];\
});\
return _##shared;\
}\
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
return [self shared];\
}\
\
+ (id)copyWithZone:(struct _NSZone *)zone\
{\
return [self shared];\
}\

#pragma mark end


#endif /* FJMacroCommon_h */
