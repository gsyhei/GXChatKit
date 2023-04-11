//
//  GXMessagesReplyContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/12.
//

import UIKit

public class GXMessagesReplyContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    /// 富文本字符串
    public var attributedText: NSAttributedString
    /// 回复data
    public var replyData: GXMessagesDataProtocol

    public required init(text: String, replyData: GXMessagesDataProtocol) {
        self.text = text
        self.attributedText = GXRichManager.attributedText(string: text)
        self.replyData = replyData
    }
    
}
