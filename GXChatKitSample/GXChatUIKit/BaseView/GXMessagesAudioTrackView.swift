//
//  GXMessagesAudioTrackView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/16.
//

import UIKit
import GXMessagesTableView

public class GXMessagesAudioTrackView: UIView {
    private var trackList: [Int]?
    private var trackLayers: [CALayer] = []
    private var trackDuration: Int = 0
    private var messageStatus: GXMessageStatus?

    /// 根据时长与最大宽度获取count
    public class func GetTrackMaxCount(maxWidth: CGFloat, time: Int) -> Int {
        let maxCount = maxWidth / (GXChatConfiguration.shared.audioSpacing * GXChatConfiguration.shared.audioItemWidth)
        let trackCount: Int = Int(maxCount / 60 * CGFloat(time))
        let minCount = max(trackCount, 10)
        
        return minCount
    }
    
    /// 根据count获取到音频视图width
    public class func GetTrackViewWidth(count: Int) -> CGFloat {
        return CGFloat(count) * (GXChatConfiguration.shared.audioSpacing * GXChatConfiguration.shared.audioItemWidth)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateTracks(trackList: [Int], duration: Int, status: GXMessageStatus?) {
        self.trackList = trackList
        self.trackDuration = duration
        self.messageStatus = status
        self.setupSubviews()
    }
    
}

public extension GXMessagesAudioTrackView {
    
    func setupSubviews() {
        self.trackLayers.removeAll()
        self.removeAllSubviews()
        
        guard let tracks = self.trackList else { return }
        let count = tracks.count
        for index in 0..<count {
            let track = tracks[index]
            let width = GXChatConfiguration.shared.audioItemWidth
            let height = CGFloat(track) + GXChatConfiguration.shared.audioMinHeight
            let top = self.height - height
            let left = CGFloat(index) * (GXChatConfiguration.shared.audioSpacing + width)
            let frame = CGRect(x: left, y: top, width: width, height: height)
            
            let layer = CALayer()
            layer.frame = frame
            if self.messageStatus == .sending {
                layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeHighlightColor.cgColor
            } else {
                layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeHighlightColor.cgColor
            }
            self.layer.addSublayer(layer)
            self.trackLayers.append(layer)
        }
    }

    func gx_animation(completion: (() -> Void)? = nil) {
        let count = self.trackLayers.count
        if count == 0 {
            completion?(); return
        }
        let duration = Double(self.trackDuration) / Double(count)
        let milliseconds: Int = Int(duration * 1000.0)
        GXUtilManager.gx_countdownTimer(count: count, milliseconds: milliseconds) { index in
            self.gx_layerAnimation(index: count - index - 1, duration: duration)
        } completion: {
            self.gx_resetTracksLayer()
            completion?()
        }
    }

    private func gx_layerAnimation(index: Int, duration: TimeInterval) {
        let layer = self.trackLayers[index]
        UIView.animate(withDuration: duration) {
            if self.messageStatus == .sending {
                layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeColor.cgColor
            } else {
                layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeColor.cgColor
            }
        }
    }
    
    private func gx_resetTracksLayer() {
        self.trackLayers.forEach {[weak self] layer in
            if self?.messageStatus == .sending {
                layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeHighlightColor.cgColor
            } else {
                layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeHighlightColor.cgColor
            }
        }
    }
}
