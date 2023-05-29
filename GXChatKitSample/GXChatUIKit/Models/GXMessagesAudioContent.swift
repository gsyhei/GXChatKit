//
//  GXMessagesAudioContent.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit
import AVFoundation

public class GXMessagesAudioContent: GXMessagesContentDelegate {
    // MARK: - GXMessagesContentDelegate

    /// 显示区域尺寸
    public var displaySize: CGSize = .zero
    /// 缓存音轨视图
    public var trackView: UIView?
    /// 下载地址
    public var audioURL: URL?
    /// 本地存储地址
    public var fileURL: URL?
    
    // MARK: - 实时音频数据

    /// 持续时间
    public var duration: TimeInterval = 0
    /// 音轨数量
    public var trackCount: Int = 0
    /// 音轨数组
    public var tracks: [Int]?
    /// 是否正在播放
    public var isPlaying: Bool = false
    /// 播放速度
    public var rate: Float = 1.0
    /// 当前播放时间
    public var currentPlayDuration: TimeInterval = 0
    
    public required init(audioURL: URL?, duration: TimeInterval, tracks: [Int]? = nil) {
        self.audioURL = audioURL
        self.duration = duration
        self.tracks = tracks
    }
    
    public required init(fileURL: URL?, duration: TimeInterval, tracks: [Int]? = nil) {
        self.fileURL = fileURL
        self.duration = duration
        self.tracks = tracks
    }
    
}
