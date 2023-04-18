//
//  GXMessagesReplyIndicatorView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/18.
//

import UIKit

public class GXMessagesReplyIndicatorView: UIView {
    
    public var progress: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.systemBlue.cgColor)
        context?.setLineCap(.round)
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = rect.height / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + CGFloat.pi * self.progress
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(path.cgPath)
        context?.strokePath()
    }

}
