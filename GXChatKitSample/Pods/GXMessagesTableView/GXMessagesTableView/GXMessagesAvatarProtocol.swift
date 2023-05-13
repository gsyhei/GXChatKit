//
//  GXMessagesCellDataSource.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/9.
//

import UIKit

/// 头像cell接口
public typealias GXMessagesAvatarCellProtocol = UITableViewCell & GXMessagesAvatarViewProtocol

/// 消息状态
public enum GXMessageStatus : Int {
    /// 发送
    case send    = 0
    /// 接收
    case receive = 1
}

/// 头像视图接口
public protocol GXMessagesAvatarViewProtocol {
    /// 悬浮头像视图
    var avatar: UIView { get }
    /// 悬浮头像视图创建方法
    func createAvatarView() -> UIView
}

/// 头像数据接口
public protocol GXMessagesAvatarDataProtocol {
    /// 消息连续状态开始
    var gx_continuousBegin: Bool { set get }
    /// 消息连续状态结束
    var gx_continuousEnd: Bool { set get }
    /// 消息状态（发送/接收）
    var gx_messageStatus: GXMessageStatus { get }
    /// 发送者id（用于区分头像）
    var gx_senderId: String { get }
}
