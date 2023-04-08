//
//  GXMessagesRedPacketContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/8.
//

import UIKit

public class GXMessagesRedPacketContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    /// 红包名称
    public var name: String
    /// 红包状态
    public var status: GXChatConfiguration.MessageRedPacketStatus
    /// 红包状态名称
    public var statusName: String

    public required init(text: String, status: GXChatConfiguration.MessageRedPacketStatus) {
        self.text = text
        self.status = status
        self.name = GXCHATC.chatText.gx_redPacketName()
        self.statusName = GXCHATC.chatText.gx_redPacketStatusString(status: status)
    }

}
