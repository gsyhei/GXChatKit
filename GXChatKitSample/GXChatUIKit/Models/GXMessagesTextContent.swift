//
//  GXMessagesTextContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesTextContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    /// 富文本字符串
    public var attributedText: NSAttributedString

    public required init(text: String) {
        self.text = text
        self.attributedText = GXRichManager.attributedText(string: text)
        
        let string = GXRichManager.text(attributedString: self.attributedText)
        NSLog("GXMessagesTextContent: \(string)")
    }
}
   
