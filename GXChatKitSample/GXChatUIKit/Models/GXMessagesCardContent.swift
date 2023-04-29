//
//  GXMessagesCardContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/5.
//

import UIKit

public class GXMessagesCardContent: GXMessagesContentProtocol {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 名片联系人对象（用户/群）
    public var contact: GXMessagesContactProtocol
    /// 名片类型名
    public var cardTypeName: String
    /// 头像
    public var cardAvatar: GXMessagesAvatar

    public required init(contact: GXMessagesContactProtocol, avatar: GXMessagesAvatar? = nil) {
        self.contact = contact
        self.cardTypeName = GXCHATC.chatText.gx_cardTypeName(contact: contact)
        if let cardAvatar = avatar {
            self.cardAvatar = cardAvatar
        }
        else {
            self.cardAvatar = GXMessagesAvatarFactory.messagesAvatar(name: contact.gx_displayName)
        }
    }
    
}
