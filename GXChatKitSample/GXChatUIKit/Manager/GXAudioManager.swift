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
}

public extension GXAudioManager {
    func playAudio(item: GXMessagesItemData?, fileTypeHint utiString: String? = nil) {
        guard let newItem = item else { return }
        if self.audioItem == newItem {
            guard let content = item?.data.gx_messagesContent as? GXMessagesAudioContent else { return }
            if let player = self.audioPlayer {
                player.rate = content.rate
                if !player.isPlaying {
                    self.gx_playRemoveObserver()
                    content.isPlaying = true
                    player.currentTime = content.currentPlayDuration
                    player.play()
                    NotificationCenter.default.post(name: GXAudioManager.audioPlayNotification, object: item)
                    self.gx_playAddObserver()
                }
            }
            else {
                self.audioItem = newItem
                self.playAudio(url: content.fileURL, time: content.currentPlayDuration, rate: content.rate)
            }
        }
        else {
            self.stopAudio()
            self.audioItem = newItem
            guard let content = item?.data.gx_messagesContent as? GXMessagesAudioContent else { return }
            self.playAudio(url: content.fileURL, time: content.currentPlayDuration, rate: content.rate)
        }
    }
    
    func playAudio(url: URL?, fileTypeHint utiString: String? = nil, time: TimeInterval = 0, rate: Float = 1.0) {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        
        if self.audioPlayer == nil {
            guard let audioUrl = url else { return }
            let audioPlayer = try? AVAudioPlayer(contentsOf: audioUrl, fileTypeHint: utiString)
            audioPlayer?.delegate = self
            audioPlayer?.enableRate = true
            self.audioPlayer = audioPlayer
        }
        guard let player = audioPlayer else { return }
        player.currentTime = time
        player.rate = rate
        var isPlayer = false
        let isPrepare: Bool = player.prepareToPlay()
        if isPrepare {
            if !player.isPlaying {
                isPlayer = player.play()
            }
            content.isPlaying = isPlayer
            if isPlayer {
                NotificationCenter.default.post(name: GXAudioManager.audioPlayNotification, object: item)
                self.gx_playAddObserver()
            }
        }
        else {
            content.isPlaying = false
        }
    }
    
    func playAudio(data: Data?, fileTypeHint utiString: String? = nil, time: TimeInterval = 0, rate: Float = 1.0) {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        
        if self.audioPlayer == nil {
            guard let audioData = data else { return }
            let audioPlayer = try? AVAudioPlayer(data: audioData, fileTypeHint: utiString)
            audioPlayer?.delegate = self
            audioPlayer?.enableRate = true
            self.audioPlayer = audioPlayer
        }
        guard let player = audioPlayer else { return }
        player.currentTime = time
        player.rate = rate
        var isPlayer = false
        let isPrepare: Bool = player.prepareToPlay()
        if isPrepare {
            if !player.isPlaying {
                isPlayer = player.play()
            }
            content.isPlaying = isPlayer
            if isPlayer {
                NotificationCenter.default.post(name: GXAudioManager.audioPlayNotification, object: item)
                self.gx_playAddObserver()
            }
        }
        else {
            content.isPlaying = false
        }
    }
    
    func pauseAudio() {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }

        content.isPlaying = false
        content.currentPlayDuration = self.currentTime
        NotificationCenter.default.post(name: GXAudioManager.audioPauseNotification , object: item)

        self.gx_playRemoveObserver()
        self.audioPlayer?.pause()
    }
    
    func stopAudio() {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        
        content.isPlaying = false
        content.currentPlayDuration = 0
        NotificationCenter.default.post(name: GXAudioManager.audioStopNotification, object: item)

        self.gx_playRemoveObserver()
        if audioPlayer?.isPlaying ?? false {
            self.audioPlayer?.stop()
        }
        self.audioPlayer = nil
    }
    
    func updateRate(item: GXMessagesItemData?) {
        guard let newItem = item else { return }
        guard self.audioItem == newItem else { return }
        guard let content = item?.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        if let player = audioPlayer, player.isPlaying {
            self.audioPlayer?.rate = content.rate
        }
    }
}

extension GXAudioManager: AVAudioPlayerDelegate {
    
    func gx_playProgress() {
        guard let item = self.audioItem else { return }
        guard let content = item.data.gx_messagesContent as? GXMessagesAudioContent else { return }
        guard let trackCount = content.tracks?.count, trackCount > 0 else { return }

        let codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        codeTimer.schedule(wallDeadline: .now(), repeating: .milliseconds(30))
        codeTimer.setEventHandler(handler: {
            content.currentPlayDuration = self.currentTime
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: GXAudioManager.audioPlayProgressNotification, object: item)
            }
        })
        codeTimer.resume()
        self.timer = codeTimer
    }
    
    func gx_updateAudioPlay(isSpeaker: Bool) {
        if isSpeaker && GXCHATC.audioPlaySpeaker {
            try? AVAudioSession.sharedInstance().setCategory(.playback)
        }
        else {
            try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        }
    }
    
    func gx_playAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioSessionInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(proximityStateDidChange), name: UIDevice.proximityStateDidChangeNotification, object: nil)
        UIDevice.current.isProximityMonitoringEnabled = true
        self.gx_updateAudioPlay(isSpeaker: true)
        self.gx_playProgress()
    }
    
    func gx_playRemoveObserver() {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.isProximityMonitoringEnabled = false
        self.timer?.cancel()
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
        self.gx_updateAudioPlay(isSpeaker: !UIDevice.current.proximityState)
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
