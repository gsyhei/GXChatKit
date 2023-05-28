//
//  GXMessagesSlider.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/29.
//

import UIKit

class GXMessagesSlider: UISlider {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.minimumTrackTintColor = .clear
        self.maximumTrackTintColor = .clear
        self.thumbTintColor = .systemBlue
        self.setThumbImage(.gx_circleFillImage, for: .normal)
        self.setThumbImage(.gx_circleFillImage, for: .highlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var frame = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let current = value / self.maximumValue
        frame.origin.x = bounds.width * CGFloat(current) - frame.width/2
        
        return frame
    }
}
