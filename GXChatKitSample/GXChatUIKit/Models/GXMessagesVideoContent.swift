//
//  GXMessagesVideoContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

class GXMessagesVideoContent: GXMessagesContentData {
    /// 下载地址
    private(set) var videoURL: NSURL?
    /// 缩略图下载地址
    private(set) var thumbnailImageURL: NSURL?
    /// 本地存储地址
    private(set) var fileURL: NSURL?
    /// 缩略图
    private(set) var thumbnailImage: UIImage?
    
    public var text: String? = nil
    
    public var mediaView: UIView?
    
    public var mediaPlaceholderView: UIView?
    
    public var displaySize: CGSize = CGSizeZero
    
    public required init(thumbnailImageURL: NSURL, videoURL: NSURL) {
        self.thumbnailImageURL = thumbnailImageURL
        self.videoURL = videoURL
    }
    
    public required init(thumbnailImage: UIImage, fileURL: NSURL) {
        self.thumbnailImage = thumbnailImage
        self.fileURL = fileURL
    }
}
