//
//  RadioWaveAnimationView.swift
//  SocialApp
//
//  Created by mac on 04/01/22.
//

import Foundation
import UIKit
import SwiftUI

class UIRadioWaveAnimationView: UIView {

    var animatableLayer : CAShapeLayer?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func startAnimation(setThemeColor:Bool) {
        self.layer.cornerRadius = self.bounds.height/2
        self.animatableLayer = CAShapeLayer()
        if setThemeColor {
            self.animatableLayer?.fillColor =  #colorLiteral(red: 0.6276120543, green: 0.1230647042, blue: 0.9404756427, alpha: 1)
        } else {
            self.animatableLayer?.fillColor =  #colorLiteral(red: 0.4467987418, green: 0.4987713099, blue: 0.9065061212, alpha: 1)
        }
        self.animatableLayer?.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.animatableLayer?.frame = self.bounds
        self.animatableLayer?.cornerRadius = self.bounds.height/2
        self.animatableLayer?.masksToBounds = true
        self.layer.addSublayer(self.animatableLayer!)
        let layerAnimation = CABasicAnimation(keyPath: "transform.scale")
        layerAnimation.fromValue = 1
        layerAnimation.toValue = 3
        layerAnimation.isAdditive = false

        let layerAnimation2 = CABasicAnimation(keyPath: "opacity")
        layerAnimation2.fromValue = 2
        layerAnimation2.toValue = 5
        layerAnimation2.isAdditive = false
        
        let layerAnimation3 = CABasicAnimation(keyPath: "opacity")
        layerAnimation3.fromValue = 1
        layerAnimation3.toValue = 0
        layerAnimation3.isAdditive = false

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [layerAnimation,layerAnimation2,layerAnimation3]
        groupAnimation.duration = CFTimeInterval(3)
        groupAnimation.fillMode = CAMediaTimingFillMode.forwards
        groupAnimation.isRemovedOnCompletion = true
        groupAnimation.repeatCount = .infinity

        self.animatableLayer?.add(groupAnimation, forKey: "growingAnimation")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
