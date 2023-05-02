//
//  GXMessagesReplyContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/12.
//

import UIKit

public class GXMessagesReplyContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 文本字符串
    public var text: String
    /// 富文本字符串
    public var attributedText: NSAttributedString
    /// 回复对象内容文本
    public var replyContentText: String = ""
    /// 回复对象是否显示icon
    public var isShowIcon: Bool = false
    /// @At用户
    public var users: [GXMessagesUserDelegate]
    /// 回复data
    public var replyData: GXMessagesDataDelegate

    public required init(text: String, users: [GXMessagesUserDelegate] = [], replyData: GXMessagesDataDelegate) {
        self.text = text
        self.users = users
        if users.count > 0 {
            self.attributedText = GXRichManager.atAttributedText(string: text, users: users)
        }
        else {
            self.attributedText = GXRichManager.attributedText(string: text)
        }
        self.replyData = replyData
        self.replyContentText = self.replyContentText(replyData: replyData)
        self.isShowIcon = self.isShowIcon(replyData: replyData)
    }
    
    private func isShowIcon(replyData: GXMessagesDataDelegate) -> Bool {
        switch replyData.gx_messageType {
        case .phote, .video, .location, .bCard, .file, .redPacket:
            return true
        default:
            return false
        }
    }
    
    private func replyContentText(replyData: GXMessagesDataDelegate) -> String {
        if let content = replyData.gx_messagesContent as? GXMessagesTextContent {
            return content.text
        }
        else if replyData.gx_messagesContent is GXMessagesPhotoContent {
            return GXCHATC.chatText.gx_replyContentTypeString(type: replyData.gx_messageType)
        }
        else if replyData.gx_messagesContent is GXMessagesVideoContent {
            return GXCHATC.chatText.gx_replyContentTypeString(type: replyData.gx_messageType)
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesAudioContent {
            return GXCHATC.chatText.gx_replyContentTypeString(type: replyData.gx_messageType) + String(format: "0:%02d", Int(content.duration))
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesLocationContent {
            return content.locationTitle
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesCardContent {
            return content.contact.gx_displayName
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesFileContent {
            return content.fileName
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesRedPacketContent {
            return content.text
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesCallContent{
            return GXCHATC.chatText.gx_replyContentTypeString(type: replyData.gx_messageType) + content.text
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesAtContent {
            return content.attributedText.string
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesForwardContent {
            return content.text
        }
        else if let content = replyData.gx_messagesContent as? GXMessagesReplyContent {
            return content.attributedText.string
        }        
        return ""
    }
    
}
