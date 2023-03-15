//
//  GXAudioManager.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/15.
//

import UIKit
import AVFoundation

public class GXAudioManager: NSObject {
    
    public class func cutAudioData(size: CGSize, url: URL) async -> [Int]? {
        guard let data = await self.getRecorderDataFromURL(url: url) else { return nil }
        
        let sampleCount: Int = Int(data.count / MemoryLayout<Int16>.size) //计算所有数据个数
        let binSize: Int = Int(CGFloat(sampleCount) / size.width) //将数据分割，也就是按照我们的需求width将数据分为一个个小包
        let bytes = data.bytes //总的数据个数
        var maxSample: Int = 0, minSample: Int = -1
        //以binSize为一个样本。每个样本中取一个最大数。也就是在固定范围取一个最大的数据保存，达到缩减目的
        let length = (sampleCount - 1) / binSize
        var filteredSamplesMA: [Int] = []
        for index in 0..<length {
            let i = index * binSize
            let sampleBin = UnsafeMutablePointer<UInt16>.allocate(capacity: binSize)
            for j in 0..<binSize {
                sampleBin[j] = CFSwapInt16LittleToHost(UInt16(bytes[i + j]))
            }
            let value = GXAudioManager.maxValueInArray(values: sampleBin, size: binSize)
            filteredSamplesMA.append(Int(value))
            maxSample = max(maxSample, value)
            if minSample == -1 { minSample = value }
            minSample = min(minSample, value)
        }
        //计算比例因子
        let scaleFactor = size.height / CGFloat(maxSample - minSample)
        //对所有数据进行“缩放”
        for index in 0..<filteredSamplesMA.count {
            filteredSamplesMA[index] = Int(CGFloat(filteredSamplesMA[index] - minSample) * scaleFactor)
        }
        NSLog("filteredSamplesMA count = \(filteredSamplesMA.count), %@", filteredSamplesMA.description)
        
        return filteredSamplesMA;
    }
    
    class func getRecorderDataFromURL(url: URL) async -> Data? {
        let asset = AVAsset(url: url)
        guard let reader = try? AVAssetReader(asset: asset) else { return nil }
        
        var track: AVAssetTrack? = nil
        if #available(iOS 15.0, *) {
            track = try? await asset.loadTracks(withMediaType: .audio).first
        } else {
            track = asset.tracks(withMediaType: .audio).first
        }
        guard let letTrack = track else { return nil }
        
        let outputSettings: [String : Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMBitDepthKey: 16
        ]
        let output = AVAssetReaderTrackOutput(track: letTrack, outputSettings: outputSettings)
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
    
    class func maxValueInArray(values: UnsafeMutablePointer<UInt16>, size: Int) -> Int {
        var maxValue: Int = 0
        for index in 0..<size {
            let value = values[index]
            maxValue += Int(value)
        }
        return maxValue / size
    }
    
}
