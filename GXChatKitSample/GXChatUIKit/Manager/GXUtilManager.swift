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
    
    /// 按需获取音频数据音轨缩放数组
    /// - Parameters:
    ///   - asset: 音频
    ///   - count: 音轨数据缩放大小
    ///   - height: 缩放高度最大值
    ///   - completion: 结果回调
    public class func gx_cutAudioTrackList(asset: AVAsset, count: Int, height: CGFloat, completion: @escaping (([Int]) -> Void)) {
        GXUtilManager.gx_assetTrack(asset: asset) { track in
            DispatchQueue.global(qos: .default).async {
                GXUtilManager.gx_recorderData(asset: asset, assetTrack: track, completion: { data in
                    let audioList = GXUtilManager.gx_filterAudioData(count: count, height: height, audioData: data)
                    DispatchQueue.main.async {
                        completion(audioList)
                    }
                })
            }
        }
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
    
    // 按需获取音频数据音轨缩放数组
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

private extension GXUtilManager {
    
    class func gx_filterAudioData(count: Int, height: CGFloat, audioData: Data?) -> [Int] {
        guard let data = audioData else { return [] }
        
        var filteredSamplesMA: [Int] = []
        data.withUnsafeBytes({ (rawBufferPointer: UnsafeRawBufferPointer) -> Void in
            let samples = rawBufferPointer.bindMemory(to: UInt16.self)
            let sampleCount: Int = Int(data.count / MemoryLayout<Int16>.size)
            let binSize: Int = sampleCount / count
            var maxSample: Int = 0
            let length = sampleCount / binSize
            for index in 0..<length {
                let i = index * binSize
                let sampleBin = UnsafeMutablePointer<UInt16>.allocate(capacity: binSize)
                for j in 0..<binSize {
                    sampleBin[j] = CFSwapInt16LittleToHost(UInt16(samples[i + j]))
                }
                let value = GXUtilManager.gx_maxValueInArray(values: sampleBin, size: binSize)
                filteredSamplesMA.append(Int(value))
                maxSample = max(maxSample, value)
            }
            let scaleFactor = height / CGFloat(maxSample)
            for index in 0..<filteredSamplesMA.count {
                filteredSamplesMA[index] = Int(CGFloat(filteredSamplesMA[index]) * scaleFactor)
            }
            NSLog("filteredSamplesMA count = \(filteredSamplesMA.count), %@", filteredSamplesMA.description)
        })
        return filteredSamplesMA
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
        while (reader.status == .reading) {
            if let sampleBuffer = output.copyNextSampleBuffer(), let blockBUfferRef = CMSampleBufferGetDataBuffer(sampleBuffer) {
                let length = CMBlockBufferGetDataLength(blockBUfferRef)
                let sampleBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
                CMBlockBufferCopyDataBytes(blockBUfferRef, atOffset: 0, dataLength: length, destination: sampleBytes)
                data.append(sampleBytes, count: length)
                CMSampleBufferInvalidate(sampleBuffer)
                free(sampleBytes)
            }
        }
        if (reader.status == .completed) {
            completion(data)
        }
        else {
            completion(nil)
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
        let length = 10
        let minSize = size / length
        var maxValue: Int = 0
        for index in 0..<length {
            let value = values[index * minSize]
            if abs(maxValue) < value {
                maxValue = Int(value)
            }
        }
        return maxValue
    }
    
}
