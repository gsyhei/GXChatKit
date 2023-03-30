//
//  GXMessagesUserProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/30.
//

import Foundation

public protocol GXMessagesUserProtocol  {
    /// 用户ID
    var gx_userId: String { get }
    /// 用户显示名称
    var gx_userDisplayName: String { get }
    /// 用户头像
    var gx_userAvatarUrl: NSURL? { get }
}
