//
//  GXMessagesAudioCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/17.
//

import UIKit

public class GXMessagesAudioCell: GXMessagesBaseCell {

    /// 播放按钮
    public lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "play.circle")
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setBackgroundImage(image, for: .normal)
        
        return button
    }()
    /// 文本Label
    public lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        self.messageBubbleContainerView.addSubview(self.timeLabel)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }

        
    }

}
