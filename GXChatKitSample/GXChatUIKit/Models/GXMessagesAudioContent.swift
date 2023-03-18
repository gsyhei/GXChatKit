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
    
    // MARK: - 实时音频数据
    
    /// 音轨视图尺寸
    public var audioSize: CGSize = .zero
    /// 持续时间
    public var duration: Int = 0
    /// 音轨数组
    public var tracks: [Int]?
    /// 是否正在播放
    public var isPlaying: Bool = false
    /// 当前动画count
    public var currentPlayIndex: Int = 0
    /// 当前播放时间
    public var currentPlayDuration: Int = 0
    
    public required init(audioURL: URL?, duration: Int, tracks: [Int]) {
        self.audioURL = audioURL
        self.duration = duration
        self.tracks = tracks
    }
    
    public required init(fileURL: URL?, duration: Int, tracks: [Int]) {
        self.fileURL = fileURL
        self.duration = duration
        self.tracks = tracks
    }
    
}
