//
//  GXMessageMideaItem.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit
import GXMessagesTableView

public class GXMessagesItemData: Equatable {
    /// 数据
    public var data: GXMessagesDataProtocol
    /// 布局
    public var layout: GXMessagesBaseLayout!
    /// 头像
    public var avatar: GXMessagesAvatar?
    /// 显示名称的颜色hex
    public var dispalyNameHexString: String?

    public static func == (lhs: GXMessagesItemData, rhs: GXMessagesItemData) -> Bool {
        if lhs.data.gx_chatType == .group {
            return lhs.data.gx_chatType == rhs.data.gx_chatType
            && lhs.data.gx_groupId == rhs.data.gx_groupId
            && lhs.data.gx_senderId == rhs.data.gx_senderId
            && lhs.data.gx_messageId == rhs.data.gx_messageId
        }
        else {
            return lhs.data.gx_chatType == rhs.data.gx_chatType
            && lhs.data.gx_senderId == rhs.data.gx_senderId
            && lhs.data.gx_messageId == rhs.data.gx_messageId
        }
    }
    
    public required init(data: GXMessagesDataProtocol) {
        self.data = data
        
        if GXCHATC.isAutoSetupNicknameColor {
            self.dispalyNameHexString = data.gx_displayNameHexString
        }
        if data.gx_messageType == .redPacket {
            self.avatar = GXMessagesAvatarFactory.messagesAvatar(name: data.gx_senderDisplayName)
        }
        else if data.gx_messageType != .system {
            self.avatar = GXMessagesAvatarFactory.messagesAvatar(name: data.gx_senderDisplayName)
        }
        self.updateLayout()
    }
    
    public func updateLayout() {
        switch self.data.gx_messageType {
        case .text, .atText, .forward:
            self.layout = GXMessagesTextLayout(data: self.data)
        case .phote:
            self.layout = GXMessagesPhotoLayout(data: self.data)
        case .video:
            self.layout = GXMessagesVideoLayout(data: self.data)
        case .audio:
            self.layout = GXMessagesAudioLayout(data: self.data)
        case .location:
            self.layout = GXMessagesLocationLayout(data: self.data)
        case .voiceCall, .videoCall:
            self.layout = GXMessagesCallLayout(data: self.data)
        case .system:
            self.layout = GXMessagesSystemLayout(data: self.data)
        case .bCard:
            self.layout = GXMessagesCardLayout(data: self.data)
        case .file:
            self.layout = GXMessagesFileLayout(data: self.data)
        case .redPacket:
            self.layout = GXMessagesRedPacketLayout(data: self.data)
        case .reply:
            self.layout = GXMessagesReplyLayout(data: self.data)
        }
    }
    
    public func updateMessagesAvatar(image: UIImage?) {
        if let avatarImage = image {
            self.avatar?.avatarImage = GXMessagesAvatarFactory.circularAvatarImage(image: avatarImage)
            self.avatar?.avatarHighlightedImage = GXMessagesAvatarFactory.circularAvatarHighlightedImage(image: avatarImage)
        }
    }
    
}
