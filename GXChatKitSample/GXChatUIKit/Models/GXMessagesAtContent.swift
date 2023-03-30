//
//  GXMessagesAtContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/29.
//

import UIKit

public class GXMessagesAtContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 媒体视图
    public var mediaView: UIView?
    /// 媒体占位视图
    public var mediaPlaceholderView: UIView?
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    /// 富文本字符串
    public var attributedText: NSAttributedString
    /// @At用户
    public var users: [GXMessagesUserProtocol]
    
    public required init(text: String, users: [GXMessagesUserProtocol]) {
        self.text = text
        self.users = users
        self.attributedText = GXMessagesRichText.attributedText(string: text, users: users)
    }
    
}
