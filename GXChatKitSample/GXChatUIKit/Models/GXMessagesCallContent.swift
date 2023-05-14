//
//  GXMessagesCallContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit

public class GXMessagesCallContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本
    public var text: String
    /// 通话时长
    public var duration: TimeInterval = 0
    /// 通话状态
    public var status: GXChatConfiguration.MessageCallStatus
    
    public required init(duration: TimeInterval, status: GXChatConfiguration.MessageCallStatus, messagesStatus: GXChatConfiguration.MessageStatus) {
        self.duration = duration
        self.status = status
        
        var string = GXCHATC.chatText.gx_callContentString(status: status, isSending: (messagesStatus == .send))
        if status == .interrupt || status == .finish {
            string = string + " " + GXUtilManager.gx_timeString(duration: Int(duration))
        }
        self.text = string
    }
    
}
