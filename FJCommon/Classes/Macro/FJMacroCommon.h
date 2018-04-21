//
//  FJMacroCommon.h
//  FJCommonProject
//
//  Created by 熊伟 on 2018/4/21.
//  Copyright © 2018年 熊伟. All rights reserved.
//

#ifndef FJMacroCommon_h
#define FJMacroCommon_h



#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif





#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height


#define SafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)




#endif /* FJMacroCommon_h */
