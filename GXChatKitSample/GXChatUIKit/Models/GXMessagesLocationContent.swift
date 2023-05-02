//
//  GXMessagesLocationContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/27.
//

import UIKit
import CoreLocation

public class GXMessagesLocationContent: GXMessagesMediaContentDelegate {
    // MARK: - GXMessagesMediaContentProtocol
    
    /// 媒体视图
    public var mediaView: UIView?
    /// 媒体占位视图
    public var mediaPlaceholderView: UIView?
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero

    /// 位置图
    public var locationImage: UIImage?
    /// 位置图下载地址
    public var locationImageURL: URL?
    /// 本地存储地址
    public var fileURL: URL?
    /// 坐标
    public var coordinate: CLLocationCoordinate2D
    /// 位置名称
    public var locationTitle: String
    
    public required init(coordinate: CLLocationCoordinate2D, locationTitle: String, locationImage: UIImage?, fileURL: URL? = nil) {
        self.coordinate = coordinate
        self.locationTitle = locationTitle
        if let image = locationImage {
            self.locationImage = image
            self.displaySize = image.size
        }
        else if let url = fileURL {
            self.fileURL = url
            self.locationImage = UIImage(contentsOfFile: url.absoluteString)
            self.displaySize = self.locationImage?.size ?? .zero
        }
    }

    public required init(coordinate: CLLocationCoordinate2D, locationTitle: String, locationImageURL: URL?, displaySize: CGSize) {
        self.coordinate = coordinate
        self.locationTitle = locationTitle
        self.locationImageURL = locationImageURL
        self.displaySize = displaySize
    }
    
}
