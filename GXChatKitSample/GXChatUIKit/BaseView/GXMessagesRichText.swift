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

class GXMessagesRichText: NSMutableAttributedString {
    
    class func text() -> NSMutableAttributedString {
        /// 测试如何解析
        let string = "也不知道说什么！测试网址https://www.baidu.com，测试电话0755-89776672，测试手机号18826763432，测试表情[微笑][厌恶][鬼脸]。"
        let attributed = NSMutableAttributedString(string: string)
        attributed.addAttributes([.textColor(GXCHATC.textColor), .font(GXCHATC.textFont)], range: 0..<string.count)
        
        let attachment = TextAttachment()
        attachment.bounds = CGRect(x: 0, y: GXCHATC.textFont.descender, width: 20, height: 20)
        attachment.image = UIImage.gx_bundleEmojiImage(name: "e_12")
        attributed.replaceCharacters(in: 10 ..< 12, with: NSAttributedString(attachment: attachment))

//        attributed.addAttributes([.attachment(attachment)], range: 0..<2)
//        attributed.replaceCharacters(in: 0..<4, with: .init(attachment: attachment))
        
        attributed.addAttributes([.link(URL(string: "https://www.baidu.com")!), .textColor(.systemBlue)], range: 12..<20)
        
//        let array = Bundle.gx_bundleEmojiJson()
        
        
        
        

        return attributed
    }

}
