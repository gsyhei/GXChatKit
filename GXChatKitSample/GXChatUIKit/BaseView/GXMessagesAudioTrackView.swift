//
//  GXMessagesAudioTrackView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/16.
//

import UIKit
import GXMessagesTableView

public class GXMessagesAudioTrackView: UIView {
    private var trackLayers: [CALayer] = []
    private var messageStatus: GXMessageStatus = .sending
    private weak var audioContent: GXMessagesAudioContent?
    private var timer: DispatchSourceTimer?

    /// 根据count获取到音频视图width
    public class func GetTrackViewWidth(count: Int) -> CGFloat {
        return CGFloat(count) * (GXChatConfiguration.shared.audioSpacing * GXChatConfiguration.shared.audioItemWidth)
    }
    
    public func updateAudio(content: GXMessagesAudioContent, status: GXMessageStatus) {
        self.audioContent = content
        self.messageStatus = status
        self.setupSubviews()
    }
}

public extension GXMessagesAudioTrackView {
    
    private func setupSubviews() {
        self.trackLayers.removeAll()
        self.removeAllSubviews()
        
        guard let content = self.audioContent else { return }
        guard let tracks = content.tracks else { return }
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
            if index < content.currentPlayIndex {
                if self.messageStatus == .sending {
                    layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeColor.cgColor
                } else {
                    layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeColor.cgColor
                }
            }
            else {
                if self.messageStatus == .sending {
                    layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeHighlightColor.cgColor
                } else {
                    layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeHighlightColor.cgColor
                }
            }
            self.layer.addSublayer(layer)
            self.trackLayers.append(layer)
        }
    }
    
    func gx_animationPause() {
        if let letTimer = self.timer {
            letTimer.cancel()
        }
    }

    func gx_animation(completion: (() -> Void)? = nil) {
        guard let content = self.audioContent else { return }
        
        let count = self.trackLayers.count
        if count == 0 { completion?(); return }
        
        let duration = Double(content.duration) / Double(count)
        let milliseconds: Int = Int(duration * 1000.0)
        
        let remainCount = count - content.currentPlayIndex
        self.timer = GXUtilManager.gx_countdownTimer(count: remainCount, milliseconds: milliseconds) { index in
            let currentPlayIndex = count - index - 1
            self.gx_layerAnimation(index: currentPlayIndex, duration: duration)
            content.currentPlayIndex = (index == 0) ? 0 : currentPlayIndex
        } completion: {
            content.currentPlayIndex = 0
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
