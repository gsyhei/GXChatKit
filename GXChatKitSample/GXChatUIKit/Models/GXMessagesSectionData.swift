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
    public var items:[GXMessagesItemLayoutData] = []
    
    public required init(date: Date) {
        self.currentDate = date

        if date.isToday {
            self.dateString = date.string(format: "MMMM d")//date.string(format: "今天")
        }
        else if date.isYesterday {
            self.dateString = date.string(format: "MMMM d")//date.string(format: "昨天")
        }
        else if NSCalendar.current.isDate(date, equalTo: Date(), toGranularity: .month) {
            self.dateString = date.string(format: "MMMM d")
        }
        else if NSCalendar.current.isDate(date, equalTo: Date(), toGranularity: .year) {
            self.dateString = date.string(format: "MMMM d")
        }
        else {
            self.dateString = date.string(format: "MMMM d, y")
        }
        let size = self.dateString.size(size: CGSize(width: SCREEN_WIDTH, height: 100), font: GXCHATC.headerTextFont)
        self.dateSize = CGSize(width: size.width + GXCHATC.timeFont.lineHeight, height: size.height + 4.0)
    }
    
    public func isSameDay(date: Date) -> Bool {
        return NSCalendar.current.isDate(self.currentDate, inSameDayAs: date)
    }
    
    public func append(item: GXMessagesItemLayoutData) {
        self.items.append(item)
    }
    
    public func inset(item: GXMessagesItemLayoutData) {
        self.items.insert(item, at: 0)
    }
    
    public func remove(at index: Int) {
        guard index < self.items.count else { return }
        self.items.remove(at: index)
    }

}
