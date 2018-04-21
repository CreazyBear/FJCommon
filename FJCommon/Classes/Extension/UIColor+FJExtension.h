//
//  UIColor+TKCategory.h
//  Created by Devin Ross on 5/14/11.
//
/*
 
 tapku || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

//为了统一使用方式，在些在前缀进行统一更改~！


#import <UIKit/UIKit.h>

@interface UIColor (FJExtension)

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @return The `UIColor` object.
 */
+ (UIColor *)fj_colorWithHex:(unsigned int)hex;

/** Creates and returns a color object using the specific hex value.
 @param hex The hex value that will decide the color.
 @param alpha The opacity of the color.
 @return The `UIColor` object.
 */
+ (UIColor *)fj_colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;

/** Creates and returns a color object with a random color value. The alpha property is 1.0.
 @return The `UIColor` object.
 */
+ (UIColor *)fj_randomColor;

+ (UIColor *)fj_colorWithHexString:(NSString *)hexString;

+ (UIColor *)fj_colorwithHexString:(NSString *)hexString alpha:(CGFloat)alpha ;

@end
