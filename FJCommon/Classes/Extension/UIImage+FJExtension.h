//
//  UIImage+FJExtension.h
//  FJHandlToolProject
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 熊伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FJExtension)

- (UIImage *)fj_fixOrientation;

#pragma mark - scale
- (UIImage *)fj_cropSquareThumbnail:(CGSize)size;

//按照指定尺寸居中截取缩略图
- (UIImage *)fj_cropCenterThumbnail:(CGSize)size;

- (UIImage *)fj_scaleTo:(CGSize)size;

//按比例缩放，10-图片缩小10倍
- (UIImage *)fj_scaleBy:(float)scale;

//压缩图片至256k以下
- (NSData *)fj_convertToStandardCompressData;


/**
 *  Creates and returns an image object that is a copy of the receiver and flipped horizontally.
 *
 *  @return A new image object.
 */
- (UIImage *)fj_imageFlippedHorizontal;

/**
 *  Creates and returns a new stretchable image object with the specified cap insets.
 *
 *  @param capInsets The values to use for the cap insets.
 *
 *  @return A new image object with the specified cap insets and mode `UIImageResizingModeStretch`.
 */
- (UIImage *)fj_stretchableImageWithCapInsets:(UIEdgeInsets)capInsets;

/**
 *  Creates and returns a new image object with the specified attributes.
 *
 *  @param clipToCircle A boolean value indicating whether or not the returned image should be cropped to a circle. Pass `YES` to crop the returned image to a circle, and `NO` to crop as a square.
 *  @param diameter     A floating point value indicating the diamater of the returned image.
 *  @param borderColor  The color with which to stroke the returned image.
 *  @param borderWidth  The width of the border of the returned image.
 *  @param shadowOffset The values for the shadow offset of the returned image.
 *
 *  @return A new image object with the specified attributes.
 *
 *  @warning This method crops a copy of the receiver into a perfect square centered on the center point of the image before applying the other attributes.
 */
- (UIImage *)fj_imageAsCircle:(BOOL)clipToCircle
                   withDiamter:(CGFloat)diameter
                   borderColor:(UIColor *)borderColor
                   borderWidth:(CGFloat)borderWidth
                  shadowOffSet:(CGSize)shadowOffset;

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)fj_imageMaskWithColor:(UIColor *)maskColor;

#pragma mark ScalingAndCropping
- (UIImage*)fj_imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)fj_imageScaleTo:(CGSize)size;

#pragma mark Create Image
+ (UIImage *)fj_imageWithSize:(CGSize)size color:(UIColor *)color;

+ (UIImage *)fj_imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

- (UIImage *)fj_imageTintedWithColor:(UIColor *)color;

//展示全部的缩放内容，与上面的那个方法互补
- (UIImage *)fj_scaleToByMinScale:(CGSize)size;

- (UIImage *)fj_imageCroppedToRect:(CGRect)rect;

- (UIImage *)fj_squareImage;



@end
