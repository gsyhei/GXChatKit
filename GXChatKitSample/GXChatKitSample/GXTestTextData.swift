//
//  GXTestTextData.swift
//  GXChatKitSample
//
//  Created by Gin on 2023/3/12.
//

import UIKit
import GXChatUIKit

class GXMessagesTestData {
    var date: Date = Date()
    var showName: String = "抬头45度仰望天空"
    var messageID: String = ""
    var avatarID: String = ""
    var continuousBegin: Bool = false
    var continuousEnd: Bool = false
    var messageSendStatus: GXChatConfiguration.MessageSendStatus = .none
    var messageStatus: GXChatConfiguration.MessageStatus = .send
    var messageType: GXChatConfiguration.MessageType = .text
    var messagesContentData: GXMessagesContentDelegate? = nil
    var timeAttributedText: NSAttributedString? = nil
}

extension GXMessagesTestData: GXMessagesDataDelegate {
    
    public var gx_groupId: String? {
        return nil
    }
    
    //MARK: - GXMessagesData
    
    public var gx_messageId: String {
        return self.messageID
    }
    
    public var gx_senderDisplayName: String {
        return self.showName
    }
    
    public var gx_sendAvatarUrl: NSURL? {
        return NSURL(string: "")
    }
    
    public var gx_messageDate: Date {
        return self.date
    }
    
    public var gx_messageTime: String {
        return self.date.string(format: "H:mm a")
    }
    
    public var gx_chatType: GXChatConfiguration.ChatType {
        return .single
    }
    
    public var gx_messageType: GXChatConfiguration.MessageType {
        return self.messageType
    }
    
    public var gx_messageSendStatus: GXChatConfiguration.MessageSendStatus {
        return self.messageSendStatus
    }
    
    public var gx_messagesContent: GXMessagesContentDelegate? {
        return self.messagesContentData
    }
    
    public var gx_timeAttributedText: NSAttributedString? {
        get {
            return self.timeAttributedText
        }
        set(newValue) {
            self.timeAttributedText = newValue
        }
    }
    
    //MARK: - GXMessagesAvatarDataSource
    
    public var gx_continuousBegin: Bool {
        set {
            self.continuousBegin = newValue
        }
        get {
            return self.continuousBegin
        }
    }
    
    public var gx_continuousEnd: Bool {
        set {
            self.continuousEnd = newValue
        }
        get {
            return self.continuousEnd
        }
    }
    
    public var gx_messageStatus: GXChatConfiguration.MessageStatus {
        return self.messageStatus
    }
    
    public var gx_senderId: String {
        return self.avatarID
    }
}

struct GXTestUser {
    var userId: String = ""
    var userName: String = ""
    var userUrl: NSURL? = nil
}

extension GXTestUser: GXMessagesUserDelegate {
    var gx_id: String {
        return userId
    }
    
    var gx_displayName: String {
        return userName
    }
    
    var gx_avatarUrl: NSURL? {
        return userUrl
    }
}
