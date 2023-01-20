//
//  GXMessageMideaItem.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/15.
//

import UIKit

public class GXMessageItem: NSObject {
    
    private var data: GXMessagesData!
    
    public var dasdas: Int?

    public required init(data: GXMessagesData) {
        super.init()
        self.data = data
    }
    
    
}
