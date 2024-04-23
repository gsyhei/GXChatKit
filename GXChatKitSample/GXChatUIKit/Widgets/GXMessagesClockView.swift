//
//  GXMessagesClockView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/5/17.
//  Copyright © 2023 andyron. All rights reserved.
//

import UIKit

public class GXMessagesClockView: UIView {
    private let lineWidth: CGFloat = 1.5

    // 秒针
    private lazy var secondHand: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = GXCHATC.sendingTimeColor.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: self.lineWidth, height: 0)
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        return layer
    }()

    // 分针
    private lazy var minuteHand: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = GXCHATC.sendingTimeColor.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: self.lineWidth, height: 0)
        layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        
        return layer
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius = (frame.height - self.lineWidth*4) * 0.5
        let center = CGPoint(x: frame.width/2, y: frame.height/2)

        var secondRect = self.secondHand.frame
        secondRect.size.height = radius * 0.9
        self.secondHand.frame = secondRect
        
        var minuteRect = self.minuteHand.frame
        minuteRect.size.height = radius * 0.7
        self.minuteHand.frame = minuteRect

        self.secondHand.position = center
        self.minuteHand.position = center
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    
        self.layer.addSublayer(self.secondHand)
        self.layer.addSublayer(self.minuteHand)
        
        let secondAnimation = self.animationRotation(duration: 1.0)
        self.secondHand.add(secondAnimation, forKey: "secondAnimation")
        let minuteAnimation = self.animationRotation(duration: 6.0)
        self.minuteHand.add(minuteAnimation, forKey: "minuteAnimation")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func animationRotation(duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.001
        animation.toValue = Double.pi * 2.0
        animation.duration = duration
        animation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        
        return animation
    }
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(UIColor.systemGreen.cgColor)
        context?.setLineCap(.butt)
        let roundedRect = rect.insetBy(dx: self.lineWidth, dy: self.lineWidth)
        let radius = roundedRect.height / 2
        let path = UIBezierPath(roundedRect: roundedRect, cornerRadius: radius)
        context?.addPath(path.cgPath)
        context?.strokePath()
    }
}

extension GXMessagesClockView: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        NSLog("animationDidStart: \(anim)")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        NSLog("animationDidStop: \(anim), flag: \(flag)")
    }
}
