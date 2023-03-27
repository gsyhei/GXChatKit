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

class GXMessagesRichText: NSMutableAttributedString {
    
    public class func attributedText(string: String) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = GXCHATC.textLineSpacing
        attributed.addAttributes([.textColor(GXCHATC.textColor), .font(GXCHATC.textFont), .paragraphStyle(paragraphStyle)], range: 0..<string.count)
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


