//
//  GXMessageData.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import Foundation
import GXMessagesTableView

public typealias GXMessagesDataProtocol = GXMessagesData & GXMessagesAvatarDataProtocol

public protocol GXMessagesData {
    /// 消息唯一ID
    var gx_messageId: String { get }
    /// 群ID（不是群则为nil）
    var gx_groupId: String? { get }
    /// 发送方ID
    var gx_senderId: String { get }
    /// 发送方显示名称
    var gx_senderDisplayName: String { get }
    /// 发送方头像
    var gx_sendAvatarUrl: NSURL? { get }
    /// 消息日期
    var gx_messageDate: Date { get }
    /// 消息显示时间
    var gx_messageTime: String { get }
    /// 聊天类型
    var gx_chatType: GXChatConfiguration.ChatType { get }
    /// 消息类型
    var gx_messageType: GXChatConfiguration.MessageType { get }
    /// 消息发送状态
    var gx_messageSendStatus: GXChatConfiguration.MessageSendStatus { get }
    /// 消息读取状态
    var gx_messageReadingStatus: GXChatConfiguration.MessageReadingStatus { get }
    /// 消息内容
    var gx_messagesContentData: GXMessagesContentData? { get }
}
