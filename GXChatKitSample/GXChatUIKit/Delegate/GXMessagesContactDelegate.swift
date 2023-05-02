//
//  GXMessagesUserProtocol.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/30.
//

import Foundation

public protocol GXMessagesContactDelegate {
    /// 联系人ID
    var gx_id: String { get }
    /// 显示名称
    var gx_displayName: String { get }
    /// 联系人头像
    var gx_avatarUrl: NSURL? { get }
}

public protocol GXMessagesUserDelegate: GXMessagesContactDelegate {
}

public protocol GXMessagesGroupDelegate: GXMessagesContactDelegate {
}
