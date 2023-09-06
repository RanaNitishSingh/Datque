//
//  storyBoard.swift
//  Datque
//
//  Created by Zero IT Solutions on 06/09/23.
//

import Foundation
import UIKit


extension UIStoryboard {
    class func controller<T: UIViewController>(storyboardName: Storyboard) -> T {
        return UIStoryboard(name: storyboardName.rawValue, bundle: nil).instantiateViewController(withIdentifier: T.className) as! T
    }
}

extension NSObject {
    class var className: String {
        return String(describing: self.self)
    }
}
