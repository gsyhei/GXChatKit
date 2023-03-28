//
//  GXChatChineseText.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit

class GXChatChineseText: GXChatTextProtocol {
    
    func gx_textCall(status: GXChatConfiguration.MessageCallStatus, isSending: Bool = false) -> String {
//        /// 未接听
//        case missed    = 0
//        /// 已取消
//        case cancel    = 1
//        /// 已挂断
//        case hangUp    = 2
//        /// 已中断
//        case interrupt = 3
//        /// 已结束
//        case finish    = 4
        
        switch status {
        case .missed:
            return isSending ? "对方未接听":"未接听"
        case .cancel:
            return isSending ? "对方已取消":"已取消"
        case .hangUp:
            return isSending ? "对方已拒绝":"已拒绝"
        case .interrupt:
            return "通话中断"
        case .finish:
            return "通话结束"
        }
    }
    

}
