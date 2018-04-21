//
//  FJUtils.h
//  DevHandTool
//
//  Created by 熊伟 on 2017/12/20.
//  Copyright © 2017年 Bear. All rights reserved.
//

#ifndef FJMacroSingleInstance_h
#define FJMacroSingleInstance_h

#define SINGLETON_INTERFACE(className,singletonName) +(className *)singletonName;

#define SINGLETON_IMPLEMENTION(className,singletonName)\
\
static className *_##singletonName = nil;\
\
+ (className *)singletonName\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_##singletonName = [[super allocWithZone:NULL] init];\
});\
return _##singletonName;\
}\
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
return [self singletonName];\
}\
\
+ (id)copyWithZone:(struct _NSZone *)zone\
{\
return [self singletonName];\
}\




#endif /* FJMacroSingleInstance_h */
