//
//  SpleshVC.swift
//  SocialApp
//
//  Created by mac on 23/12/21.
//

import UIKit

class SpleshVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //code for hold the screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.50) {
        // your code here
            print("is lonig..",Defaults[PDUserDefaults.isLogin])
            if Defaults[PDUserDefaults.isLogin] == true{
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC" ) as! HomeTabBarVC
                     // VC.selectedIndex = 2
                     self.navigationController?.pushViewController(VC, animated: true)
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocationVC" ) as! EnableLocationVC
//                self.navigationController?.pushViewController(VC, animated: true)
            }else if Defaults[PDUserDefaults.isLogin] == false {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC" ) as! LoginVC
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
}
