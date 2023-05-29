//
//  GXMessagesAudioCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit
import AVFoundation

public class GXMessagesAudioCell: GXMessagesBaseCell {
    public override func copy(with zone: NSZone? = nil) -> Any {
        let cell = type(of: self).init(frame: self.frame)
        if let nonullItem = self.item {
            cell.updateCell(item: nonullItem, isCacheTrack: false)
            cell.gx_updateAudioTrack()
        }
        return cell
    }
    /// 语音音轨视图
    public weak var trackView: GXMessagesAudioTrack?
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
        self.updateCell(item: item, isCacheTrack: true)
    }
    
    public func updateCell(item: GXMessagesItemData, isCacheTrack: Bool) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        guard let layout = item.layout as? GXMessagesAudioLayout else { return }

        self.playButton.frame = CGRect(origin: layout.playButtonRect.origin, size: GXCHATC.audioPlaySize)
        self.gx_updatePlayButton(content: content)
        if isCacheTrack {
            if let itemMediaView = content.trackView as? GXMessagesAudioTrack {
                self.messageBubbleContainerView.addSubview(itemMediaView)
                self.trackView = itemMediaView
            }
            else {
                let trackView = GXMessagesAudioTrack(frame: layout.audioTrackRect)
//                trackView.gx_updateAudio(content: content, status: item.data.gx_messageStatus)
                self.messageBubbleContainerView.addSubview(trackView)
                content.trackView = trackView
                self.trackView = trackView
            }
        }
        else {
            let trackView = GXMessagesAudioTrack(frame: layout.audioTrackRect)
//            trackView.gx_updateAudio(content: content, status: item.data.gx_messageStatus)
            self.messageBubbleContainerView.addSubview(trackView)
            self.trackView = trackView
        }
        self.audioTimeLabel.text = String(format: "0:%02d", Int(content.duration - content.currentPlayDuration))
        self.audioTimeLabel.frame = layout.audioTimeRect
        if item.data.gx_messageStatus == .send {
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
        
        self.trackView?.downBlock = {[weak self] in
            guard let `self` = self else { return }
            self.gx_playAudio(isPlay: false)
        }
        self.trackView?.changeBlock = {[weak self] time in
            guard let `self` = self else { return }
            self.audioTimeLabel.text = String(format: "0:%02d", Int(time))
        }
        if content.isPlaying {
            self.trackView?.gx_resetPlayDuration()
            self.gx_playAudio(isPlay: true)
        }
        
        self.gx_updateAudioTrack()
    }
    
    public func gx_playAudio(isPlay: Bool) {
        self.playButton.isUserInteractionEnabled = false
        if isPlay {
            GXAudioManager.shared.playAudio(item: self.item)
        }
        else {
            GXAudioManager.shared.pauseAudio()
        }
        self.playButton.isUserInteractionEnabled = true
    }
    
    public func gx_updateAudioTrack() {
        guard let content = self.item?.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        guard content.tracks == nil else { return }
        guard let fileUrl = content.fileURL else { return }

        let asset = AVAsset(url: fileUrl)
        GXUtilManager.gx_cutAudioTrackList(asset: asset, count: content.trackCount, height: GXCHATC.audioTrackMaxVakue) {[weak self] tracks in
            guard let `self` = self else { return }
            guard let currentContent = self.item?.data.gx_messagesContent as? GXMessagesAudioContent else { return }
            currentContent.tracks = tracks
            guard let messageStatus = self.item?.data.gx_messageStatus else { return }
            self.trackView?.gx_updateAudio(content: currentContent, status: messageStatus)
        }
    }
}

extension GXMessagesAudioCell {
    
    private func gx_updatePlayButton(content: GXMessagesAudioContent) {
        if content.isPlaying {
            self.playButton.setBackgroundImage(.gx_audioPauseImage, for: .normal)
        }
        else {
            self.playButton.setBackgroundImage(.gx_audioPlayImage, for: .normal)
        }
    }
    
    //MARK: - UIButton Clicked
    
    @objc func playButtonClicked(_ sender: Any?) {
        self.delegate?.messagesCell(self, didContentTapAt: self.item)
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
        self.trackView?.gx_resetPlayDuration()
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
        self.trackView?.gx_resetPlayDuration()
    }
    
}
