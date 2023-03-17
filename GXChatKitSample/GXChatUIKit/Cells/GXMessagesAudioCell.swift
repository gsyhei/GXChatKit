//
//  GXMessagesAudioCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit

public class GXMessagesAudioCell: GXMessagesBaseCell {

    /// 语音音轨视图
    public var trackView: GXMessagesAudioTrackView?
    /// 播放按钮
    public lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "play.circle.fill")
        button.frame = CGRect(origin: .zero, size: GXChatConfiguration.shared.audioPlaySize)
        button.setBackgroundImage(image, for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(playButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }()
    /// 文本Label
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = GXCHATC.timeFont

        return label
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
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        self.playButton.frame = CGRect(origin: item.contentRect.origin, size: GXChatConfiguration.shared.audioPlaySize)
        
        if let itemMediaView = content.mediaView as? GXMessagesAudioTrackView {
            self.messageBubbleContainerView.addSubview(itemMediaView)
            let left = self.playButton.right + 10.0, top = self.playButton.top + 10.0
            let rect = CGRect(x: left, y: top, width: content.audioSize.width, height: content.audioSize.height)
            itemMediaView.frame = rect
            self.trackView = itemMediaView
        }
        else {
            content.updateAudioTracks { trackList,audio  in
                let left = self.playButton.right + 10.0, top = self.playButton.top + 10.0
                let rect = CGRect(x: left, y: top, width: content.audioSize.width, height: content.audioSize.height)
                let trackView = GXMessagesAudioTrackView(frame: rect)
                trackView.updateTracks(trackList: trackList, duration: content.duration, status: item.data.gx_messageStatus)
                self.messageBubbleContainerView.addSubview(trackView)
                self.trackView = trackView
                audio.mediaView = trackView
            }
        }
        
        let left = self.playButton.right + 10.0, top = self.playButton.frame.midY + 5.0
        self.timeLabel.text = String(format: "0:%02d", content.duration)
        self.timeLabel.frame = CGRect(x: left, y: top, width: content.audioSize.width, height: self.timeLabel.font.lineHeight)
        if item.data.gx_messageStatus == .sending {
            self.timeLabel.textColor = GXChatConfiguration.shared.audioSendingTimeColor
        }
        else {
            self.timeLabel.textColor = GXChatConfiguration.shared.audioReceivingTimeColor
        }
    }

}

extension GXMessagesAudioCell {
    @objc func playButtonClicked(_ sender: Any?) {
        self.trackView?.gx_animation(completion: {
            
        })
    }
}
