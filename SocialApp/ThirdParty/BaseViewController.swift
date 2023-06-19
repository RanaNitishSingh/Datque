//
//  BaseViewController.swift
//  LahaWorld
//
//  Created by mac on 15/07/19.
//  Copyright © 2019 shrinkcom. All rights reserved.
//

import UIKit


class BaseViewController: UIViewController {
    var hud = UIView()
    
    func showCustomHUD(){
        hud = UIView().getHUD(spinner: UIActivityIndicatorView())
    }

    func hideCustomHUD(){
        hud.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAnnouncment(withMessage message: String, closer:(()-> Void)? = nil){
        let alertController =   UIAlertController(title: "Snaplify", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            closer?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
   
    
    func gotoLogin() {
        let home = self.storyboard!.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC

        var navi = UINavigationController()
        navi = UINavigationController(rootViewController: home)
        navi.navigationBar.isTranslucent = true
        navi.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]

        navi.setNavigationBarHidden(false, animated: true)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                print(">>> windowScene: \(windowScene)")
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = navi
                window.makeKeyAndVisible()
                appDelegate.window = window
            }
        } else {
            appDelegate.window?.rootViewController = navi
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    
    
//    struct MainClass {
//        static let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        static let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        static let clientStoryboard = UIStoryboard(name: "Client", bundle: Bundle.main)
//
//    }
    
//  //MARK:- Lawyer Storyboard
//    func LawyerStoryBoard(index: Int) {
//        let vc = MainClass.mainStoryboard.instantiateViewController(withIdentifier: "TabBarVc") as! TabBarVc
//            vc.selectedIndex = index
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    // MARK:- Client Storyboard
//    func ClientStoryBoard(index: Int) {
//        let vc = MainClass.clientStoryboard.instantiateViewController(withIdentifier: "ClientTabBar") as! ClientTabBar
//            vc.selectedIndex = index
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
    
    func centerLockMethod() {

    }
    
}
    
    /*
    func goToAdministratorHome() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = SJSwiftSideMenuController()
        let sideVC_L : SideMenuVC = (storyBoard.instantiateViewController(withIdentifier: "SideMenuVC") as? SideMenuVC)!
      
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "CustomTabViewController") as? CustomTabViewController
        SJSwiftSideMenuController.setUpNavigation(rootController: rootVC!, leftMenuController: sideVC_L, rightMenuController: nil, leftMenuType: .SlideView, rightMenuType: .SlideView)
        
        SJSwiftSideMenuController.enableDimbackground = true
        SJSwiftSideMenuController.leftMenuWidth = (UIScreen.main.bounds.width) - 80
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                print(">>> windowScene: \(windowScene)")
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = mainVC
                window.makeKeyAndVisible()
                appDelegate.window = window
            }
        } else {
            appDelegate.window?.rootViewController = mainVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func goToVisilantHome() {
        let storyBoard = UIStoryboard(name: "Vigilant", bundle: nil)
        let mainVC = SJSwiftSideMenuController()
        let sideVC_L : SideMenuVigilanteVc = (storyBoard.instantiateViewController(withIdentifier: "SideMenuVigilanteVc") as? SideMenuVigilanteVc)!
      
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "VigilanteTabBar") as? VigilanteTabBar
        SJSwiftSideMenuController.setUpNavigation(rootController: rootVC!, leftMenuController: sideVC_L, rightMenuController: nil, leftMenuType: .SlideView, rightMenuType: .SlideView)
        
        SJSwiftSideMenuController.enableDimbackground = true
        SJSwiftSideMenuController.leftMenuWidth = (UIScreen.main.bounds.width) - 80
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if #available(iOS 13.0, *){
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                print(">>> windowScene: \(windowScene)")
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene //Make sure to do this
                window.rootViewController = mainVC
                window.makeKeyAndVisible()
                appDelegate.window = window
            }
        } else {
            appDelegate.window?.rootViewController = mainVC
            appDelegate.window?.makeKeyAndVisible()
        }
    }
    
}*/

extension UIView{
    func getHUD(spinner: UIActivityIndicatorView) -> UIView {
        let window = UIApplication.shared.delegate?.window
        window??.resignFirstResponder()
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.center = (window??.rootViewController?.view.center)!
        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        window??.addSubview(view)
        return view
    }
}

