//
//  CurvedHeader.swift
//  MentajApp
//
//  Created by mac on 21/12/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CurvedHeaderView: UIView {

  //  @IBInspectable var curveHeight:CGFloat = 50.0
    @IBInspectable var curveHeight:CGFloat = 30.0
    
    var curvedLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addArc(withCenter: CGPoint(x: CGFloat(rect.width) - curveHeight, y: rect.height), radius: curveHeight, startAngle: 0, endAngle: 1.5 * CGFloat.pi, clockwise: false)
        path.addLine(to: CGPoint(x: curveHeight, y: rect.height - curveHeight))
        path.addArc(withCenter: CGPoint(x: curveHeight, y: rect.height - (curveHeight * 2.0)), radius: curveHeight, startAngle: 0, endAngle:  CGFloat.pi, clockwise: true)
        
        path.close()
        
        curvedLayer.path = path.cgPath
        curvedLayer.fillColor = UIColor(red: 96/255, green: 94/255, blue: 227/255, alpha: 1.0).cgColor
        curvedLayer.frame = rect
        
        self.layer.insertSublayer(curvedLayer, at: 0)
        
        //self.layer.shadowColor = UIColor.black.cgColor
        //self.layer.shadowRadius = 10.0
        //self.layer.shadowOpacity = 0.7
    }
    
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            self.layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            self.layer.shadowOffset.height = shadowOffsetY
        }
    }
    
}
