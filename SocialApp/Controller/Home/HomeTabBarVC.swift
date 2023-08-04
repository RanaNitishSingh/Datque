//
//  HomeTabBarVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit


class HomeTabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    @IBInspectable var defaultIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.delegate = self
        setUpImagaOntabbar()
        setupMiddleButton()
        selectedIndex = defaultIndex
        
        let layer = CAShapeLayer()
       // layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 20, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height + 50), cornerRadius: (0)).cgPath
        // layer.shadowColor = #colorLiteral(red: 1.00, green: 0.45, blue: 0.53, alpha: 1.00)
        layer.path = createPath()
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 15.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 0.0
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineWidth = 1.0
        layer.opacity = 1.0
        layer.isHidden = false
        layer.borderColor = UIColor.gray.cgColor
        layer.masksToBounds = false
        layer.fillColor = UIColor.white.cgColor
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        if let items = self.tabBar.items {
            items.forEach { item in item.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0) }
        }
        
        //self.tabBar.itemWidth = 30.0
        self.tabBar.itemPositioning = .centered
    }
    func createPath() -> CGPath {
        let radius: CGFloat = 40.0
            let path = UIBezierPath()
            let centerWidth = self.tabBar.frame.width / 2
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
            path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
            path.addLine(to: CGPoint(x: self.tabBar.frame.width, y: 0))
//          path.addLine(to: CGPoint(x: self.tabBar.frame.height, y: 50))
            //path.addLine(to: CGPoint(x: 0, y: self.tabBar.frame.height))
            //path.close()
            return path.cgPath
        }
    
//    func setupCustomTabBar() {
//        // Hide the default tab bar
//       // tabBar.isHidden = true
//
//        // Create your custom tab bar view with the desired height
//        let customTabBarHeight: CGFloat = 50.0
//        let customTabBar = UIView(frame: CGRect(x: 0, y: view.frame.height - customTabBarHeight, width: view.frame.width, height: customTabBarHeight))
//        customTabBar.backgroundColor = .white // Customize the background color as needed
//
//        // Add your custom tab bar view to the main view
//        view.addSubview(customTabBar)
//
//        // Create a custom shape for the curve using Core Graphics
//        let curveLayer = CAShapeLayer()
//        let curveHeight: CGFloat = 50.0
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: customTabBarHeight))
//        path.addLine(to: CGPoint(x: 0, y: customTabBarHeight - curveHeight))
//        path.addQuadCurve(to: CGPoint(x: view.frame.width, y: customTabBarHeight - curveHeight), controlPoint: CGPoint(x: view.frame.width / 2, y: customTabBarHeight - curveHeight - 10))
//        path.addLine(to: CGPoint(x: view.frame.width, y: customTabBarHeight))
//        path.close()
//        curveLayer.path = path.cgPath
//        curveLayer.fillColor = UIColor.white.cgColor // Customize the color of the curve
//        customTabBar.layer.insertSublayer(curveLayer, at: 0)
//
//        // Add your custom tab bar buttons (e.g., UIButton or custom views) to the customTabBar
//        let buttonSize: CGFloat = 60.0
//        let middleButton = UIButton(type: .custom)
//        middleButton.frame = CGRect(x: (view.frame.width - buttonSize) / 2, y: (customTabBarHeight - buttonSize) / 2 - curveHeight, width:buttonSize, height: buttonSize)
//        middleButton.setImage(UIImage(named: "logo round.jpeg"), for: .normal)
// // Customize the button color as needed
//        middleButton.layer.cornerRadius = buttonSize / 2
//        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
//        customTabBar.addSubview(middleButton)
//
//        // Configure the actions for the other custom tab bar buttons to switch view controllers (if using buttons)
//        // ...
//    }

    @objc func middleButtonTapped() {
        // Implement the action when the middle button is tapped
        // For example, you can present a modal view or switch to a specific view controller
    }
    func setupMiddleButton() {

        let middleBtn = UIButton(frame: CGRect(x: (self.view.bounds.width / 2)-25, y: -20, width: 50, height: 50))
            //STYLE THE BUTTON YOUR OWN WAY
        middleBtn.backgroundColor = .clear
        middleBtn.setImage(UIImage(named: "logo round.jpeg"), for: .normal)
        middleBtn.layer.cornerRadius = (middleBtn.layer.frame.width / 2)
        Utils.Addshadow(middleBtn)

        //add to the tabbar and add click event
        self.tabBar.addSubview(middleBtn)
        middleBtn.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

        self.view.layoutIfNeeded()
}
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2   //to select the middle tab. use "1" if you have only 3 tabs.
        print("MenuButton")
    }
    func setUpImagaOntabbar(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "ic_world_gray")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "world_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "live")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "live_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
//        myTabBarItem3.image = UIImage(named: "home 1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        myTabBarItem3.selectedImage = UIImage(named: "home_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let myTabBarItem4 = (self.tabBar.items?[3])! as UITabBarItem
        myTabBarItem4.image = UIImage(named: "chat ")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem4.selectedImage = UIImage(named: "chat_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let myTabBarItem5 = (self.tabBar.items?[4])! as UITabBarItem
        myTabBarItem5.image = UIImage(named: "user")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem5.selectedImage = UIImage(named: "user_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
    }
    
}


extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
