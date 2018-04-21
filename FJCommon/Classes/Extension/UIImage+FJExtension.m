//
//  UIImage+FJExtension.m
//  FJHandlToolProject
//
//  Created by Bear on 2017/12/20.
//  Copyright © 2017年 熊伟. All rights reserved.
//

#import "UIImage+FJExtension.h"

@implementation UIImage (FJExtension)

- (UIImage *)fj_fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - scale

//按照指定尺寸居中截取缩略图
- (UIImage *)fj_cropCenterThumbnail:(CGSize)size
{
    CGSize imageSize = self.size;
    
    //按比例截取
    float widthScale = size.width / imageSize.width;
    float heightScale = size.height / imageSize.height;
    
    float scale = MAX(widthScale, heightScale);
    size = CGSizeMake(size.width / scale, size.height / scale);
    
    
    return [self fj_getSubImage:CGRectMake((imageSize.width - size.width) / 2, (imageSize.height - size.height) / 2, size.width, size.height)];
}

//增加截取正方形thumnbnail方法
- (UIImage *)fj_cropSquareThumbnail:(CGSize)size
{
    CGSize imageSize = self.size;
    int width = MIN(imageSize.width, imageSize.height);
    
    
    UIImage *thumbnail = [self fj_getSubImage:CGRectMake((imageSize.width - width) / 2, (imageSize.height - width) / 2, width, width)];
    thumbnail = [self fj_scaleTo:size];
    
    return thumbnail;
}

//截取部分图像
- (UIImage*)fj_getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage *)fj_scaleTo:(CGSize)size
{
    CGSize sourceSize = [self size];
    CGRect destinationRectangle = CGRectMake(0, 0, size.width, size.height);
    
    // I want to keep the aspect ratio of the original image.
    float ratio = MAX(destinationRectangle.size.height / sourceSize.height,
                      destinationRectangle.size.width / sourceSize.width);
    
    // Create a virtual graphics context
    UIGraphicsBeginImageContextWithOptions(destinationRectangle.size, NO, 0.0);
    
    CGRect destinationRectanble;
    destinationRectanble.size.width = ratio * sourceSize.width;
    destinationRectanble.size.height = ratio * sourceSize.height;
    destinationRectanble.origin.x = (destinationRectangle.size.width - destinationRectanble.size.width) / 2;
    destinationRectanble.origin.y = (destinationRectangle.size.height - destinationRectanble.size.height) / 2;
    
    [self drawInRect:destinationRectanble];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // Close the virtual graphics context
    UIGraphicsEndPDFContext();
    
    // Deliver the resized image.
    return result;
}

//按比例缩放，10-图片缩小10倍
- (UIImage *)fj_scaleBy:(float)scale
{
    UIImage *result = [[UIImage alloc] initWithCGImage:self.CGImage scale:scale   orientation:self.imageOrientation];
    
    return result;
}

#pragma mark - ImgStandardCompressMethod since807

- (NSData *)fj_convertToStandardCompressData
{
    CGFloat longerWide = self.size.height > self.size.width? self.size.height: self.size.width;
    // make the longer Wide less than 1024p
    CGFloat radio = longerWide / 1024 > 1? longerWide / 1024: 1;
    CGSize destinationSize = CGSizeMake(self.size.width / radio, self.size.height / radio);
    
    // reDraw the image
    UIGraphicsBeginImageContext(destinationSize);
    [self drawInRect:CGRectMake(0, 0, destinationSize.width, destinationSize.height)];
    UIImage *destSizeImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // compress the image until less than 256k
    NSData *imageData = UIImageJPEGRepresentation(destSizeImage, 1.0);
    for (CGFloat compressParam = 1.0; imageData.length > 1024 * 256 && compressParam; compressParam -= 0.1) {
        imageData = UIImageJPEGRepresentation(destSizeImage, compressParam);
    }
    
    return imageData;
}


- (UIImage *)fj_imageFlippedHorizontal
{
    return [UIImage imageWithCGImage:self.CGImage
                               scale:self.scale
                         orientation:UIImageOrientationUpMirrored];
}

- (UIImage *)fj_stretchableImageWithCapInsets:(UIEdgeInsets)capInsets
{
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_6_0) {
        return [self resizableImageWithCapInsets:capInsets
                                    resizingMode:UIImageResizingModeStretch];
    }
    else {
        return [self resizableImageWithCapInsets:capInsets];
    }
}

