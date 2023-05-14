//
//  GXChatChineseText.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/28.
//

import UIKit

public class GXChatChineseText: GXChatTextDelegate {
    
    public func gx_forwardContentString() -> String {
        return "转发自：\n"
    }
    
    public func gx_sectionHeaderString(date: Date) -> String {
        if date.isToday {
            return "今天"
        }
        else if date.isYesterday {
            return "昨天"
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
    
    public func gx_callContentString(status: GXChatConfiguration.MessageCallStatus, isSending: Bool = false) -> String {
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
    
    public func gx_cardTypeName(contact: GXMessagesContactDelegate) -> String {
        if contact is GXMessagesUserDelegate {
            return "个人名片"
        }
        else {
            return "群名片"
        }
    }
    
    public func gx_redPacketName() -> String {
        return "自发红包"
    }
    
    public func gx_redPacketStatusString(status: GXChatConfiguration.MessageRedPacketStatus) -> String {
        switch status {
        case .none:
            return "未领取"
        case .partReceive:
            return "部分领取"
        case .allReceive:
            return "全部领取"
        }
    }

    public func gx_replyContentTypeString(type: GXChatConfiguration.MessageType) -> String {
        switch type {
        case .phote:
            return "[图片]"
        case .video:
            return "[视频]"
        case .audio:
            return "[语音]"
        case .voiceCall:
            return "[语音通话]"
        case .videoCall:
            return "[视频通话]"
        default:
            return ""
        }
    }

    public func gx_menuTypeString(type: GXChatConfiguration.MessageMenuType) -> String {
        switch type {
        case .repply:
            return "回复"
        case .copy:
            return "复制"
        case .forward:
            return "转发"
        case .edit:
            return "编辑"
        case .save:
            return "保存"
        case .collect:
            return "收藏"
        case .revoke:
            return "撤回"
        case .delete:
            return "删除"
        case .report:
            return "举报"
        case .resend:
            return "重发"
        case .select:
            return "选择"
        }
    }
    
}
