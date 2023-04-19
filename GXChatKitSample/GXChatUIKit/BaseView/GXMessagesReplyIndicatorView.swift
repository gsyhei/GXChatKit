//
//  GXMessagesReplyIndicatorView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/18.
//

import UIKit

public class GXMessagesReplyIndicatorView: UIView {
    
    public var lineWidth: CGFloat = 4.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var progress: CGFloat = 0 {
        didSet {
            self.alpha = self.progress
            self.setNeedsDisplay()
        }
    }
    
    /// reply icon
    public lazy var replyIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.image = .gx_replyIconImage?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white

        return imageView
    }()
    
    public lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(displayLinkTick(link:)))
        if #available(iOS 15.0, *) {
            link.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
        } else {
            link.preferredFramesPerSecond = 60
        }
        return link
    }()
    
    public lazy var linkSpeed: CGFloat = {
        return (self.frame.width/2 * SCREEN_SCALE - 4.0) / 30
    }()
    
    deinit {
        self.displayLink.invalidate()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createSubviews() {
        self.backgroundColor = UIColor.systemBlue
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.replyIconView.frame = self.bounds.insetBy(dx: 10.0, dy: 10.0)
        self.addSubview(replyIconView)
        
        self.progress = 1.0
    }
    
    public func startAnimation() {
        self.lineWidth = 4.0
        self.displayLink.add(to: RunLoop.main, forMode: .common)
    }

    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(UIColor.systemGreen.cgColor)
        context?.setLineCap(.butt)
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = rect.height / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi * self.progress
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(path.cgPath)
        context?.strokePath()
    }

    @objc func displayLinkTick(link: CADisplayLink) {
        self.lineWidth += self.linkSpeed
        if self.lineWidth >= self.frame.width/2 * SCREEN_SCALE {
            link.remove(from: RunLoop.main, forMode: .common)
        }
    }
}
