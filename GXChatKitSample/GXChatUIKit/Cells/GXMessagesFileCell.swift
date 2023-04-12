//
//  GXMessagesFileCell.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/7.
//

import UIKit

public class GXMessagesFileCell: GXMessagesBaseCell {
    /// 文件icon
    public lazy var fileIconIView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.image = .gx_fileIconImage?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = GXCHATC.fileIconColor
        
        return imageView
    }()
    /// 文件扩展名Label
    public lazy var fileExtLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.font = GXCHATC.fileExtFont
        label.textColor = GXCHATC.fileExtColor

        return label
    }()
    /// 文件名Label
    public lazy var fileNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = GXCHATC.fileNameFont
        label.textColor = GXCHATC.fileNameColor

        return label
    }()
    /// 线条
    public lazy var fileLineView: UIView = {
        let view = UIView(frame: .zero)
        view.alpha = 0.3
        
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
        
        self.fileExtLabel.text = nil
        self.fileNameLabel.text = nil
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.messageBubbleContainerView.addSubview(self.fileIconIView)
        self.messageBubbleContainerView.addSubview(self.fileExtLabel)
        self.messageBubbleContainerView.addSubview(self.fileNameLabel)
        self.messageBubbleContainerView.addSubview(self.fileLineView)
    }

    public override func bindCell(item: GXMessagesItemData) {
        super.bindCell(item: item)
        self.fileLineView.backgroundColor = self.messageBubbleTimeLabel.textColor
        
        guard let layout = item.layout as? GXMessagesFileLayout else { return }
        self.fileNameLabel.frame = layout.fileNameRect
        self.fileIconIView.frame = layout.fileIconRect
        self.fileExtLabel.frame = layout.fileExtRect
        self.fileLineView.frame = layout.fileLineRect
        
        guard let content = item.data.gx_messagesContent as? GXMessagesFileContent else { return }
        self.fileNameLabel.text = content.fileName
        self.fileExtLabel.text = content.fileExt
    }
}
