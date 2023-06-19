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
        selectedIndex = defaultIndex
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 20, width: self.tabBar.bounds.width, height: self.tabBar.bounds.height + 50), cornerRadius: (20)).cgPath
        // layer.shadowColor = #colorLiteral(red: 1.00, green: 0.45, blue: 0.53, alpha: 1.00)
        layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        layer.shadowRadius = 15.0
        layer.shadowOpacity = 0.3
        layer.borderWidth = 0.5
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
    func setUpImagaOntabbar(){
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "ic_world_gray")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem1.selectedImage = UIImage(named: "world_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "live")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem2.selectedImage = UIImage(named: "live_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "home 1")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        myTabBarItem3.selectedImage = UIImage(named: "home_select")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
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
