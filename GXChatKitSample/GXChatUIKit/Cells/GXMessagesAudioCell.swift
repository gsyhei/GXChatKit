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
        button.backgroundColor = .clear
        button.frame = CGRect(origin: .zero, size: GXCHATC.audioPlaySize)
        button.addTarget(self, action: #selector(playButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }()
    /// 时长文本Label
    public lazy var audioTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        self.audioTimeLabel.text = nil
        self.trackView?.removeFromSuperview()
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.playButton)
        self.messageBubbleContainerView.addSubview(self.audioTimeLabel)
        self.messageBubbleContainerView.addSubview(self.dotView)
        self.addObserver()
    }
    
    public func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlay), name: GXAudioManager.audioPlayNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioStop), name: GXAudioManager.audioStopNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPause), name: GXAudioManager.audioPauseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioPlayProgress), name: GXAudioManager.audioPlayProgressNotification, object: nil)
    }
    
    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        guard let layout = item.layout as? GXMessagesAudioLayout else { return }

        self.playButton.frame = CGRect(origin: layout.playButtonRect.origin, size: GXCHATC.audioPlaySize)
        self.gx_updatePlayButton(content: content)

        if let itemMediaView = content.mediaView as? GXMessagesAudioTrackView {
            self.messageBubbleContainerView.addSubview(itemMediaView)
            self.trackView = itemMediaView
        }
        else {
            let trackView = GXMessagesAudioTrackView(frame: layout.audioTrackRect)
            trackView.gx_updateAudio(content: content, status: item.data.gx_messageStatus)
            self.messageBubbleContainerView.addSubview(trackView)
            content.mediaView = trackView
            self.trackView = trackView
        }
        self.audioTimeLabel.text = String(format: "0:%02d", Int(content.duration - content.currentPlayDuration))
        self.audioTimeLabel.frame = layout.audioTimeRect
        if item.data.gx_messageStatus == .sending {
            self.dotView.backgroundColor = GXCHATC.audioSendingTimeColor
            self.playButton.tintColor = GXCHATC.audioSendingTimeColor
            self.audioTimeLabel.textColor = GXCHATC.audioSendingTimeColor
        }
        else {
            self.dotView.backgroundColor = GXCHATC.audioReceivingTimeColor
            self.playButton.tintColor = GXCHATC.audioReceivingTimeColor
            self.audioTimeLabel.textColor = GXCHATC.audioReceivingTimeColor
        }
        self.dotView.left = self.audioTimeLabel.right
        self.dotView.centerY = self.audioTimeLabel.centerY
        
        if content.isPlaying {
            self.trackView?.gx_layerAnimation(index: content.currentPlayIndex - 1, animated: false)
            self.gx_playAudio(isPlay: true)
        }
    }
}

extension GXMessagesAudioCell {
    
    private func gx_updatePlayButton(content: GXMessagesAudioContent) {
        if content.isPlaying {
            let image = UIImage(systemName: "pause.circle.fill")
            self.playButton.setBackgroundImage(image, for: .normal)
        }
        else {
            let image = UIImage(systemName: "play.circle.fill")
            self.playButton.setBackgroundImage(image, for: .normal)
        }
    }
    
    private func gx_playAudio(isPlay: Bool) {
        if isPlay {
            GXAudioManager.shared.playAudio(item: self.item)
        }
        else {
            GXAudioManager.shared.pauseAudio()
        }
    }
    
    //MARK: - UIButton Clicked
    
    @objc func playButtonClicked(_ sender: Any?) {
        guard let content = self.item?.data.gx_messagesContent as? GXMessagesAudioContent else { return }

        self.playButton.isUserInteractionEnabled = false
        self.gx_playAudio(isPlay: !content.isPlaying)
        self.playButton.isUserInteractionEnabled = true
    }

    //MARK: - NSNotification
    
    @objc func audioPlay(notification: NSNotification) {
        guard let notiItem = notification.object as? GXMessagesItemData else { return }
        guard notiItem == self.item else { return }
        guard let content = notiItem.data.gx_messagesContent as? GXMessagesAudioContent else { return }

        self.gx_updatePlayButton(content: content)
    }
    
    @objc func audioStop(notification: NSNotification) {
        guard let notiItem = notification.object as? GXMessagesItemData else { return }
        guard notiItem == self.item else { return }
        guard let content = notiItem.data.gx_messagesContent as? GXMessagesAudioContent else { return }

        self.gx_updatePlayButton(content: content)
        self.audioTimeLabel.text = String(format: "0:%02d", Int(content.duration - content.currentPlayDuration))
        self.trackView?.gx_resetTracksLayer()
    }
    
    @objc func audioPause(notification: NSNotification) {
        guard let notiItem = notification.object as? GXMessagesItemData else { return }
        guard notiItem == self.item else { return }
        guard let content = notiItem.data.gx_messagesContent as? GXMessagesAudioContent else { return }

        self.gx_updatePlayButton(content: content)
        self.audioTimeLabel.text = String(format: "0:%02d", Int(content.duration - content.currentPlayDuration))
    }
    
    @objc func audioPlayProgress(notification: NSNotification) {
        guard let notiItem = notification.object as? GXMessagesItemData else { return }
        guard notiItem == self.item else { return }
        guard let content = notiItem.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        
        self.audioTimeLabel.text = String(format: "0:%02d", Int(content.duration - content.currentPlayDuration))
        self.trackView?.gx_layerAnimation(index: (content.currentPlayIndex - 1), animated: true)
    }
    
}
