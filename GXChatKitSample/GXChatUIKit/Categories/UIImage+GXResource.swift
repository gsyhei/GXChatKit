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

    static func gx_cellPreviewIconImage(type: GXChatConfiguration.MessageMenuType) -> UIImage? {
        switch type {
        case .repply:
            return UIImage(systemName: "arrowshape.turn.up.left")
        case .copy:
            return UIImage(systemName: "doc.on.doc")
        case .forward:
            return UIImage(systemName: "arrowshape.turn.up.right")
        case .edit:
            return UIImage(systemName: "square.and.pencil")
        case .save:
            return UIImage(systemName: "square.and.arrow.down")
        case .collect:
            return UIImage(systemName: "star")
        case .revoke:
            return UIImage(systemName: "arrowshape.turn.up.left.2")
        case .delete:
            return UIImage(systemName: "trash")
        case .report:
            return UIImage(systemName: "exclamationmark.circle")
        case .select:
            return UIImage(systemName: "checkmark.circle")
        }
    }
}
