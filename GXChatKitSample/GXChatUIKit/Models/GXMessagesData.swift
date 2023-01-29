//
//  GXMessageData.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import Foundation

public protocol GXMessagesData {
    /// 发送方ID
    var senderId: String { get }
    /// 发送方显示名称
    var senderDisplayName: String { get }
    /// 发送方头像
    var sendAvatarUrl: NSURL { get }
    /// 消息日期
    var messageDate: Date { get }
    /// 消息类型
    var messageType: GXChatConfiguration.MessageType { get }
    /// 消息状态
    var messageStatus: GXChatConfiguration.MessageStatus { get }
    /// 消息发送状态
    var messageSendStatus: GXChatConfiguration.MessageSendStatus { get }
    /// 消息读取状态
    var messageReadingStatus: GXChatConfiguration.MessageReadingStatus { get }
}
