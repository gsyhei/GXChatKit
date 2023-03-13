//
//  GXMessagesVideoContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesVideoContent: GXMessagesContentData {
    /// 下载地址
    private(set) var videoURL: NSURL?
    /// 缩略图下载地址
    private(set) var thumbnailImageURL: NSURL?
    /// 本地存储地址
    private(set) var fileURL: NSURL?
    /// 缩略图
    private(set) var thumbnailImage: UIImage?
        
    public var mediaView: UIView?
    
    public var mediaPlaceholderView: UIView?
    
    public var displaySize: CGSize = CGSizeZero
    
    public required init(thumbnailImageURL: NSURL, videoURL: NSURL? = nil, displaySize: CGSize) {
        self.thumbnailImageURL = thumbnailImageURL
        self.videoURL = videoURL
        self.displaySize = displaySize
    }
    
    public required init(thumbnailImage: UIImage?, fileURL: NSURL? = nil) {
        self.thumbnailImage = thumbnailImage
        self.fileURL = fileURL
        self.displaySize = thumbnailImage?.size ?? .zero
    }
}
