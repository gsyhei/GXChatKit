//
//  GXMessagesSystemContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/3.
//

import UIKit

public class GXMessagesSystemContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    
    public required init(text: String) {
        self.text = text
    }
    
}
