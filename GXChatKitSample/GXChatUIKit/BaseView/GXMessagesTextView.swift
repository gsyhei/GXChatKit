//
//  GXMessagesTextView.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/3/25.
//

import UIKit

public class GXMessagesTextView: UITextView {
    
    public override var attributedText: NSAttributedString! {
        didSet {
            if let gesRecognizers = self.gestureRecognizers {
                for subGesture in gesRecognizers {
                    subGesture.cancelsTouchesInView = false
                }
            }
        }
    }
    
    
    // required to prevent blue background selection from any situation
    public override var selectedTextRange: UITextRange? {
        get { return nil }
        set {}
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer.cancelsTouchesInView = false
        
        
        if gestureRecognizer is UIPanGestureRecognizer {
            // required for compatibility with isScrollEnabled
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
           tapGestureRecognizer.numberOfTapsRequired == 1 {
            // required for compatibility with links
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        // allowing smallDelayRecognizer for links
        // https://stackoverflow.com/questions/46143868/xcode-9-uitextview-links-no-longer-clickable
//        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
//           // comparison value is used to distinguish between 0.12 (smallDelayRecognizer) and 0.5 (textSelectionForce and textLoupe)
//           longPressGestureRecognizer.minimumPressDuration < 0.325 {
//            return super.gestureRecognizerShouldBegin(gestureRecognizer)
//        }
        // preventing selection from loupe/magnifier (_UITextSelectionForceGesture), multi tap, tap and a half, etc.
        
//        gestureRecognizer.isEnabled = false
        return false
    }

}

extension GXMessagesTextView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
