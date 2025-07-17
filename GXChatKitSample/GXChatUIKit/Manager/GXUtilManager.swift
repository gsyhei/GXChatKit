//
//  GXUtilManager.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/16.
//

import UIKit
import AVFoundation
import MediaPlayer

public class GXUtilManager: NSObject {    
    /// 倒计时
    /// - Parameters:
    ///   - count: 倒计时计数
    ///   - milliseconds: 毫秒
    ///   - handler: 倒计时回调
    ///   - completion: 完成回调
    /// - Returns: 计时器对象
    class func gx_countdownTimer(count: Int, handler: ((Int) -> Void)? = nil, completion: (() -> Void)? = nil) -> DispatchSourceTimer {
        // 定义需要计时的时间
        var timeCount: Int = count
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(wallDeadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 每秒计时一次
            timeCount -= 1
            // 时间到了取消时间源
            if timeCount <= 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    completion?()
                }
            }
            else {
                DispatchQueue.main.async {
                    handler?(timeCount)
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
        
        return codeTimer
    }
    
    /// 时间格式化
    /// - Parameter duration: 持续时间
    /// - Returns: 格式化字符串
    public class func gx_timeString(duration: Int) -> String {
        let hour   = duration / 3600
        let minute = duration / 60 % 60
        let second = duration % 60
        if hour > 0 {
            return String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        else {
            return String(format: "%02d:%02d", minute, second)
        }
    }
    
    /// 重设图片尺寸
    /// - Parameters:
    ///   - size: 实际size
    ///   - maxSize: 最大size
    /// - Returns: 重设后的size
    public class func gx_imageResize(size: CGSize, maxSize: CGSize) -> CGSize {
        if size.width < maxSize.width && size.height < maxSize.height {
            return size
        }
        let scaleW = maxSize.width/size.width, scaleH = maxSize.height/size.height
        let resizeScale = min(min(scaleW, scaleH), 1.0)
        let resize = CGSize(width: size.width * resizeScale, height: size.height * resizeScale)
        if resize.width < 40.0 { // 最小宽度40.0
            var height = (40.0 / maxSize.width) * size.height
            height = min(height, maxSize.height)
            
            return CGSize(width: 40.0, height: height)
        }
        
        return resize
    }
    
    /// 按需获取音频数据音轨缩放数组
    /// - Parameters:
    ///   - url: 音频
    ///   - sampleCount: 音轨数据缩放大小
    /// - Returns: 音轨数组 0~1
    public class func gx_getSimplifiedWaveform(from url: URL, sampleCount: Int) -> [Float]? {
        let asset = AVAsset(url: url)
        guard let assetTrack = asset.tracks(withMediaType: .audio).first else { return nil }
        
        let assetReader: AVAssetReader
        do {
            assetReader = try AVAssetReader(asset: asset)
        } catch {
            print("Error initializing asset reader: \(error)")
            return nil
        }
        
        let outputSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false
        ]
        
        let assetReaderOutput = AVAssetReaderTrackOutput(track: assetTrack, outputSettings: outputSettings)
        assetReader.add(assetReaderOutput)
        
        assetReader.startReading()
        
        var audioSamples: [Float] = []
        
        while let sampleBuffer = assetReaderOutput.copyNextSampleBuffer() {
            guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else { continue }
            
            var lengthAtOffset: Int = 0
            var totalLength: Int = 0
            var dataPointer: UnsafeMutablePointer<Int8>?
            
            CMBlockBufferGetDataPointer(blockBuffer, atOffset: 0, lengthAtOffsetOut: &lengthAtOffset, totalLengthOut: &totalLength, dataPointerOut: &dataPointer)
            
            let sampleCount = totalLength / MemoryLayout<Int16>.size
            let buffer = UnsafeBufferPointer(start: UnsafePointer<Int16>(OpaquePointer(dataPointer)), count: sampleCount)
            
            for sample in buffer {
                audioSamples.append(Float(sample) / Float(Int16.max))
            }
        }
        
        guard !audioSamples.isEmpty else { return nil }
        
        // 计算采样步长
        let step = max(audioSamples.count / sampleCount, 1)
        
        // 取样并归一化
        var simplifiedSamples = [Float]()
        for i in stride(from: 0, to: audioSamples.count, by: step) {
            let segment = audioSamples[i..<min(i + step, audioSamples.count)]
            let rms = sqrt(segment.map { $0 * $0 }.reduce(0, +) / Float(segment.count))
            simplifiedSamples.append(rms)
        }
        
        // 归一化到0-1范围
        guard let maxSample = simplifiedSamples.max(), maxSample > 0 else { return nil }
        let normalizedSamples = simplifiedSamples.map { $0 / maxSample }
        
        return normalizedSamples
    }
    
}
