//
//  GXMessagesAvatarFactory.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesAvatarFactory {
    
    /// 生成头像数据模型
    /// - Parameters:
    ///   - text: 文本
    ///   - image: 图片
    /// - Returns: 头像数据模型
    public class func messagesAvatar(text: String, image: UIImage? = nil) -> GXMessagesAvatar {
        let messagesAvatar = GXMessagesAvatar()
        messagesAvatar.avatarPlaceholderImage = GXMessagesAvatarFactory.circularAvatarPlaceholderImage(text: text)
        if let avatarImage = image {
            messagesAvatar.avatarImage = GXMessagesAvatarFactory.circularAvatarImage(image: avatarImage)
            messagesAvatar.avatarHighlightedImage = GXMessagesAvatarFactory.circularAvatarHighlightedImage(image: avatarImage)
        }
        return messagesAvatar
    }
    
    /// 圆形头像
    /// - Parameter image: 图片
    /// - Returns: 头像图
    public class func circularAvatarImage(image: UIImage?) -> UIImage? {
        guard let letImage = image else { return nil }
        
        let avatarSize = GXCHATC.avatarSize
        let avatarRadius = GXCHATC.avatarRadius

        return UIImage.gx_roundedImage(letImage, size: avatarSize, radius: avatarRadius)
    }
    
    /// 圆形高亮头像
    /// - Parameter image: 图片
    /// - Returns: 高亮头像图
    public class func circularAvatarHighlightedImage(image: UIImage?) -> UIImage? {
        guard let letImage = image else { return nil }
        
        let avatarSize = GXCHATC.avatarSize
        let avatarRadius = GXCHATC.avatarRadius
        let highlightedColor = UIColor(white: 0.1, alpha: 0.3)
        
        return UIImage.gx_roundedImage(letImage, size: avatarSize, radius: avatarRadius, highlightedColor: highlightedColor)
    }
    
    /// 圆形占位头像
    /// - Parameter image: 图片
    /// - Returns: 高亮头像图
    public class func circularAvatarPlaceholderImage(text: String) -> UIImage? {
        let avatarSize = GXCHATC.avatarSize
        let font = UIFont.boldSystemFont(ofSize: 20)
        let title = (text.count > 0) ? text[0] : ""
        let image = UIImage.gx_textImage(title, size: avatarSize, backgroundColor: .orange, textColor: .white, font: font)
        guard let textImage = image else { return nil }
        
        return GXMessagesAvatarFactory.circularAvatarImage(image: textImage)
    }

}
