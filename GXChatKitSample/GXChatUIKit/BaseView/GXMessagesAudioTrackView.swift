//
//  GXMessagesAudioTrackView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/16.
//

import UIKit

public class GXMessagesAudioTrackView: UIView {
    private static var spacing: CGFloat = 2.0
    private static var itemWidth: CGFloat = 3.0
    private static var minHeight: CGFloat = 2.0

    private var trackList: [Int]
    private var trackLayers: [CALayer] = []

    /// 根据时长与最大宽度获取count
    public class func GetTrackMaxCount(maxWidth: CGFloat, time: TimeInterval) -> Int {
        let maxCount = maxWidth / (spacing * itemWidth)
        let trackCount: Int = Int(maxCount / 60 * time)
        let minCount = max(trackCount, 10)
        
        return minCount
    }
    
    /// 根据count获取到音频视图width
    public class func GetTrackViewWidth(count: Int) -> CGFloat {
        return CGFloat(count) * (spacing * itemWidth)
    }

    public required init(frame: CGRect, trackList: [Int]) {
        self.trackList = trackList
        super.init(frame: frame)
        self.setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {}
}

public extension GXMessagesAudioTrackView {
    
    func setupSubviews() {
        self.trackLayers.removeAll()
        self.removeAllSubviews()
        
        let count = self.trackList.count
        for index in 0..<count {
            let track = self.trackList[index]
            let width = GXMessagesAudioTrackView.itemWidth
            let height = CGFloat(track) + GXMessagesAudioTrackView.minHeight
            let top = self.height - height
            let left = CGFloat(index) * (GXMessagesAudioTrackView.spacing + width)
            let frame = CGRect(x: left, y: top, width: width, height: height)
            
            let layer = CALayer()
            layer.frame = frame
            layer.backgroundColor = UIColor.red.cgColor
            self.layer.addSublayer(layer)
            self.trackLayers.append(layer)
        }
    }

    func gx_animation(time: TimeInterval, completion: (() -> Void)? = nil) {
        let count = self.trackLayers.count
        let duration = time / Double(count)
        let milliseconds: Int = Int(duration * 1000.0)
        GXUtilManager.gx_countdownTimer(count: count, milliseconds: milliseconds) { index in
            self.gx_layerAnimation(index: count - index - 1, duration: duration)
        } completion: {
            completion?()
        }
    }
    
    func gx_layerAnimation(index: Int, duration: TimeInterval) {
        let layer = self.trackLayers[index]
        UIView.animate(withDuration: duration) {
            layer.backgroundColor = UIColor.orange.cgColor
        }
    }
}
