//
//  GXAudioManager.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/15.
//

import UIKit
import AVFoundation

public class GXAudioManager: NSObject {
    public static let audioPlayNotification: NSNotification.Name = NSNotification.Name(rawValue: "audioPlayNotification")
    public static let audioStopNotification: NSNotification.Name = NSNotification.Name(rawValue: "audioStopNotification")
    public static let audioPauseNotification: NSNotification.Name = NSNotification.Name(rawValue: "audioPauseNotification")
    public static let audioPlayProgressNotification: NSNotification.Name = NSNotification.Name(rawValue: "audioPlayProgressNotification")

    private var audioPlayer: AVAudioPlayer?
    private var timer: DispatchSourceTimer?
    private weak var audioItem: GXMessagesItemData?
    
    public var currentTime: TimeInterval {
        return self.audioPlayer?.currentTime ?? 0
    }

    public static let shared: GXAudioManager = {
        let instance = GXAudioManager()
        return instance
    }()
    
    deinit {
        self.stopAudio()
    }
    
    public func playAudio(item: GXMessagesItemData?, fileTypeHint utiString: String? = nil, time: TimeInterval = 0) {
        guard let newItem = item else { return }
        if self.audioItem != newItem {
            self.stopAudio()
            
            self.audioItem = newItem
            guard let content = item?.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
            self.playAudio(url: content.fileURL, time: content.currentPlayDuration)
        }
        else {
            if let player = self.audioPlayer {
                if !player.isPlaying {
                    guard let content = self.audioItem?.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
                    content.isPlaying = true
                    self.removeObserver()

                    player.play()
                    NotificationCenter.default.post(name: GXAudioManager.audioPlayNotification, object: item)
                    self.gx_playProgress()
                    self.updateAudioPlay(isSpeaker: true)
                    UIDevice.current.isProximityMonitoringEnabled = true
                    self.addObserver()
                }
            }
            else {
                self.audioItem = newItem
                guard let content = item?.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
                self.playAudio(url: content.fileURL, time: content.currentPlayDuration)
            }
        }
    }
    
    public func playAudio(url: URL?, fileTypeHint utiString: String? = nil, time: TimeInterval = 0) {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        
        if self.audioPlayer == nil {
            guard let audioUrl = url else { return }
            let audioPlayer = try? AVAudioPlayer(contentsOf: audioUrl, fileTypeHint: utiString)
            audioPlayer?.delegate = self
            self.audioPlayer = audioPlayer
        }
        guard let player = audioPlayer else { return }
        var isPlayer = false
        let isPrepare: Bool = player.prepareToPlay()
        if isPrepare {
            if !player.isPlaying {
                if time == 0 {
                    isPlayer = player.play()
                }
                else {
                    isPlayer = player.play(atTime: time)
                }
            }
            content.isPlaying = isPlayer
            if isPlayer {
                NotificationCenter.default.post(name: GXAudioManager.audioPlayNotification, object: item)
                self.gx_playProgress()
                self.updateAudioPlay(isSpeaker: true)
                UIDevice.current.isProximityMonitoringEnabled = true
                self.addObserver()
            }
        }
        else {
            content.isPlaying = false
        }
    }
    
    public func playAudio(data: Data?, fileTypeHint utiString: String? = nil, time: TimeInterval = 0) {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        
        if self.audioPlayer == nil {
            guard let audioData = data else { return }
            let audioPlayer = try? AVAudioPlayer(data: audioData, fileTypeHint: utiString)
            audioPlayer?.delegate = self
            self.audioPlayer = audioPlayer
        }
        guard let player = audioPlayer else { return }
        var isPlayer = false
        let isPrepare: Bool = player.prepareToPlay()
        if isPrepare {
            if !player.isPlaying {
                if time == 0 {
                    isPlayer = player.play()
                }
                else {
                    isPlayer = player.play(atTime: time)
                }
            }
            content.isPlaying = isPlayer
            if isPlayer {
                NotificationCenter.default.post(name: GXAudioManager.audioPlayNotification, object: item)
                self.gx_playProgress()
                self.updateAudioPlay(isSpeaker: true)
                UIDevice.current.isProximityMonitoringEnabled = true
                self.addObserver()
            }
        }
        else {
            content.isPlaying = false
        }
    }
    
    public func pauseAudio() {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }

        content.isPlaying = false
        content.currentPlayDuration = self.currentTime
        NotificationCenter.default.post(name: GXAudioManager.audioPauseNotification , object: item)

        UIDevice.current.isProximityMonitoringEnabled = false
        self.removeObserver()
        self.audioPlayer?.pause()
        self.timer?.cancel()
    }
    
    public func stopAudio() {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        
        content.isPlaying = false
        content.currentPlayDuration = 0
        content.currentPlayIndex = 0
        NotificationCenter.default.post(name: GXAudioManager.audioStopNotification, object: item)

        UIDevice.current.isProximityMonitoringEnabled = false
        self.removeObserver()
        if audioPlayer?.isPlaying ?? false {
            self.audioPlayer?.stop()
        }
        self.timer?.cancel()
        self.audioPlayer = nil
    }

    func gx_playProgress() {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContentData as? GXMessagesAudioContent else { return }
        guard let trackCount = content.tracks?.count, trackCount > 0 else { return }

        let milliseconds: Int = Int(content.animateDuration * 1000.0)
        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(wallDeadline: .now(), repeating: .milliseconds(milliseconds))
        codeTimer.setEventHandler(handler: {
            content.currentPlayDuration = self.currentTime
            content.currentPlayIndex = Int(self.currentTime / content.animateDuration) + 1
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: GXAudioManager.audioPlayProgressNotification, object: item)
            }
        })
        codeTimer.resume()
        self.timer = codeTimer
    }
    
}

extension GXAudioManager: AVAudioPlayerDelegate {
    
    func updateAudioPlay(isSpeaker: Bool) {
        if isSpeaker && GXChatConfiguration.shared.audioPlaySpeaker {
            try? AVAudioSession.sharedInstance().setCategory(.playback)
        }
        else {
            try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        }
    }
    
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(proximityStateDidChange), name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        
    }
    
    @objc func audioSessionInterruption(notification: NSNotification) {
        let type = notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? AVAudioSession.InterruptionType
        if type == AVAudioSession.InterruptionType.began {
            self.pauseAudio()
        }
    }
    
    @objc func proximityStateDidChange(notification: NSNotification) {
        self.updateAudioPlay(isSpeaker: !UIDevice.current.proximityState)
    }
    
    //MARK: -AVAudioPlayerDelegate
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.stopAudio()
        }
    }
    
    public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        self.stopAudio()
    }
    
}