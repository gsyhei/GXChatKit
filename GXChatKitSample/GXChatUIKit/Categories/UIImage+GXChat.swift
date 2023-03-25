//
//  UIImage+GXChat.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/12.
//

import UIKit
import AVFoundation

public extension UIImage {

    /// 内部资源图
    /// - Parameter name: 图片名
    /// - Returns: 图片
    class func gx_bundleAssetImage(name: String) -> UIImage? {
        let bundle = Bundle.gx_messagesAssetBundle
        let path = bundle?.path(forResource: name, ofType: "png", inDirectory: "images")
        guard let imagePath = path else { return nil }
        
        return UIImage(contentsOfFile: imagePath)
    }
    
    /// 内部表情图
    /// - Parameter name: 图片名
    /// - Returns: 图片
    class func gx_bundleEmojiImage(name: String) -> UIImage? {
        let bundle = Bundle.gx_messagesAssetBundle
        let path = bundle?.path(forResource: name, ofType: nil, inDirectory: "emoji")
        guard let imagePath = path else { return nil }
        
        return UIImage(contentsOfFile: imagePath)
    }
    
    /// 当前image生成指定颜色的mask图
    /// - Parameter maskColor: mask色
    /// - Returns: 指定颜色的mask图
    func gx_imageMasked(maskColor: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else {return nil}

        let frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -frame.height)
        context?.clip(to: frame, mask: cgImage)
        context?.setFillColor(maskColor.cgColor)
        context?.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// 生成文本图片
    /// - Parameters:
    ///   - text: 文本
    ///   - size: 尺寸
    ///   - backgroundColor: 背景色
    ///   - textColor: 文本色
    ///   - font: 字体
    /// - Returns: 文本图片
    class func gx_textImage(_ text: String,
                            size: CGSize,
                            backgroundColor: UIColor = .black,
                            textColor: UIColor = .white,
                            font: UIFont = .boldSystemFont(ofSize: 20)) -> UIImage?
    {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.foregroundColor: textColor]
        let textFrame = text.boundingRect(with: size,
                                          options: [.usesLineFragmentOrigin, .usesFontLeading],
                                          attributes: attributes,
                                          context: nil)
        let frameMidPoint = CGPoint(x: frame.midX, y: frame.midY)
        let textFrameMidPoint = CGPoint(x: textFrame.midX, y: textFrame.midY)
        let dx = frameMidPoint.x - textFrameMidPoint.x
        let dy = frameMidPoint.y - textFrameMidPoint.y;
        let drawPoint = CGPoint(x: dx, y: dy)
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.fill(frame)
        text.draw(at: drawPoint, withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {return nil}
        
        return .init(cgImage:cgImage)
    }
    
    /// 生成圆角图片
    /// - Parameters:
    ///   - size: 尺寸
    ///   - image: 图片
    ///   - radius: 圆角半径
    ///   - highlightedColor: 高亮色
    /// - Returns: 圆角图片
    class func gx_roundedImage(_ image: UIImage,
                               size: CGSize,
                               radius: CGFloat? = nil,
                               highlightedColor: UIColor? = nil) -> UIImage?
    {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        let minRadius = min(size.width/2, size.height/2)
        let letRadius: CGFloat = radius ?? minRadius
        let imagePath = UIBezierPath(roundedRect: frame, cornerRadius: letRadius)
        imagePath.addClip()
        image.draw(in: frame)
        if let color = highlightedColor {
            context?.setFillColor(color.cgColor)
            context?.fillEllipse(in: frame)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {return nil}
        
        return .init(cgImage:cgImage)
    }
    
    /// 获取视频封面图片
    /// - Parameters:
    ///   - asset: 资源
    ///   - size: 尺寸
    ///   - time: 时间
    ///   - handler: 异步结果回调
    class func gx_getThumbnailImgae(asset: AVURLAsset,
                                    size: CGSize = UIScreen.main.bounds.size,
                                    time: CMTime = CMTimeMakeWithSeconds(1, preferredTimescale: 2),
                                    completionHandler handler: @escaping ((UIImage?, Error?) -> Void))
    {
        let generate = AVAssetImageGenerator(asset: asset)
        generate.appliesPreferredTrackTransform = true
        generate.maximumSize = size
        if #available(iOS 16.0, *) {
            generate.generateCGImageAsynchronously(for: time) { cgImage, requestedTime, error in
                if error == nil {
                    guard let letCGImage = cgImage else {
                        handler(nil, error); return
                    }
                    handler(.init(cgImage: letCGImage), error)
                }
                else {
                    handler(nil, error); return
                }
            }
        } else {
            generate.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { requestedTime, cgImage, actualTime, result, error in
                if result == .succeeded {
                    guard let letCGImage = cgImage else {
                        handler(nil, error); return
                    }
                    handler(.init(cgImage: letCGImage), error)
                }
                else {
                    handler(nil, error)
                }
            }
        }
    }

}
