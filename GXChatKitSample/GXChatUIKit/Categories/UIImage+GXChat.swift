//
//  UIImage+GXChat.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/12.
//

import UIKit

public extension UIImage {
    
    class func gx_image(initials: String,
                        backgroundColor: UIColor = .black,
                        textColor: UIColor = .white,
                        font: UIFont = .boldSystemFont(ofSize: 16)) {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
//    - (UIImage *)jsq_imageWithInitials:(NSString *)initials
//                       backgroundColor:(UIColor *)backgroundColor
//                             textColor:(UIColor *)textColor
//                                  font:(UIFont *)font
//    {
//        NSParameterAssert(initials != nil);
//        NSParameterAssert(backgroundColor != nil);
//        NSParameterAssert(textColor != nil);
//        NSParameterAssert(font != nil);
//
//        CGRect frame = CGRectMake(0.0f, 0.0f, self.diameter, self.diameter);
//
//        NSDictionary *attributes = @{ NSFontAttributeName : font,
//                                      NSForegroundColorAttributeName : textColor };
//
//        CGRect textFrame = [initials boundingRectWithSize:frame.size
//                                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
//                                               attributes:attributes
//                                                  context:nil];
//
//        CGPoint frameMidPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
//        CGPoint textFrameMidPoint = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));
//
//        CGFloat dx = frameMidPoint.x - textFrameMidPoint.x;
//        CGFloat dy = frameMidPoint.y - textFrameMidPoint.y;
//        CGPoint drawPoint = CGPointMake(dx, dy);
//        UIImage *image = nil;
//
//        UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
//        {
//            CGContextRef context = UIGraphicsGetCurrentContext();
//
//            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
//            CGContextFillRect(context, frame);
//            [initials drawAtPoint:drawPoint withAttributes:attributes];
//
//            image = UIGraphicsGetImageFromCurrentImageContext();
//
//        }
//        UIGraphicsEndImageContext();
//
//        return [self jsq_circularImage:image withHighlightedColor:nil];
//    }
//
//    - (UIImage *)jsq_circularImage:(UIImage *)image withHighlightedColor:(UIColor *)highlightedColor
//    {
//        NSParameterAssert(image != nil);
//
//        CGRect frame = CGRectMake(0.0f, 0.0f, self.diameter, self.diameter);
//        UIImage *newImage = nil;
//
//        UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
//        {
//            CGContextRef context = UIGraphicsGetCurrentContext();
//
//            UIBezierPath *imgPath = [UIBezierPath bezierPathWithOvalInRect:frame];
//            [imgPath addClip];
//            [image drawInRect:frame];
//
//            if (highlightedColor != nil) {
//                CGContextSetFillColorWithColor(context, highlightedColor.CGColor);
//                CGContextFillEllipseInRect(context, frame);
//            }
//
//            newImage = UIGraphicsGetImageFromCurrentImageContext();
//
//        }
//        UIGraphicsEndImageContext();
//
//        return newImage;
//    }

    
}
