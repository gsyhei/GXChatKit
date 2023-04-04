//
//  GXRichText.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/22.
//

import UIKit
import SwiftyAttributes

//REGULAREXPRESSION(UserHandleRegularExpression, @"@[\\u4e00-\\u9fa5\\w\\-]+")
//REGULAREXPRESSION(HashtagRegularExpression, @"#([\\u4e00-\\u9fa5\\w\\-]+)")


class GXTextAttachment: NSTextAttachment {
    public var identifier: String = ""
}

public class GXRichManager: NSObject {
    
    /// 拼接为文本消息的富文本
    /// - Parameter string: 字符串
    /// - Returns: 富文本
    public class func attributedText(string: String) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        let attributes: [Attribute] = [.textColor(GXCHATC.textColor), .font(GXCHATC.textFont), .paragraphStyle(paragraphStyle)]
        
        attributed.addAttributes(attributes, range: 0..<string.count)
        if let emojiRegular = try? NSRegularExpression(pattern: GXCHATC.emojiRegularExpression) {
            var stop: Bool = false
            while !stop {
                let nextString = attributed.string
                let result = emojiRegular.firstMatch(in: nextString, range: NSMakeRange(0, nextString.count))
                if let letResult = result {
                    let emojiStr = nextString.substring(range: letResult.range)
                    if let imageName = GXCHATC.emojiJson[emojiStr] {
                        let attachment = GXTextAttachment()
                        attachment.bounds = CGRect(x: 0, y: GXCHATC.textFont.descender, width: GXCHATC.textFont.lineHeight, height: GXCHATC.textFont.lineHeight)
                        attachment.image = UIImage.gx_bundleEmojiImage(name: imageName)
                        attachment.identifier = emojiStr
                        attributed.replaceCharacters(in: letResult.range, with: .init(attachment: attachment))
                    }
                }
                else {
                    stop = true
                }
            }
        }
        return attributed
    }
    
    /// 拼接为At消息富文本
    /// - Parameters:
    ///   - attributedString: 文本消息的富文本
    ///   - users: @用户组
    /// - Returns: 富文本消息
    public class func atAttributedText(string: String, users: [GXMessagesUserProtocol]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        let attributes: [Attribute] = [.textColor(GXCHATC.atTextColor), .font(GXCHATC.atTextFont), .paragraphStyle(paragraphStyle)]

        let attributedString = NSMutableAttributedString()
        for user in users {
            let userString = "@" + user.gx_displayName + " "
            let appendString = NSMutableAttributedString(string: userString)
            let range: NSRange = NSMakeRange(0, appendString.length)
            appendString.addAttributes(attributes, range: range)
            let urlString = GXCHAT_LINK_PREFIX + user.gx_id
            appendString.beginEditing()
            appendString.addAttribute(.foregroundColor, value: GXCHATC.atTextColor, range: range)
            appendString.addAttribute(.link, value: urlString, range: range)
            appendString.endEditing()
            attributedString.append(appendString)
        }
        let returnString = NSMutableAttributedString(string: "\n")
        returnString.addAttributes(attributes, range: NSMakeRange(0, returnString.length))
        attributedString.append(returnString)
        
        let attributedText = GXRichManager.attributedText(string: string)
        attributedString.append(attributedText)
        
        return attributedString
    }
    
    /// 拼接为转发消息富文本
    /// - Parameters:
    ///   - attributedString: 文本消息的富文本
    ///   - user: 转发来至用户
    /// - Returns: 富文本消息
    public class func forwardAttributedText(string: String, user: GXMessagesUserProtocol) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        let attributes: [Attribute] = [.textColor(GXCHATC.forwardTextColor), .font(GXCHATC.forwardTextFont), .paragraphStyle(paragraphStyle)]

        let attributedString = NSMutableAttributedString()
        let userString = GXCHATC.chatText.gx_forwardContentString() + "\n" + user.gx_displayName + "\n"
        let appendString = NSMutableAttributedString(string: userString)
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttributes(attributes, range: range)
        attributedString.append(appendString)
        
        let attributedText = GXRichManager.attributedText(string: string)
        attributedString.append(attributedText)
        
        return attributedString
    }
    
    
    /// 富文本转换为字符串
    /// - Parameter attributedString: 消息富文本
    /// - Returns: 字符串
    public class func text(attributedString: NSAttributedString) -> String {
        let mutableString = NSMutableString()
        let count = attributedString.length
        for index in 0..<count {
            let subAttr = attributedString.attributedSubstring(from: NSRange(location: index, length: 1))
            let subAttachment = subAttr.attribute(.attachment, at: 0, longestEffectiveRange: nil, in: NSRange(location: 0, length: 1))
            if let letAttachment = subAttachment as? GXTextAttachment {
                mutableString.append(letAttachment.identifier)
            }
            else {
                mutableString.append(subAttr.string)
            }
        }
        return mutableString as String
    }
    
}


