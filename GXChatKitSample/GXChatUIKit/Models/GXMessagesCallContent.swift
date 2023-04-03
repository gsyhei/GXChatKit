//
//  GXMessagesCallContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit
import GXMessagesTableView

public class GXMessagesCallContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本
    private(set) var text: String
    /// 通话时长
    private(set) var duration: TimeInterval = 0
    /// 通话状态
    private(set) var status: GXChatConfiguration.MessageCallStatus
    
    public required init(duration: TimeInterval, status: GXChatConfiguration.MessageCallStatus, messagesStatus: GXMessageStatus) {
        self.duration = duration
        self.status = status
        
        var string = GXCHATC.chatText.gx_callContentString(status: status, isSending: (messagesStatus == .sending))
        if status == .interrupt || status == .finish {
            string = string + " " + GXUtilManager.gx_timeString(duration: Int(duration))
        }
        self.text = string
    }
    
}
