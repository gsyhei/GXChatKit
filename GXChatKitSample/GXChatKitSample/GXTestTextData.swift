//
//  GXTestTextData.swift
//  GXChatKitSample
//
//  Created by Gin on 2023/3/12.
//

import UIKit
import GXChatUIKit
import GXMessagesTableView

public struct GXMessagesTestData: GXMessagesDataProtocol {
    //MARK: - GXMessagesData
    
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
        return .success
    }
    
    public var gx_messageReadingStatus: GXChatConfiguration.MessageReadingStatus {
        return .allRead
    }
    
    public var gx_messagesContentData: GXMessagesContentData? {
        return self.messagesContentData
    }
    
    //MARK: - GXMessagesAvatarDataSource
    
    public var gx_messageContinuousStatus: GXMessageContinuousStatus {
        return self.messageContinuousStatus
    }
    
    public var gx_messageStatus: GXMessageStatus {
        return self.messageStatus
    }
    
    public var gx_senderId: String {
        return self.avatarID
    }
    
    var date: Date = Date()
    var showName: String = "抬头45度仰望天空"
    var avatarID: String = ""
    var messageContinuousStatus: GXMessageContinuousStatus = .begin
    var messageStatus: GXMessageStatus = .sending
    var messageType: GXChatConfiguration.MessageType = .text
    var messagesContentData: GXMessagesContentData? = nil
}
