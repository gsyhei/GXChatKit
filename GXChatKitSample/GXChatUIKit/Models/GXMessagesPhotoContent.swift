//
//  GXMessagesImageContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesPhotoContent: GXMessagesContentData {
    // MARK: - GXMessagesContentData
    
    /// 媒体视图
    public var mediaView: UIView?
    /// 媒体占位视图
    public var mediaPlaceholderView: UIView?
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 下载地址
    private(set) var imageURL: URL?
    /// 缩略图下载地址
    private(set) var thumbnailImageURL: URL?
    /// 本地存储地址
    private(set) var fileURL: URL?
    /// 缩略图
    private(set) var thumbnailImage: UIImage?
    
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
