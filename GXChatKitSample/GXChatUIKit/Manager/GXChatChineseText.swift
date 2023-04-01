//
//  GXChatChineseText.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit

public class GXChatChineseText: GXChatTextProtocol {
    
    public func gx_sectionHeaderString(date: Date) -> String {
        if date.isToday {
            return GXLS("今天")
        }
        else if date.isYesterday {
            return GXLS("昨天")
        }
        else if NSCalendar.current.isDate(date, equalTo: Date(), toGranularity: .month) {
            return date.string(format: "M月d日")      //英文版简写date.string(format: "MMMM d")
        }
        else if NSCalendar.current.isDate(date, equalTo: Date(), toGranularity: .year) {
            return date.string(format: "M月d日")      //英文版简写date.string(format: "MMMM d")
        }
        else {
            return date.string(format: "YYYY年M月d日") //英文版简写date.string(format: "MMMM d, y")
        }
    }
    
    public func gx_textCall(status: GXChatConfiguration.MessageCallStatus, isSending: Bool = false) -> String {
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
