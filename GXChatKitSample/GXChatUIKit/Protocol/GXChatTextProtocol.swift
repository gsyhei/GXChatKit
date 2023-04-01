//
//  GXChatTextProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import Foundation

public protocol GXChatTextProtocol {
    
    /// 获取转发自文本
    /// - Returns: 文本
    func gx_forwardContentString() -> String
    
    /// 获取section header日期文本
    /// - Parameter date: 日期
    /// - Returns: 文本
    func gx_sectionHeaderString(date: Date) -> String
    
    /// 获取通话状态文本
    /// - Parameters:
    ///   - status: 通话状态
    ///   - isSending: 是否为发送
    /// - Returns: 文本
    func gx_callContentString(status: GXChatConfiguration.MessageCallStatus, isSending: Bool) -> String
    
}
