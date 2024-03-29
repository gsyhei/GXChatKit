//
//  GXMessagesImageContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/16.
//

import UIKit

public class GXMessagesPhotoContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentDelegate

    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 下载地址
    public var imageURL: URL?
    /// 缩略图下载地址
    public var thumbnailImageURL: URL?
    /// 本地存储地址
    public var fileURL: URL?
    /// 缩略图
    public var thumbnailImage: UIImage?
    
    public required init(thumbnailImageURL: URL, imageURL: URL? = nil, displaySize: CGSize) {
        self.thumbnailImageURL = thumbnailImageURL
        self.imageURL = imageURL
        self.displaySize = displaySize
    }
    
    public required init(thumbnailImage: UIImage?, fileURL: URL? = nil) {
        if let image = thumbnailImage {
            self.thumbnailImage = image
            self.displaySize = image.size
        }
        else if let url = fileURL {
            self.fileURL = url
            self.thumbnailImage = UIImage(contentsOfFile: url.absoluteString)
            self.displaySize = self.thumbnailImage?.size ?? .zero
        }
    }
    
}
