//
//  GXAudioManager.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/15.
//

import UIKit
import AVFoundation

public class GXAudioManager: NSObject {

    /// 按需获取音频数据音轨缩放数组
    /// - Parameters:
    ///   - asset: 音频
    ///   - count: 音轨数据缩放大小
    ///   - height: 缩放高度最大值
    ///   - completion: 结果回调
    public class func gx_cutAudioTrackList(asset: AVAsset, count: Int, height: CGFloat, completion: @escaping (([Int]) -> Void)) {
        GXAudioManager.gx_assetTrack(asset: asset) { track in
            let data = GXAudioManager.gx_recorderData(asset: asset, assetTrack: track)
            let audioList = GXAudioManager.gx_filterAudioData(count: count, height: height, audioData: data)
            DispatchQueue.main.async {
                completion(audioList)
            }
        }
    }
    
    private class func gx_filterAudioData(count: Int, height: CGFloat, audioData: Data?) -> [Int] {
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
            let value = GXAudioManager.gx_maxValueInArray(values: sampleBin, size: binSize)
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
    
    private class func gx_recorderData(asset: AVAsset, assetTrack: AVAssetTrack?) -> Data? {
        guard let track = assetTrack else { return nil }
        guard let reader = try? AVAssetReader(asset: asset) else { return nil }

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
            return data
        }
        return nil
    }
    
    private class func gx_assetTrack(asset: AVAsset, completion: @escaping ((AVAssetTrack?) -> Void)) {
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
    
    private class func gx_maxValueInArray(values: UnsafeMutablePointer<UInt16>, size: Int) -> Int {
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
