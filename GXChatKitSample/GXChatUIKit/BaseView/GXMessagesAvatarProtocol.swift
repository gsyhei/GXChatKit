//
//  GXMessagesCellDataSource.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/9.
//

import UIKit

public typealias GXMessagesAvatarCellProtocol = UITableViewCell & GXMessagesAvatarViewProtocol

public protocol GXMessagesAvatarViewProtocol {

    var avatar: UIView { get }
        
    func createAvatarView() -> UIView
}

public protocol GXMessagesAvatarDataProtocol {
    
    var gx_messageContinuousStatus: GXChatConfiguration.MessageContinuousStatus { get }
    
    var gx_messageStatus: GXChatConfiguration.MessageStatus { get }
    
    var gx_senderId: String { get }
    
}
