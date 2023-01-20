//
//  UIColor+GXChat.swift
//  GXChatUIKit
//
//  Created by Gin on 2023/1/17.
//

import UIKit

public extension UIColor {
    
    func gx_colorByDarkeningColor(value: CGFloat) -> UIColor? {
        guard let oldComponents = self.cgColor.components else { return nil }
        let totalComponents: Int = oldComponents.count
        let isGreyscale: Bool = (totalComponents == 2)
        var newComponents: [CGFloat] = Array(repeating: 0, count: 4)
        
        if isGreyscale {
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[3] = oldComponents[1];
        }
        else {
            guard totalComponents >= 4 else { return nil }
            newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value
            newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value
            newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value
            newComponents[3] = oldComponents[3]
        }
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let newColor = CGColor(colorSpace: colorSpace, components: newComponents) else { return nil }
        
        return UIColor(cgColor: newColor)
    }
    
}
