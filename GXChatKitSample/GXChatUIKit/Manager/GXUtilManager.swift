//
//  GXUtilManager.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/16.
//

import UIKit
import AVFoundation

public class GXUtilManager: NSObject {    
    /// 倒计时
    /// - Parameters:
    ///   - count: 倒计时计数
    ///   - milliseconds: 毫秒
    ///   - handler: 倒计时回调
    ///   - completion: 完成回调
    /// - Returns: 计时器对象
    class func gx_countdownTimer(count: Int, milliseconds:
                                 Int, handler: ((Int) -> Void)? = nil,
                                 completion: (() -> Void)? = nil) -> DispatchSourceTimer
    {
        // 定义需要计时的时间
        var timeCount: Int = count
        // 在global线程里创建一个时间源
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.schedule(wallDeadline: .now(), repeating: .milliseconds(milliseconds))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {
            // 每秒计时一次
            timeCount -= 1
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                handler?(timeCount)
            }
            // 时间到了取消时间源
            if timeCount <= 0 {
                codeTimer.cancel()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion?()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
        
        return codeTimer
    }
    
    /// 按需获取音频数据音轨缩放数组
    /// - Parameters:
    ///   - asset: 音频
    ///   - count: 音轨数据缩放大小
    ///   - height: 缩放高度最大值
    ///   - completion: 结果回调
    public class func gx_cutAudioTrackList(asset: AVAsset, count: Int, height: CGFloat, completion: @escaping (([Int]) -> Void)) {
        GXUtilManager.gx_assetTrack(asset: asset) { track in
            GXUtilManager.gx_recorderData(asset: asset, assetTrack: track, completion: { data in
                let audioList = GXUtilManager.gx_filterAudioData(count: count, height: height, audioData: data)
                DispatchQueue.main.async {
                    completion(audioList)
                }
            })
        }
    }

}

private extension GXUtilManager {

    class func gx_filterAudioData(count: Int, height: CGFloat, audioData: Data?) -> [Int] {
        guard let data = audioData else { return [] }
        
        let sampleCount: Int = Int(data.count / MemoryLayout<Int16>.size)
        let binSize: Int = sampleCount / count
        let bytes = data.bytes
        var maxSample: Int = 0, minSample: Int = -1
        let length = sampleCount / binSize
        var filteredSamplesMA: [Int] = []
        for index in 0..<length {
            let i = index * binSize
            let sampleBin = UnsafeMutablePointer<UInt16>.allocate(capacity: binSize)
            for j in 0..<binSize {
                sampleBin[j] = CFSwapInt16LittleToHost(UInt16(bytes[i + j]))
            }
            let value = GXUtilManager.gx_maxValueInArray(values: sampleBin, size: binSize)
            filteredSamplesMA.append(Int(value))
            maxSample = max(maxSample, value)
            if minSample == -1 { minSample = value }
            minSample = min(minSample, value)
        }
        let scaleFactor = height / CGFloat(maxSample - minSample)
        for index in 0..<filteredSamplesMA.count {
            filteredSamplesMA[index] = Int(CGFloat(filteredSamplesMA[index] - minSample) * scaleFactor)
        }
        NSLog("filteredSamplesMA count = \(filteredSamplesMA.count), %@", filteredSamplesMA.description)
        
        return filteredSamplesMA;
    }
    
    class func gx_recorderData(asset: AVAsset, assetTrack: AVAssetTrack?, completion: @escaping ((Data?) -> Void)) {
        guard let track = assetTrack else { completion(nil); return }
        guard let reader = try? AVAssetReader(asset: asset) else { completion(nil); return }
        
        let outputSettings: [String : Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMBitDepthKey: 16
        ]
        let output = AVAssetReaderTrackOutput(track: track, outputSettings: outputSettings)
        reader.add(output)
        reader.startReading()
        var data = Data()
        DispatchQueue.global(qos: .background).async {
            while (reader.status == .reading) {
                if let sampleBuffer = output.copyNextSampleBuffer(),
                   let blockBUfferRef = CMSampleBufferGetDataBuffer(sampleBuffer) {
                    autoreleasepool {
                        let length = CMBlockBufferGetDataLength(blockBUfferRef)
                        let sampleBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
                        CMBlockBufferCopyDataBytes(blockBUfferRef, atOffset: 0, dataLength: length, destination: sampleBytes)
                        data.append(sampleBytes, count: length)
                        CMSampleBufferInvalidate(sampleBuffer)
                    }
                }
            }
            if (reader.status == .completed) {
                completion(data)
            }
            else {
                completion(nil)
            }
        }
    }
    
    class func gx_assetTrack(asset: AVAsset, completion: @escaping ((AVAssetTrack?) -> Void)) {
        if #available(iOS 15.0, *) {
            asset.loadTracks(withMediaType: .audio) { tracks, error in
                if (error != nil) {
                    completion(nil)
                } else {
                    completion(tracks?.last)
                }
            }
        } else {
            let track = asset.tracks(withMediaType: .audio).first
            completion(track)
        }
    }
    
    class func gx_maxValueInArray(values: UnsafeMutablePointer<UInt16>, size: Int) -> Int {
        let minSize = min(size/50, 50)
        let length = size / minSize
        var maxValue: Int = 0
        for index in 0..<length {
            let value = values[index * minSize]
            maxValue += Int(value)
        }
        return maxValue / minSize
    }
    
}
