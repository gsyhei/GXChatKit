//
//  GXMessagesAudioTrack.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/29.
//

import UIKit

public class GXMessagesAudioTrack: UIView {
    private var messageStatus: GXChatConfiguration.MessageStatus = .send
    private weak var audioContent: GXMessagesAudioContent?
    
    public var downBlock: GXActionBlock?
    public var changeBlock: GXActionBlockItem<TimeInterval>?

    private lazy var backLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
       return layer
    }()
    
    private lazy var maskBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.masksToBounds = true
       return view
    }()
    
    private lazy var maskSlider: GXMessagesSlider = {
        let slider = GXMessagesSlider()
        slider.value = 0
        slider.addTarget(self, action: #selector(maskSliderChange(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(maskSliderDown(_:)), for: .touchDown)
        return slider
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.addSublayer(self.backLayer)
        self.addSubview(self.maskSlider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.backLayer.frame = self.bounds
        self.maskSlider.frame = self.bounds
    }
    
    public func gx_updateAudio(content: GXMessagesAudioContent, status: GXChatConfiguration.MessageStatus) {
        self.audioContent = content
        self.messageStatus = status
        self.setupSubviews()
    }
    
    public func gx_resetPlayDuration() {
        if let content = self.audioContent, content.duration > 0 {
            var rect = self.bounds
            let width = content.currentPlayDuration/content.duration * self.frame.width
            rect.size.width = width
            self.maskSlider.value = Float(content.currentPlayDuration)
            self.maskBackView.frame = rect
        }
    }
}

fileprivate extension GXMessagesAudioTrack {
    
    private func setupSubviews() {
        self.addSubview(self.maskBackView)
        self.gx_resetPlayDuration()
        
        guard let content = self.audioContent else { return }
        self.maskSlider.minimumValue = 0
        self.maskSlider.maximumValue = Float(content.duration)

        guard let tracks = content.tracks else { return }
        let count = tracks.count
        for index in 0..<count {
            let track = tracks[index]
            let maxTrackHeight = self.height - GXCHATC.audioMinHeight
            let trackScale = maxTrackHeight / GXCHATC.audioTrackMaxVakue
            let height = trackScale * CGFloat(track) + GXCHATC.audioMinHeight
            let top = (self.height - height) * 0.5
            let width = GXCHATC.audioItemWidth
            let left = CGFloat(index) * (GXCHATC.audioSpacing + width)
            let frame = CGRect(x: left, y: top, width: width, height: height)
            
            let layer = CALayer()
            layer.frame = frame
            layer.masksToBounds = true
            layer.cornerRadius = width*0.5
            if self.messageStatus == .send {
                layer.backgroundColor = GXCHATC.audioSendingTimeHighlightColor.cgColor
            } else {
                layer.backgroundColor = GXCHATC.audioReceivingTimeHighlightColor.cgColor
            }
            self.backLayer.addSublayer(layer)
            
            let maskLayer = CALayer()
            maskLayer.frame = frame
            maskLayer.masksToBounds = true
            maskLayer.cornerRadius = width*0.5
            if self.messageStatus == .send {
                maskLayer.backgroundColor = GXCHATC.audioSendingTimeColor.cgColor
            } else {
                maskLayer.backgroundColor = GXCHATC.audioReceivingTimeColor.cgColor
            }
            self.maskBackView.layer.addSublayer(maskLayer)
        }
    }
    
    @objc func maskSliderChange(_ sender: UISlider) {
        guard let content = self.audioContent else { return }
        content.currentPlayDuration = TimeInterval(sender.value)
        self.gx_resetPlayDuration()        
        self.changeBlock?(content.duration - content.currentPlayDuration)
    }
    
    @objc func maskSliderDown(_ sender: UISlider) {
        self.downBlock?()
    }
    
}
