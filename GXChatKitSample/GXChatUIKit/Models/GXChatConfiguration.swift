//
//  GXChatConfiguration.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit

public class GXChatConfiguration: NSObject {
    /// 会话头像尺寸
    public var avatarSize: CGSize = CGSize(width: 50.0, height: 50.0)
    /// 会话头像圆角
    public var avatarRadius: CGFloat = 25.0
    
    /// 开始气泡图
    public var bubbleBeginImage: UIImage? = .gx_bundleAssetImage(name: "bubble_min_tailless")
    /// 持续中气泡图
    public var bubbleOngoingImage: UIImage? = .gx_bundleAssetImage(name: "bubble_min_tailless")
    /// 结束气泡图
    public var bubbleEndImage: UIImage? = .gx_bundleAssetImage(name: "bubble_min")
    /// 发送方气泡色
    public var sendingBubbleMaskColor: UIColor = .green
    /// 接收方气泡色
    public var receivingBubbleMaskColor: UIColor = .white

    /// 单聊发送方是否显示头像
    public var singleChatSendingShowAvatar: Bool = true
    /// 单聊接收方是否显示头像
    public var singleChatReceivingShowAvatar: Bool = true
    /// 群组发送方是否显示头像
    public var groupChatSendingShowAvatar: Bool = true
    /// 群组接收方是否显示头像
    public var groupChatReceivingShowAvatar: Bool = true
}

public extension GXChatConfiguration {
    /// 聊天类型
    enum ChatType : Int {
        /// 单聊
        case single = 0
        /// 群聊
        case group  = 1
    }
    
    /// 消息类型
    enum MessageType : Int {
        /// 文本
        case text   = 0
        /// 图片
        case phote  = 1
        /// 视频
        case video  = 2
        /// 语音
        case audio  = 3
    }
    
    /// 消息状态
    enum MessageStatus : Int {
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
    
    /// 消息连续状态
    enum MessageContinuousStatus: Int {
        /// 开始
        case begin   = 0
        /// 持续中
        case ongoing = 1
        /// 结束
        case end     = 2
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
    
    /// 聊天配置单例
    static let shared: GXChatConfiguration = {
        let instance = GXChatConfiguration()
        return instance
    }()
}
