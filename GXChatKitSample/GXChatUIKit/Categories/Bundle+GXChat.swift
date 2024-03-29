//
//  NSBundle+GXChat.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import Foundation

public extension Bundle {
    
    class var gx_messagesBundle: Bundle {
        return Bundle(for: GXChatConfiguration.classForCoder())
    }
        
    class var gx_messagesAssetBundle: Bundle? {
        let bundleResourcePath: String = Bundle.gx_messagesBundle.resourcePath ?? ""
        let bundlePath = bundleResourcePath + "/GXChatUIKit.bundle"
        
        return Bundle(path: bundlePath)
    }

    class func gx_localizedString(key: String) -> String {
        guard let bundle = Bundle.gx_messagesAssetBundle else { return "" }
        
        return NSLocalizedString(key, tableName: "GXMessages", bundle: bundle, comment: "")
    }
    
    class func gx_bundleEmojiJson() -> Array<Dictionary<String, Any>>? {
        let bundle = Bundle.gx_messagesAssetBundle
        let emojiPath = bundle?.path(forResource: "emoji", ofType: "plist")
        guard let path = emojiPath else { return nil }
        guard let data = NSData(contentsOfFile: path) else { return nil }
        
        return Array.arrayWithPlistData(data as Data)
    }
    
    
//    NSString * emojiPath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"plist"];
//    NSArray *array = [NSArray arrayWithContentsOfFile:filepath];
}
