//
//  Tababar.swift
//  Datque
//
//  Created by Zero IT Solutions on 19/08/23.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    let height: CGFloat = 72
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else {
            return super.sizeThatFits(size)
        }

        var sizeThatFits = super.sizeThatFits(size)
        if #available(iOS 11.0, *) {
            sizeThatFits.height = height + window.safeAreaInsets.bottom
        } else {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}

