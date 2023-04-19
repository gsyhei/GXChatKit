//
//  UIImage+GXResource.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/4/13.
//

import UIKit

public extension UIImage {
    
    static var gx_audioPlayImage: UIImage? {
        return UIImage(systemName: "play.circle.fill")
    }
    
    static var gx_audioPauseImage: UIImage? {
        return UIImage(systemName: "pause.circle.fill")
    }
    
    static var gx_videoPlayImage: UIImage? {
        return UIImage(systemName: "play.circle")
    }
    
    static var gx_callVoiceImage: UIImage? {
        return UIImage(systemName: "phone.down")
    }
    
    static var gx_callVideoImage: UIImage? {
        return UIImage(systemName: "video")
    }

    static var gx_fileIconImage: UIImage? {
        return UIImage.gx_bundleAssetImage(name: "file")
    }
    
    static var gx_redPacketIconImage: UIImage? {
        return UIImage.gx_bundleAssetImage(name: "redEnvelope")
    }
    
    static var gx_replyIconImage: UIImage? {
        return UIImage(systemName: "arrowshape.turn.up.left.fill")
    }
}
