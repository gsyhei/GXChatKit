//
//  GXMessagesUserProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/30.
//

import Foundation

public protocol GXMessagesContactProtocol {
    /// 用户ID
    var gx_id: String { get }
    /// 用户显示名称
    var gx_displayName: String { get }
    /// 用户头像
    var gx_avatarUrl: NSURL? { get }
}

public protocol GXMessagesUserProtocol: GXMessagesContactProtocol {
}

public protocol GXMessagesGroupProtocol: GXMessagesContactProtocol {
}
