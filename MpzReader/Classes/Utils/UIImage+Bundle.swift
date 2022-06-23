//
//  UIImage+Bundle.swift
//  MenuItemKit
//
//  Created by Hasitha Mapalagama on 8/23/19.
//

import Foundation
import UIKit
extension UIImage {
    
    static func inBundle(named : String) -> UIImage? {
        let bundle = Bundle.init(for: MpzReader.self)
        return UIImage.init(named: named, in: bundle, compatibleWith:  nil)
    }
}
