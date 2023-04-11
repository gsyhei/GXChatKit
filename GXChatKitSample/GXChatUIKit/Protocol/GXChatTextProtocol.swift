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
    
    /// 名片类型名称
    /// - Parameter contact: 名片联系人对象
    /// - Returns: 文本
    func gx_cardTypeName(contact: GXMessagesContactProtocol) -> String
    
    /// 红包文本描述
    /// - Returns: 文本
    func gx_redPacketName() -> String
    
    /// 红包状态文本描述
    /// - Parameter status: 红包状态
    /// - Returns: 文本
    func gx_redPacketStatusString(status: GXChatConfiguration.MessageRedPacketStatus) -> String
    
    /// 回复消息类型文本描述（包含类型：phote、video、audio、call）
    /// - Parameter type: 消息类型
    /// - Returns: 文本
    func gx_replyContentTypeString(type: GXChatConfiguration.MessageType) -> String
    
}
