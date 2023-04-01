//
//  GXMessagesSectionItem.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/12.
//

import UIKit

public class GXMessagesSectionData: NSObject {
    public var currentDate: Date
    public var dateString: String
    
    public var dateSize: CGSize = .zero
    public var items:[GXMessagesItemData] = []
    
    public required init(date: Date) {
        self.currentDate = date

        self.dateString = GXCHATC.chatText.gx_sectionHeaderString(date: date)
        let size = self.dateString.size(size: CGSize(width: SCREEN_WIDTH, height: 100), font: GXCHATC.headerTextFont)
        self.dateSize = CGSize(width: size.width + GXCHATC.timeFont.lineHeight, height: size.height + 4.0)
    }
    
    public func isSameDay(date: Date) -> Bool {
        return NSCalendar.current.isDate(self.currentDate, inSameDayAs: date)
    }
    
    public func append(item: GXMessagesItemData) {
        self.items.append(item)
    }
    
    public func inset(item: GXMessagesItemData) {
        self.items.insert(item, at: 0)
    }
    
    public func remove(at index: Int) {
        guard index < self.items.count else { return }
        self.items.remove(at: index)
    }

}
