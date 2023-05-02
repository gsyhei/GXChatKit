//
//  GXDefine.swift
//  GXLearningManagement
//
//  Created by Gin on 2021/5/31.
//

import UIKit

public let SCREEN_SIZE = UIScreen.main.bounds.size

public let SCREEN_WIDTH = UIScreen.main.bounds.width - GXSafeAreaInsets.left - GXSafeAreaInsets.right

public let SCREEN_HEIGHT = UIScreen.main.bounds.height

public let SCREEN_MIN_WIDTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

public let SCREEN_SCALE = UIScreen.main.scale

public let STATUS_HEIGHT = StatusBarHeight()

public let GXCHATC = GXChatConfiguration.shared

public let GX_USER_FILE = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
public let GX_USER_FILE_USER = GX_USER_FILE!.appending("/GXUser.data")
public let GX_USER_FILE_CITY = GX_USER_FILE!.appending("/GXMessages.data")

public let GXCHAT_LINK_PREFIX = "@URL:"

public typealias GXActionBlock = (() -> Void)
public typealias GXActionBlockItem<T: Any> = ((T) -> Void)
public typealias GXActionBlockBack<T: Any> = (() -> T)
public typealias GXActionBlockItemBack<T1: Any, T2: Any> = ((T1) -> T2)

private func StatusBarHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 0
    }
    else {
        return UIApplication.shared.statusBarFrame.height
    }
}

public var GXSafeAreaInsets: UIEdgeInsets {
    if let safeAreaInsets = UIApplication.shared.delegate?.window??.rootViewController?.view.safeAreaInsets {
        return safeAreaInsets
    }
    else if let safeAreaInsets = UIApplication.shared.windows.first?.rootViewController?.view.safeAreaInsets {
        return safeAreaInsets
    }
    else if let safeAreaInsets = UIApplication.shared.delegate?.window??.windowScene?.windows.first?.rootViewController?.view.safeAreaInsets {
        return safeAreaInsets
    }
    return .zero
}


