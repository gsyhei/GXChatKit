//
//  GXMessagesCellDataSource.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/9.
//

import UIKit

public typealias GXMessagesAvatarDataSource = UITableViewCell & GXMessagesAvatarData

public protocol GXMessagesAvatarData {
    
    var messageContinuousStatus: GXChatConfiguration.MessageContinuousStatus { get set }
    
    var messageStatus: GXChatConfiguration.MessageStatus { get set }

    var avatar: UIView { get }
        
    func createAvatarView() -> UIButton
}
