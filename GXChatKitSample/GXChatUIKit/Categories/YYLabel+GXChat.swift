//
//  YYLabel+GXChat.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/18.
//

import YYText
import SwiftyAttributes

public extension YYLabel {
    
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
            urlExpression.enumerateMatches(in: string, range: NSMakeRange(0, string.count)) { result, flags, stop in
                if let range = result?.range, flags == .completed {
                    attributed.yy_setTextHighlight(highlight, range: range)
                }
            }
        }
        if let phoneExpression = try? NSRegularExpression(pattern: GXCHATC.phoneRegularExpression) {
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            phoneExpression.enumerateMatches(in: string, range: NSMakeRange(0, string.count)) { result, flags, stop in
                if let range = result?.range, flags == .completed {
                    attributed.yy_setTextHighlight(highlight, range: range)
                }
            }
        }
        if let emailExpression = try? NSRegularExpression(pattern: GXCHATC.emailRegularExpression) {
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            emailExpression.enumerateMatches(in: string, range: NSMakeRange(0, string.count)) { result, flags, stop in
                if let range = result?.range, flags == .completed {
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
//                        let image = UIImage.gx_bundleEmojiImage(name: imageName)
//                        let size = CGSize(width: GXCHATC.textFont.lineHeight, height: GXCHATC.textFont.lineHeight)
//                        let attachment = NSMutableAttributedString.yy_attachmentString(withContent: image,
//                                                                      contentMode: .scaleAspectFit,
//                                                                      attachmentSize: size,
//                                                                      alignTo: GXCHATC.textFont,
//                                                                      alignment: .bottom)
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
    class func atAttributedText(string: String, users: [GXMessagesUserProtocol]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        let attributes: [Attribute] = [.textColor(GXCHATC.atTextColor), .font(GXCHATC.atTextFont), .paragraphStyle(paragraphStyle)]

        let attributedString = NSMutableAttributedString()
        for user in users {
            let userString = "@" + user.gx_displayName + " "
            let appendString = NSMutableAttributedString(string: userString)
            let range: NSRange = NSMakeRange(0, appendString.length)
            appendString.addAttributes(attributes, range: range)
            
            let highlight = YYTextHighlight(backgroundColor: GXCHATC.textBackgroudColor)
            highlight.setColor(GXCHATC.textHighlightColor)
            appendString.yy_setTextHighlight(highlight, range: range)
            
            
//            let urlString = GXCHAT_LINK_PREFIX + user.gx_id
//            appendString.beginEditing()
//            appendString.addAttribute(.foregroundColor, value: GXCHATC.atTextColor, range: range)
//            appendString.addAttribute(.link, value: urlString, range: range)
//            appendString.endEditing()
            attributedString.append(appendString)
        }
        let returnString = NSMutableAttributedString(string: "\n")
        returnString.addAttributes(attributes, range: NSMakeRange(0, returnString.length))
        attributedString.append(returnString)
        
        let attributedText = YYLabel.attributedText(string: string)
        attributedString.append(attributedText)
        
        return attributedString
    }
    
    /// 拼接为转发消息富文本
    /// - Parameters:
    ///   - attributedString: 文本消息的富文本
    ///   - user: 转发来至用户
    /// - Returns: 富文本消息
    class func forwardAttributedText(string: String, user: GXMessagesUserProtocol) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        let attributes: [Attribute] = [.textColor(GXCHATC.forwardTextColor), .font(GXCHATC.forwardTextFont), .paragraphStyle(paragraphStyle)]

        let attributedString = NSMutableAttributedString()
        let userString = GXCHATC.chatText.gx_forwardContentString() + user.gx_displayName + "\n"
        let appendString = NSMutableAttributedString(string: userString)
        let range: NSRange = NSMakeRange(0, appendString.length)
        appendString.addAttributes(attributes, range: range)
        attributedString.append(appendString)
        
        let attributedText = YYLabel.attributedText(string: string)
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
