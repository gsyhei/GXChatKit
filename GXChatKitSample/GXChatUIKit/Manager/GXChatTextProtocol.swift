//
//  GXChatTextProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import Foundation
import GXMessagesTableView

public protocol GXChatTextProtocol {
    
    /// 获得通话状态文本
    /// - Parameters:
    ///   - status: 通话状态
    ///   - isSending: 是否为发送
    /// - Returns: 文本
    func gx_textCall(status: GXChatConfiguration.MessageCallStatus, isSending: Bool) -> String
    
    
}
