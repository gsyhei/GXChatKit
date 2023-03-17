//
//  GXMessagesTextContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesTextContent: GXMessagesContentData {
    
    public var text: String
    
    public var mediaView: UIView? = nil
    
    public var mediaPlaceholderView: UIView? = nil
    
    public var displaySize: CGSize = .zero
    
    public required init(text: String) {
        self.text = text
    }
}
   
