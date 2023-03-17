//
//  GXUtilManager.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/16.
//

import UIKit

class GXUtilManager: NSObject {
    
    class func gx_countdownTimer(count: Int, milliseconds: Int, handler: ((Int) -> Void)? = nil, completion: (() -> Void)? = nil) {
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
                if timeCount <= 0 {
                    completion?()
                }
            }
            // 时间到了取消时间源
            if timeCount <= 0 {
                codeTimer.cancel()
            }
        })
        // 启动时间源
        codeTimer.resume()
    }
    
}
