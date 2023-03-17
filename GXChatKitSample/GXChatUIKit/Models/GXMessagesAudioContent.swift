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
    
    public var displaySize: CGSize = .zero
    
    public var duration: Int = 0

    public var trackCount: Int = 0

    public var audioSize: CGSize = .zero

    public var trackList: [Int]?
    
    public required init(audioURL: URL? = nil) {
        self.audioURL = audioURL
    }
    
    public required init(fileURL: URL? = nil) {
        self.updateTime(fileURL: fileURL)
    }
    
    public func updateTime(fileURL: URL?) {
        self.fileURL = fileURL
        if let url = fileURL {
            let asset = AVAsset(url: url)
            if #available(iOS 15.0, *) {
                Task {
                    let time = try? await asset.load(.duration)
                    guard let letTime = time else { return }
                    let letDuration = (letTime.value + CMTimeValue(letTime.timescale)) / CMTimeValue(letTime.timescale)
                    self.duration = Int(letDuration)
                }
            }
            else {
                let time = asset.duration
                let letDuration = (time.value + CMTimeValue(time.timescale)) / CMTimeValue(time.timescale)
                self.duration = Int(letDuration)
            }
        }
    }
    
    public func updateAudioTracks(completion: @escaping (([Int], GXMessagesAudioContent) -> Void)) {
        if let tracks = self.trackList {
            completion(tracks, self); return
        }
        guard let url = self.fileURL else {
            completion([], self); return
        }
        let asset = AVAsset(url: url)
        let maxHeight = self.audioSize.height - GXChatConfiguration.shared.audioMinHeight
        GXAudioManager.gx_cutAudioTrackList(asset: asset, count: self.trackCount, height: maxHeight) { list in
            self.trackList = list
            completion(list, self)
        }
    }
    
}