- (UIImage *)fj_imageAsCircle:(BOOL)clipToCircle
                   withDiamter:(CGFloat)diameter
                   borderColor:(UIColor *)borderColor
                   borderWidth:(CGFloat)borderWidth
                  shadowOffSet:(CGSize)shadowOffset
{
    // increase given size for border and shadow
    CGFloat increase = diameter * 0.1f;
    CGFloat newSize = diameter + increase;
    
    CGRect newRect = CGRectMake(0.0f,
                                0.0f,
                                newSize,
                                newSize);
    
    // fit image inside border and shadow
    CGRect imgRect = CGRectMake(increase,
                                increase,
                                newRect.size.width - (increase * 2.0f),
                                newRect.size.height - (increase * 2.0f));
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // draw shadow
    if (!CGSizeEqualToSize(shadowOffset, CGSizeZero)) {
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(shadowOffset.width, shadowOffset.height),
                                    2.0f,
                                    [UIColor colorWithWhite:0.0f alpha:0.45f].CGColor);
    }
    
    // draw border
    if (borderColor && borderWidth) {
        CGPathRef borderPath = (clipToCircle) ? CGPathCreateWithEllipseInRect(imgRect, NULL) : CGPathCreateWithRect(imgRect, NULL);
        CGContextAddPath(context, borderPath);
        
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, borderWidth);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGPathRelease(borderPath);
    }
    
    CGContextRestoreGState(context);
    
    if (clipToCircle) {
        UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:imgRect];
        [imgPath addClip];
    }
    
    [self drawInRect:imgRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)fj_imageMaskWithColor:(UIColor *)maskColor
{
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(ctx, 1.0f, -1.0f);
    CGContextTranslateCTM(ctx, 0.0f, -(imageRect.size.height));
    
    CGContextClipToMask(ctx, imageRect, self.CGImage);
    CGContextSetFillColorWithColor(ctx, maskColor.CGColor);
    CGContextFillRect(ctx, imageRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)fj_imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)fj_imageScaleTo:(CGSize)size
{
    CGSize sourceSize = [self size];
    CGRect destinationRectangle = CGRectMake(0, 0, size.width, size.height);
    
    // I want to keep the aspect ratio of the original image.
    float ratio = MAX(destinationRectangle.size.height / sourceSize.height,
                      destinationRectangle.size.width / sourceSize.width);
    
    // Create a virtual graphics context
    UIGraphicsBeginImageContextWithOptions(destinationRectangle.size, NO, 0.0);
    
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:destinationRectangle
    //                                                    cornerRadius:5.0];
    //    [path addClip];
    
    CGRect destinationRectanble;
    destinationRectanble.size.width = ratio * sourceSize.width;
    destinationRectanble.size.height = ratio * sourceSize.height;
    destinationRectanble.origin.x = (destinationRectangle.size.width - destinationRectanble.size.width) / 2;
    destinationRectanble.origin.y = (destinationRectangle.size.height - destinationRectanble.size.height) / 2;
    
    [self drawInRect:destinationRectanble];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // Close the virtual graphics context
    UIGraphicsEndImageContext();
    
    // Deliver the resized image.
    return result;
}


#pragma mark Create Image
+ (UIImage *)fj_imageWithSize:(CGSize)size color:(UIColor *)color
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0.0f, 0.0f, scale * size.width, scale * size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)fj_imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize scaledSize = CGSizeMake(scale * size.width, scale * size.height);
    CGRect rect = CGRectMake(0.0f, 0.0f, scaledSize.width, scaledSize.height);
    UIGraphicsBeginImageContext(scaledSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    UIBezierPath *roundCornerRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius * scale];
    
    CGContextAddPath(context, roundCornerRect.CGPath);
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




- (UIImage *)fj_imageTintedWithColor:(UIColor *)color
{
    // This method is designed for use with template images, i.e. solid-coloured mask-like images.
    return [self fj_imageTintedWithColor:color fraction:0.0]; // default to a fully tinted mask of the image.
}

- (UIImage *)fj_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction
{
    if (color) {
        // Construct new image the same size as this one.
        UIImage *image;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
            UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
        }
#else
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0) {
            UIGraphicsBeginImageContext([self size]);
        }
#endif
        CGRect rect = CGRectZero;
        rect.size = [self size];
        
        // Composite tint color at its own opacity.
        [color set];
        UIRectFill(rect);
        
        // Mask tint color-swatch to this image's opaque mask.
        // We want behaviour like NSCompositeDestinationIn on Mac OS X.
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        // Finally, composite this image over the tinted mask at desired opacity.
        if (fraction > 0.0) {
            // We want behaviour like NSCompositeSourceOver on Mac OS X.
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    return self;
}

//展示全部的缩放内容，与上面的那个方法互补
- (UIImage *)fj_scaleToByMinScale:(CGSize)size
{
    CGSize sourceSize = [self size];
    CGRect destinationRectangle = CGRectMake(0, 0, size.width, size.height);
    
    // I want to keep the aspect ratio of the original image.
    float ratio = MIN(destinationRectangle.size.height / sourceSize.height,
                      destinationRectangle.size.width / sourceSize.width);
    
    // Create a virtual graphics context
    UIGraphicsBeginImageContextWithOptions(destinationRectangle.size, NO, 0.0);
    
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:destinationRectangle
    //                                                    cornerRadius:5.0];
    //    [path addClip];
    
    CGRect destinationRectanble;
    destinationRectanble.size.width = ratio * sourceSize.width;
    destinationRectanble.size.height = ratio * sourceSize.height;
    destinationRectanble.origin.x = (destinationRectangle.size.width - destinationRectanble.size.width) / 2;
    destinationRectanble.origin.y = (destinationRectangle.size.height - destinationRectanble.size.height) / 2;
    
    [self drawInRect:destinationRectanble];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    // Close the virtual graphics context
    UIGraphicsEndImageContext();
    
    // Deliver the resized image.
    return result;
}

- (UIImage *) fj_imageCroppedToRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}

- (UIImage *) fj_squareImage{
    CGFloat min = self.size.width <= self.size.height ? self.size.width : self.size.height;
    return [self fj_imageCroppedToRect:CGRectMake(0,0,min,min)];
}






@end
