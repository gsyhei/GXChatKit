//
//  GXMessageData.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import Foundation
import GXMessagesTableView

public protocol GXMessagesDataProtocol: GXMessagesAvatarDataProtocol  {
    /// 消息唯一ID
    var gx_messageId: String { get }
    /// 群ID（不是群则为nil）
    var gx_groupId: String? { get }
    /// 发送方显示名称
    var gx_senderDisplayName: String { get }
    /// 发送方头像
    var gx_sendAvatarUrl: NSURL? { get }
    /// 消息日期
    var gx_messageDate: Date { get }
    /// 消息显示时间
    var gx_messageTime: String { get }
    /// 聊天类型
    var gx_chatType: GXChatConfiguration.ChatType { get }
    /// 消息类型
    var gx_messageType: GXChatConfiguration.MessageType { get }
    /// 消息发送状态
    var gx_messageSendStatus: GXChatConfiguration.MessageSendStatus { get }
    /// 消息读取状态
    var gx_messageReadingStatus: GXChatConfiguration.MessageReadingStatus { get }
    /// 消息内容
    var gx_messagesContent: GXMessagesContentProtocol? { get }
}

public extension GXMessagesDataProtocol {
    
    /// 头像是否显示
    var gx_isShowAvatar: Bool {
        if self.gx_messageStatus == .sending {
            if self.gx_chatType == .single {
                return GXCHATC.singleChatSendingShowAvatar
            }
            else {
                return GXCHATC.groupChatSendingShowAvatar
            }
        }
        else {
            if self.gx_chatType == .single {
                return GXCHATC.singleChatReceivingShowAvatar
            }
            else {
                return GXCHATC.groupChatReceivingShowAvatar
            }
        }
    }
    
    /// 昵称是否显示
    var gx_isShowNickname: Bool {
        if GXCHATC.showContinuousBeginNickname {
            guard self.gx_continuousBegin else { return false }
        }
        if self.gx_messageStatus == .sending {
            if self.gx_chatType == .single {
                return GXCHATC.singleChatSendingShowNickname
            }
            else {
                return GXCHATC.groupChatSendingShowNickname
            }
        }
        else {
            if self.gx_chatType == .single {
                return GXCHATC.singleChatReceivingShowNickname
            }
            else {
                return GXCHATC.groupChatReceivingShowNickname
            }
        }
    }
    
    /// 头像占用的width
    var gx_avatarContentWidth: CGFloat {
        var avatarContentWidth: CGFloat = GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
        if self.gx_messageStatus == .sending && GXCHATC.singleChatSendingShowAvatar {
            avatarContentWidth += GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
        }
        else if self.gx_messageStatus == .receiving && GXCHATC.singleChatReceivingShowAvatar {
            avatarContentWidth += GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
        }
        else {
            avatarContentWidth += GXCHATC.avatarMargin*2
        }
        return avatarContentWidth
    }
    
    /// 内容的point
    var gx_contentPoint: CGPoint {
        if self.gx_isShowNickname {
            if self.gx_messageStatus == .sending {
                let top = GXCHATC.bubbleTrailingInsets.top + GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing
                return CGPoint(x: GXCHATC.bubbleTrailingInsets.left, y: top)
            }
            else {
                let top = GXCHATC.bubbleLeadingInsets.top + GXCHATC.nicknameFont.lineHeight + GXCHATC.nicknameLineSpacing
                return CGPoint(x: GXCHATC.bubbleLeadingInsets.left, y: top)
            }
        }
        else {
            if self.gx_messageStatus == .sending {
                return CGPoint(x: GXCHATC.bubbleTrailingInsets.left, y: GXCHATC.bubbleTrailingInsets.top)
            }
            else {
                return CGPoint(x: GXCHATC.bubbleLeadingInsets.left, y: GXCHATC.bubbleLeadingInsets.top)
            }
        }
    }
    
    /// 内容容器视图的left
    func gx_containerLeft(container width: CGFloat) -> CGFloat {
        if self.gx_messageStatus == .sending {
            if self.gx_chatType == .single {
                if GXCHATC.singleChatSendingShowAvatar {
                    return SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) - width
                }
                else {
                    return SCREEN_WIDTH - GXCHATC.avatarMargin*2 - width
                }
            }
            else {
                if GXCHATC.groupChatSendingShowAvatar {
                    return SCREEN_WIDTH - (GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2) - width
                }
                else {
                    return SCREEN_WIDTH - GXCHATC.avatarMargin*2 - width
                }
            }
        }
        else {
            if self.gx_chatType == .single {
                if GXCHATC.singleChatReceivingShowAvatar {
                    return GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
                }
                else {
                    return GXCHATC.avatarMargin*2
                }
            }
            else {
                if GXCHATC.groupChatReceivingShowAvatar {
                    return GXCHATC.avatarSize.width + GXCHATC.avatarMargin*2
                }
                else {
                    return GXCHATC.avatarMargin*2
                }
            }
        }
    }
    
    /// 根据现实名称生成hexString
    var gx_displayNameHexString: String {
        let pinying = self.gx_senderDisplayName.transformToPinYinInitial(isUppercase: true)
        var hexString = "#"
        for i in 0..<pinying.count {
            let charStr = pinying[i]
            let charAscii = charStr.cString(using: .ascii)
            if let charSub = charAscii?.first {
                if i == 2 || i == 3 {
                    hexString += String(format: "%X", charSub % 8)
                }
                else {
                    hexString += String(format: "%X", charSub % 16)
                }
            }
        }
        if hexString.count > 7 {
            hexString = hexString.substring(to: 7)
        }
        else {
            for _ in hexString.count..<7 {
                hexString += "0"
            }
        }
        
        return hexString
    }
    
}
