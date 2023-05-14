//
//  GXRichText.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/22.
//

import UIKit
import YYText

//REGULAREXPRESSION(UserHandleRegularExpression, @"@[\\u4e00-\\u9fa5\\w\\-]+")
//REGULAREXPRESSION(HashtagRegularExpression, @"#([\\u4e00-\\u9fa5\\w\\-]+)")

public class GXRichManager: NSObject {
    
    public static let emojiKey = "emojiKey"
    public static let highlightKey = "highlKey"
    public static let userIdKey = "userIdKey"
    
    class func textLayout(maxSize: CGSize, text: NSAttributedString) -> YYTextLayout {
        let modifier = YYTextLinePositionSimpleModifier()
        modifier.fixedLineHeight = GXCHATC.textFont.lineHeight + GXCHATC.textLineSpacing
        let container = YYTextContainer(size: maxSize, insets: .zero)
        container.linePositionModifier = modifier
        guard let layout = YYTextLayout(container: container, text: text) else {
            fatalError("Failed to YYTextLayout init. ")
        }
        return layout
    }
    
    // 拼接为文本消息的富文本
    /// - Parameter string: 字符串
    /// - Returns: 富文本
    class func attributedText(string: String) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: string)
        attributed.yy_font = GXCHATC.textFont
        attributed.yy_color = GXCHATC.textColor
        attributed.yy_lineSpacing = GXCHATC.textLineSpacing
        
        if let urlExpression = try? NSRegularExpression(pattern: GXCHATC.urlRegularExpression) {
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            highlight.userInfo = [highlightKey: HighlightType.url]
            urlExpression.enumerateMatches(in: string, range: NSMakeRange(0, string.count)) { result, flags, stop in
                if let range = result?.range, flags != .internalError {
                    attributed.yy_setColor(GXCHATC.textHighlightColor, range: range)
                    attributed.yy_setTextHighlight(highlight, range: range)
                }
            }
        }
        if let phoneExpression = try? NSRegularExpression(pattern: GXCHATC.phoneRegularExpression) {
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            highlight.userInfo = [highlightKey: HighlightType.phone]
            phoneExpression.enumerateMatches(in: string, range: NSMakeRange(0, string.count)) { result, flags, stop in
                if let range = result?.range, flags != .internalError {
                    attributed.yy_setColor(GXCHATC.textHighlightColor, range: range)
                    attributed.yy_setTextHighlight(highlight, range: range)
                }
            }
        }
        if let emailExpression = try? NSRegularExpression(pattern: GXCHATC.emailRegularExpression) {
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            highlight.userInfo = [highlightKey: HighlightType.email]
            emailExpression.enumerateMatches(in: string, range: NSMakeRange(0, string.count)) { result, flags, stop in
                if let range = result?.range, flags != .internalError {
                    attributed.yy_setColor(GXCHATC.textHighlightColor, range: range)
                    attributed.yy_setTextHighlight(highlight, range: range)
                }
            }
        }
        if let emojiRegular = try? NSRegularExpression(pattern: GXCHATC.emojiRegularExpression) {
            var stop: Bool = false
            while !stop {
                let nextString = attributed.string
                let result = emojiRegular.firstMatch(in: nextString, range: NSMakeRange(0, nextString.count))
                if let letResult = result {
                    let emojiStr = nextString.substring(range: letResult.range)
                    if let imageName = GXCHATC.emojiJson[emojiStr] {
                        let attachmentAtt = NSMutableAttributedString(string: YYTextAttachmentToken)
                        let attachmentRange = NSMakeRange(0, attachmentAtt.length)
                        
                        let image = UIImage.gx_bundleEmojiImage(name: imageName)
                        let size = CGSize(width: GXCHATC.textFont.lineHeight, height: GXCHATC.textFont.lineHeight)
                        let attachment = YYTextAttachment(content: image)
                        attachment.contentMode = .scaleAspectFit
                        attachment.userInfo = [GXRichManager.emojiKey: emojiStr]
                        attachmentAtt.yy_setTextAttachment(attachment, range: attachmentRange)
                        
                        let delegate = YYTextRunDelegate()
                        delegate.width = size.width
                        delegate.ascent = size.height + GXCHATC.textFont.descender
                        delegate.descent = -GXCHATC.textFont.descender;
                        attachmentAtt.yy_setRunDelegate(delegate.ctRunDelegate(), range: attachmentRange)
                        
                        attributed.replaceCharacters(in: letResult.range, with: attachmentAtt)
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
    class func atAttributedText(string: String, users: [GXMessagesUserDelegate]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        var attributes: Dictionary<NSAttributedString.Key, Any> = [:]
        attributes[NSAttributedString.Key.foregroundColor] = GXCHATC.atTextColor
        attributes[NSAttributedString.Key.font] = GXCHATC.atTextFont
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        let attributedString = NSMutableAttributedString()
        for user in users {
            let userString = "@" + user.gx_displayName + " "
            let appendString = NSMutableAttributedString(string: userString)
            let range: NSRange = NSMakeRange(0, appendString.length)
            appendString.addAttributes(attributes, range: range)
            
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            highlight.userInfo = [highlightKey: HighlightType.user, userIdKey: user.gx_id]
            appendString.yy_setTextHighlight(highlight, range: range)
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
    class func forwardAttributedText(string: String, user: GXMessagesUserDelegate) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        var attributes: Dictionary<NSAttributedString.Key, Any> = [:]
        attributes[NSAttributedString.Key.foregroundColor] = GXCHATC.atTextColor
        attributes[NSAttributedString.Key.font] = GXCHATC.atTextFont
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        let attributedString = NSMutableAttributedString()
        let userString = GXCHATC.chatText.gx_forwardContentString() + user.gx_displayName + "\n"
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
    class func text(attributedString: NSAttributedString) -> String {
        let mutableString = NSMutableString()
        let count = attributedString.length
        for index in 0..<count {
            let subAttr = attributedString.attributedSubstring(from: NSRange(location: index, length: 1))
            if let attachment = subAttr.yy_attributes?[YYTextAttachmentAttributeName] as? YYTextAttachment {
                if let emojiStr = attachment.userInfo?[emojiKey] as? String {
                    mutableString.append(emojiStr)
                }
            }
            else {
                mutableString.append(subAttr.string)
            }
        }
        return mutableString as String
    }
    
    /// 获取时间富文本
    /// - Parameters:
    ///   - time: 时间文本
    ///   - status: 消息状态
    ///   - readStatus: 读取状态
    /// - Returns: 富文本
    class func timeText(time: String, status: GXChatConfiguration.MessageStatus, sendStatus: GXChatConfiguration.MessageSendStatus) -> NSAttributedString {
        var attributes: Dictionary<NSAttributedString.Key, Any> = [:]
        attributes[NSAttributedString.Key.font] = GXCHATC.timeFont
        if status == .send {
            attributes[NSAttributedString.Key.foregroundColor] = GXCHATC.sendingTimeColor
        }
        else {
            attributes[NSAttributedString.Key.foregroundColor] = GXCHATC.receivingTimeColor
        }
        let attributedString = NSMutableAttributedString()
        let appendString = NSMutableAttributedString(string: time)
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttributes(attributes, range: range)
        attributedString.append(appendString)
        guard status == .send && sendStatus != .none else { return attributedString }
        
        let bounds = CGRect(x: 0, y: -5, width: GXCHATC.timeFont.lineHeight + 5, height: GXCHATC.timeFont.lineHeight + 5)
        if sendStatus == .unread {
            if let image = UIImage.gx_readCheckSingleImage?.gx_imageMasked(color: GXCHATC.sendingTimeColor) {
                let attachment = NSTextAttachment(image: image)
                attachment.bounds = bounds
                let attachmentAtt = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentAtt)
            }
        }
        else if sendStatus == .read {
            if let image = UIImage.gx_readCheckDoubleImage?.gx_imageMasked(color: GXCHATC.sendingTimeColor) {
                let attachment = NSTextAttachment(image: image)
                attachment.bounds = bounds
                let attachmentAtt = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentAtt)
            }
        }
        else if sendStatus == .failure {
            if let image = UIImage.gx_sendFailureImage?.gx_imageMasked(color: .systemRed) {
                let attachment = NSTextAttachment(image: image)
                attachment.bounds = bounds
                let attachmentAtt = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentAtt)
            }
        }
        else if sendStatus == .sending {
            let attachment = NSTextAttachment(image: UIImage())
            attachment.bounds = bounds
            let attachmentAtt = NSAttributedString(attachment: attachment)
            attributedString.append(attachmentAtt)
        }
        return attributedString
    }
    
}

public extension GXRichManager {
    
    /// 高亮类型
    enum HighlightType : Int {
        case url   = 0
        case phone = 1
        case email = 2
        case user  = 3
    }
    
}

