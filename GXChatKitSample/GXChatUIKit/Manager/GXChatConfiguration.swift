//
//  GXChatConfiguration.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit

public class GXChatConfiguration: NSObject {
    
    /// 会话头像尺寸
    public var avatarSize: CGSize = CGSize(width: 40.0, height: 40.0) {
        didSet {
            self.avatarRadius = avatarSize.height * 0.5
        }
    }
    /// 会话头像圆角
    public var avatarRadius: CGFloat = 20.0
    /// 头像在前的气泡inset
    public var bubbleLeadingInset: UIEdgeInsets = UIEdgeInsets(top: 6, left: 17, bottom: 6, right: 10)
    /// 头像在后的气泡inset
    public var bubbleTrailingInset: UIEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 17)
    /// 头像两边的空白边距
    public var avatarMargin: CGFloat = 4.0
    /// cell最小行间距
    public var cellMinLineSpacing: CGFloat = 1.0
    /// cell最大行间距
    public var cellMaxLineSpacing: CGFloat = 5.0

    /// 开始气泡图
    public var bubbleBeginImage: UIImage? = .gx_bundleAssetImage(name: "bubble_min_tailless")
    /// 持续中气泡图
    public var bubbleOngoingImage: UIImage? = .gx_bundleAssetImage(name: "bubble_min_tailless")
    /// 结束气泡图
    public var bubbleEndImage: UIImage? = .gx_bundleAssetImage(name: "bubble_min")
    /// 发送方气泡色
    public var sendingBubbleMaskColor: UIColor = UIColor(hex: 0xE0FFC6)
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
    
    /// 单聊发送方是否显示昵称
    public var singleChatSendingShowNickname: Bool = true
    /// 单聊接收方是否显示昵称
    public var singleChatReceivingShowNickname: Bool = true
    /// 群组发送方是否显示昵称
    public var groupChatSendingShowNickname: Bool = true
    /// 群组接收方是否显示昵称
    public var groupChatReceivingShowNickname: Bool = true
    
    /// 文本字体
    public var textFont: UIFont = .systemFont(ofSize: 15)
    /// 文本颜色
    public var textColor: UIColor = UIColor(hex: 0x333333)
    /// 昵称字体
    public var nicknameFont: UIFont = .boldSystemFont(ofSize: 15)
    /// 发送方昵称颜色
    public var sendingNicknameColor: UIColor = .systemBlue
    /// 接收方昵称颜色
    public var receivingNicknameColor: UIColor = .systemBlue
    /// 时间字体
    public var timeFont: UIFont = .systemFont(ofSize: 10)
    /// 发送方时间颜色
    public var sendingTimeColor: UIColor = UIColor(hex: 0x02A603)
    /// 接收方时间颜色
    public var receivingTimeColor: UIColor = .gray
    
    /// header文本字体
    public var headerTextFont: UIFont = .boldSystemFont(ofSize: 12)
    /// header文本颜色
    public var headerTextColor: UIColor = UIColor(hex: 0xFFFFFF)
    /// header文本颜色
    public var headerBackgroudColor: UIColor = UIColor(hex: 0x33333388, useAlpha: true)
    
    /// 语音播放扬声器模式
    public var audioPlaySpeaker: Bool = true
    /// 语音的音轨最大值
    public var audioTrackMaxVakue: CGFloat = 255.0
    /// 语音播放按钮尺寸
    public var audioPlaySize: CGSize = CGSize(width: 50.0, height: 50.0)
    /// 语音播放峰值间隔
    public var audioSpacing: CGFloat = 2.0
    /// 语音播放峰值宽度
    public var audioItemWidth: CGFloat = 3.0
    /// 语音播放峰值最小高度
    public var audioMinHeight: CGFloat = 2.0
    /// 发送方语音时间颜色
    public var audioSendingTimeColor: UIColor = UIColor(hex: 0x02A603)
    /// 发送方语音浅色
    public var audioSendingTimeHighlightColor: UIColor = UIColor(hex: 0x93D887)
    /// 接收方语音时间颜色
    public var audioReceivingTimeColor: UIColor = .systemBlue
    /// 接收方语音浅色
    public var audioReceivingTimeHighlightColor: UIColor = UIColor(hex: 0x7CC1F2)
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
        /// 无需读取
        case none    = -1
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
    
    /// 聊天配置单例
    static let shared: GXChatConfiguration = {
        let instance = GXChatConfiguration()
        return instance
    }()
}
