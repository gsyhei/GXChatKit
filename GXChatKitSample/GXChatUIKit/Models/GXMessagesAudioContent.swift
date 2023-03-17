//
//  GXMessagesAudioContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit
import AVFoundation

public class GXMessagesAudioContent: GXMessagesContentData {
    /// 下载地址
    private(set) var audioURL: URL?
    /// 本地存储地址
    private(set) var fileURL: URL?
        
    public var mediaView: UIView?
    
    public var mediaPlaceholderView: UIView?
    
    public var duration: Int = 0

    public var displaySize: CGSize = .zero
    
    public required init(audioURL: URL? = nil) {
        self.audioURL = audioURL
    }
    
    public required init(fileURL: URL? = nil) {
        self.update(fileURL: fileURL)
    }
    
    public func update(fileURL: URL?) {
        self.fileURL = fileURL
        if let url = fileURL {
            let asset = AVAsset(url: url)
            if #available(iOS 15.0, *) {
                Task {
                    let time = try? await asset.load(.duration)
                    guard let letTime = time else { return }
                    self.duration = Int(letTime.value / CMTimeValue(letTime.timescale))
                }
            }
            else {
                let time = asset.duration
                self.duration = Int(time.value / CMTimeValue(time.timescale))
            }
        }
    }
}
