//
//  GXMessagesTableView+Configuration.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/3.
//

import UIKit

public extension GXMessagesTableView {

    /// 聊天类型
    enum ChatType : Int {
        /// 单聊
        case single = 0
        /// 群聊
        case group  = 1
    }
    
    /// 消息状态
    enum MessageType : Int {
        /// 发送
        case sending   = 0
        /// 接收
        case receiving = 1
    }
    
    /// 消息发送状态
    enum MessageSendStatus : Int {
        /// 失败
        case failure = 0
        /// 发送中
        case sending = 1
        /// 成功
        case success = 2
    }
    
    /// 消息读取状态
    enum MessageReadingStatus: Int {
        /// 未读
        case unread  = 0
        /// 已读
        case read    = 1
        /// 全部已读（群消息）
        case allRead = 2
    }
    
    /// 消息菜单
    enum MessageMenuType: Int {
        /// 回复
        case repply  = 0
        /// 复制
        case copy    = 1
        /// 转发
        case forward = 2
        /// 编辑
        case edit    = 3
        /// 保存
        case save    = 4
        /// 收藏
        case collect = 5
        /// 撤回
        case revoke  = 6
        /// 删除
        case delete  = 7
        /// 举报
        case report  = 8
        /// 选择
        case select  = 9
    }
    
    /// 消息事件
    enum MessageEvent : Int {
        /// 点击头像
        case clickAvatar   = 0
        /// 点击重发
        case clickResend   = 1
        /// 点击Cell
        case clickCell     = 2
        /// 双击Cell
        case doubleCell    = 3
        /// 长按Cell
        case longPressCell = 4
        /// 侧滑Cell
        case swipeCell     = 5
    }
    
    class configuration: NSObject {
        /// 单聊是否显示头像
        var singleChatShowAvatar: Bool = true
        /// 群组是否显示头像
        var groupChatShowAvatar: Bool = true
        
    }
}
