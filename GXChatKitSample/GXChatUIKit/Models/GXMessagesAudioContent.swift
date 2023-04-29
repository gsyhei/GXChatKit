//
//  GXMessagesAudioContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit
import AVFoundation

public class GXMessagesAudioContent: GXMessagesMediaContentProtocol {
    // MARK: - GXMessagesMediaContentProtocol
    
    /// 媒体视图
    public var mediaView: UIView?
    /// 媒体占位视图
    public var mediaPlaceholderView: UIView?
    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    
    /// 下载地址
    public var audioURL: URL?
    /// 本地存储地址
    public var fileURL: URL?
    
    // MARK: - 实时音频数据

    /// 持续时间
    public var duration: TimeInterval = 0
    /// 音轨数组
    public var tracks: [Int]?
    /// 是否正在播放
    public var isPlaying: Bool = false
    /// 单个音轨动画时长
    public var animateDuration: TimeInterval = 0
    /// 当前动画count
    public var currentPlayIndex: Int = 0
    /// 当前播放时间
    public var currentPlayDuration: TimeInterval = 0
    
    public required init(audioURL: URL?, duration: TimeInterval, tracks: [Int]) {
        self.audioURL = audioURL
        self.duration = duration
        self.tracks = tracks
    }
    
    public required init(fileURL: URL?, duration: TimeInterval, tracks: [Int]) {
        self.fileURL = fileURL
        self.duration = duration
        self.tracks = tracks
    }
    
}
