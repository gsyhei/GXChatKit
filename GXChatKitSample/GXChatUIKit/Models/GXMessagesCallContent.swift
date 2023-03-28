//
//  GXMessagesCallContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit
import GXMessagesTableView

public class GXMessagesCallContent: GXMessagesContentData {
    // MARK: - GXMessagesContentData
    
    /// 媒体视图
    public var mediaView: UIView?
    /// 媒体占位视图
    public var mediaPlaceholderView: UIView?
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// icon位置
    public var iconRect: CGRect = .zero
    /// 文本
    private(set) var text: String
    /// 通话时长
    private(set) var duration: TimeInterval = 0
    /// 通话状态
    private(set) var status: GXChatConfiguration.MessageCallStatus
    
    public required init(duration: TimeInterval, status: GXChatConfiguration.MessageCallStatus, messagesStatus: GXMessageStatus) {
        self.duration = duration
        self.status = status
        
        var string = GXCHATC.chatText.gx_textCall(status: status, isSending: (messagesStatus == .sending))
        if status == .interrupt || status == .finish {
            string = string + " " + GXUtilManager.gx_timeString(duration: Int(duration))
        }
        self.text = string
    }
    
}
