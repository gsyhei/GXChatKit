//
//  GXMessagesForwardContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/2.
//

import UIKit

public class GXMessagesForwardContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    /// 富文本字符串
    public var attributedText: NSAttributedString
    /// 转发来至用户
    public var user: GXMessagesUserDelegate
    
    public required init(text: String, user: GXMessagesUserDelegate) {
        self.text = text
        self.user = user
        self.attributedText = GXRichManager.forwardAttributedText(string: text, user: user)
    }
    
}
