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

public class GXMessagesRichText: NSMutableAttributedString {
    
    /// 转换为文本消息的富文本
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
    
    /// 转换为At消息富文本
    /// - Parameters:
    ///   - attributedString: 文本消息的富文本
    ///   - users: @用户组
    /// - Returns: 富文本消息
    public class func atAttributedText(string: String, users: [GXMessagesUserProtocol]) -> NSAttributedString {
        let attributed = GXMessagesRichText.attributedText(string: string)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        let string = "\n"
        let atAttributes: [Attribute] = [.textColor(GXCHATC.textColor), .font(GXCHATC.atTextFont), .paragraphStyle(paragraphStyle)]
        let appendString = NSMutableAttributedString(string: string)
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttributes(atAttributes, range: range)
        attributed.insert(appendString, at: 0)
        
        for user in users.reversed() {
            let string = "@" + user.gx_userDisplayName + " "
            let atAttributes: [Attribute] = [.textColor(GXCHATC.textColor), .font(GXCHATC.atTextFont), .paragraphStyle(paragraphStyle)]
            let appendString = NSMutableAttributedString(string: string)
            let range: NSRange = NSMakeRange(0, appendString.length)
            appendString.addAttributes(atAttributes, range: range)
            let urlString = GXCHAT_AT_PREFIX + user.gx_userId
            appendString.beginEditing()
            appendString.addAttribute(.foregroundColor, value: GXCHATC.atTextColor, range: range)
            appendString.addAttribute(.link, value: urlString, range: range)
            appendString.endEditing()
            attributed.insert(appendString, at: 0)
        }
        
        return attributed
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


