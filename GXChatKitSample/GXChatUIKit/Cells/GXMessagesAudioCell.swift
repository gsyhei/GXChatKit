//
//  GXMessagesAudioCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit

public class GXMessagesAudioCell: GXMessagesBaseCell {
    /// 语音音轨视图
    public weak var trackView: GXMessagesAudioTrackView?
    /// 播放按钮
    public lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(origin: .zero, size: GXChatConfiguration.shared.audioPlaySize)
        button.addTarget(self, action: #selector(playButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }()
    /// 文本Label
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = GXCHATC.timeFont
        
        return label
    }()
    /// 播放时间后面的点
    public lazy var dotView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSizeMake(4, 4)))
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.playButton)
        self.messageBubbleContainerView.addSubview(self.timeLabel)
        self.messageBubbleContainerView.addSubview(self.dotView)
    }
    
    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        
        self.playButton.frame = CGRect(origin: item.contentRect.origin, size: GXChatConfiguration.shared.audioPlaySize)
        self.updatePlayButton(content: content)
        
        if let itemMediaView = content.mediaView as? GXMessagesAudioTrackView {
            self.messageBubbleContainerView.addSubview(itemMediaView)
            let left = self.playButton.right + 10.0, top = self.playButton.top + 10.0
            let rect = CGRect(x: left, y: top, width: content.audioSize.width, height: content.audioSize.height)
            itemMediaView.frame = rect
            self.trackView = itemMediaView
        }
        else {
            let left = self.playButton.right + 10.0, top = self.playButton.top + 10.0
            let rect = CGRect(x: left, y: top, width: content.audioSize.width, height: content.audioSize.height)
            let trackView = GXMessagesAudioTrackView(frame: rect)
            trackView.updateAudio(content: content, status: item.data.gx_messageStatus)
            self.messageBubbleContainerView.addSubview(trackView)
            self.trackView = trackView
            content.mediaView = trackView
        }
        let left = self.playButton.right + 10.0, top = self.playButton.frame.midY + 5.0
        self.timeLabel.text = String(format: "0:%02d", content.duration)
        self.timeLabel.frame = CGRect(x: left, y: top, width: 28.0, height: self.timeLabel.font.lineHeight)
        if item.data.gx_messageStatus == .sending {
            self.playButton.tintColor = GXChatConfiguration.shared.audioSendingTimeColor
            self.timeLabel.textColor = GXChatConfiguration.shared.audioSendingTimeColor
            self.dotView.backgroundColor = GXChatConfiguration.shared.audioSendingTimeColor
        }
        else {
            self.playButton.tintColor = GXChatConfiguration.shared.audioReceivingTimeColor
            self.timeLabel.textColor = GXChatConfiguration.shared.audioReceivingTimeColor
            self.dotView.backgroundColor = GXChatConfiguration.shared.audioReceivingTimeColor
        }
        self.dotView.left = self.timeLabel.right
        self.dotView.centerY = self.timeLabel.centerY
    }

    public func updatePlayButton(content: GXMessagesAudioContent) {
        if content.isPlaying {
            let image = UIImage(systemName: "pause.circle.fill")
            self.playButton.setBackgroundImage(image, for: .normal)
        }
        else {
            let image = UIImage(systemName: "play.circle.fill")
            self.playButton.setBackgroundImage(image, for: .normal)
        }
    }
}

extension GXMessagesAudioCell {
    @objc func playButtonClicked(_ sender: Any?) {
        guard let content = self.item?.data.gx_messagesContentData as? GXMessagesAudioContent else { return }

        content.isPlaying = !content.isPlaying
        self.updatePlayButton(content: content)
        if content.isPlaying {
            self.trackView?.gx_animation(completion: {[weak self] in
                content.isPlaying = false
                self?.updatePlayButton(content: content)
            })
        }
        else {
            self.trackView?.gx_animationPause()
        }
    }
}
