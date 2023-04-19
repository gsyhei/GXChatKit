//
//  GXMessagesReplyIndicatorView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/18.
//

import UIKit

public class GXMessagesReplyIndicatorView: UIView {
    
    public var isShowAnimated = false
    
    public var progress: CGFloat = 0 {
        didSet {
            self.alpha = self.progress
            let scale = 0.3 + self.progress * 0.7
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.setNeedsDisplay()
        }
    }
    
    private var lineWidth: CGFloat = GXCHATC.replyIndicatorLineWidth * SCREEN_SCALE {
        didSet {
            self.setNeedsDisplay()
        }
    }
        
    private lazy var replyIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.image = .gx_replyIconImage?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white

        return imageView
    }()
    
    private lazy var displayLink: CADisplayLink = {
        let link = CADisplayLink(target: self, selector: #selector(displayLinkTick(link:)))
        if #available(iOS 15.0, *) {
            link.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
        } else {
            link.preferredFramesPerSecond = 60
        }
        return link
    }()
    
    private lazy var linkSpeed: CGFloat = {
        let radius = (self.frame.width/2 - GXCHATC.replyIndicatorLineWidth) * SCREEN_SCALE
        
        return radius / (60.0 * 0.3)
    }()
    
    private lazy var generator: UIImpactFeedbackGenerator = {
        return UIImpactFeedbackGenerator(style: .heavy)
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
    
    private func createSubviews() {
        self.backgroundColor = GXCHATC.replyIndicatorbackgroudColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        self.replyIconView.frame = self.bounds.insetBy(dx: 10.0, dy: 10.0)
        self.addSubview(replyIconView)
    }
    
    public func reset() {
        self.progress = 0.0
        self.isShowAnimated = false
        self.lineWidth = GXCHATC.replyIndicatorLineWidth * SCREEN_SCALE
        self.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    }
    
    public func showAnimation() {
        guard !self.isShowAnimated else { return }
        self.isShowAnimated = true
        self.generator.impactOccurred()
        self.displayLink.add(to: RunLoop.main, forMode: .common)
    }

    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(GXCHATC.replyIndicatorCircularColor.cgColor)
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
