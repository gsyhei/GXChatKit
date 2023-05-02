//
//  GXMessagesFileContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/7.
//

import UIKit

public class GXMessagesFileContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentData
    
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 本地文件地址
    public var fileUrl: URL?
    /// 下载地址
    public var downloadUrl: URL?
    /// 文件名
    public var fileName: String
    /// 扩展名
    public var fileExt: String?

    public required init(fileUrl: URL) {
        self.fileUrl = fileUrl
        self.fileName = fileUrl.lastPathComponent
        self.fileExt = fileUrl.pathExtension.uppercased()
    }
    
    public required init(downloadUrl: URL) {
        self.downloadUrl = downloadUrl
        self.fileName = downloadUrl.lastPathComponent
        self.fileExt = downloadUrl.pathExtension.uppercased()
    }
    
}
