//
//  GXMessagesUserProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/30.
//

import Foundation

public protocol GXMessagesContactProtocol {
    /// 联系人ID
    var gx_id: String { get }
    /// 显示名称
    var gx_displayName: String { get }
    /// 联系人头像
    var gx_avatarUrl: NSURL? { get }
}

public protocol GXMessagesUserProtocol: GXMessagesContactProtocol {
}

public protocol GXMessagesGroupProtocol: GXMessagesContactProtocol {
}
