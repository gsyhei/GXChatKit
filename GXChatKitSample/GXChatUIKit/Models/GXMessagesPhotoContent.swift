//
//  GXMessagesImageContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesPhotoContent: GXMessagesContentData {
    /// 下载地址
    private(set) var imageURL: URL?
    /// 缩略图下载地址
    private(set) var thumbnailImageURL: URL?
    /// 本地存储地址
    private(set) var fileURL: URL?
    /// 缩略图
    private(set) var thumbnailImage: UIImage?
        
    public var mediaView: UIView?
    
    public var mediaPlaceholderView: UIView?
    
    public var displaySize: CGSize = .zero
    
    public required init(thumbnailImageURL: URL, imageURL: URL? = nil, displaySize: CGSize) {
        self.thumbnailImageURL = thumbnailImageURL
        self.imageURL = imageURL
        self.displaySize = displaySize
    }
    
    public required init(thumbnailImage: UIImage?, fileURL: URL? = nil) {
        self.thumbnailImage = thumbnailImage
        self.fileURL = fileURL
        self.displaySize = thumbnailImage?.size ?? .zero
    }
    
}
