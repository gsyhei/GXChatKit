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
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func gx_updateAudio(content: GXMessagesAudioContent, status: GXMessageStatus) {
        self.audioContent = content
        self.messageStatus = status
        self.setupSubviews()
    }
    
    public func gx_layerAnimation(index: Int, animated: Bool) {
        guard index >= 0 && index < self.trackLayers.count    else { return }
        
        let layer = self.trackLayers[index]
        if animated {
            UIView.animate(withDuration: self.audioContent?.animateDuration ?? 0) {
                if self.messageStatus == .sending {
                    layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeColor.cgColor
                } else {
                    layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeColor.cgColor
                }
            }
        }
        else {
            if self.messageStatus == .sending {
                layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeColor.cgColor
            } else {
                layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeColor.cgColor
            }
        }
    }
    
    public func gx_resetTracksLayer() {
        self.trackLayers.forEach {[weak self] layer in
            if self?.messageStatus == .sending {
                layer.backgroundColor = GXChatConfiguration.shared.audioSendingTimeHighlightColor.cgColor
            } else {
                layer.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeHighlightColor.cgColor
            }
        }
    }
}

fileprivate extension GXMessagesAudioTrackView {
    
    private func setupSubviews() {
        self.trackLayers.removeAll()
        self.removeAllSubviews()
        
        guard let content = self.audioContent else { return }
        guard let tracks = content.tracks else { return }
        let count = tracks.count
        for index in 0..<count {
            let track = tracks[index]
            let maxTrackHeight = self.height - GXChatConfiguration.shared.audioMinHeight
            let trackScale = maxTrackHeight / GXChatConfiguration.shared.audioTrackMaxVakue
            let height = trackScale * CGFloat(track) + GXChatConfiguration.shared.audioMinHeight
            let top = self.height - height
            let width = GXChatConfiguration.shared.audioItemWidth
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
    
}
