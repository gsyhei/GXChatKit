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
         
//public protocol GXMessagesMediaData {
//    /// 文本（文本类型）
//    var text: String? { get }
//    /// 原图（图片类型）
//    var originalImage: UIImage? { get }
//    /// 文件名（文件类型）
//    var fileName: String? { get }
//    /// 持续时间（音频类型）
//    var duration: Int? { get }
//    /// 下载地址
//    var downloadUrl: NSURL? { get }
//    /// 本地地址
//    var fileUrl: NSURL? { get }
//    /// 缩略图
//    var thumbnailImage: UIImage? { get }
//}
