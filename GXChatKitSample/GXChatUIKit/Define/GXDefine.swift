//
//  GXDefine.swift
//  GXLearningManagement
//
//  Created by Gin on 2021/5/31.
//

import UIKit

let SCREEN_SIZE = UIScreen.main.bounds.size

let SCREEN_WIDTH = UIScreen.main.bounds.width

let SCREEN_HEIGHT = UIScreen.main.bounds.height

let SCREEN_SCALE = UIScreen.main.scale

let STATUS_HEIGHT = StatusBarHeight()

let GXCHATC = GXChatConfiguration.shared

let GX_USER_FILE = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
let GX_USER_FILE_USER = GX_USER_FILE!.appending("/GXUser.data")
let GX_USER_FILE_CITY = GX_USER_FILE!.appending("/GXMessages.data")

typealias GXActionBlock = (() -> Void)
typealias GXActionBlockItem<T: Any> = ((T) -> Void)
typealias GXActionBlockBack<T: Any> = (() -> T)
typealias GXActionBlockItemBack<T1: Any, T2: Any> = ((T1) -> T2)

private func StatusBarHeight() -> CGFloat {
    if #available(iOS 13.0, *) {
        return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.statusBarManager?.statusBarFrame.height ?? 0
    }
    else {
        return UIApplication.shared.statusBarFrame.height
    }
}

public func GXLS(_ string: String) -> String {
    return NSLocalizedString(string, comment: "")
}

