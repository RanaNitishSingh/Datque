//
//  HelpCenterVC.swift
//  SocialApp
//
//  Created by Zero IT Solutions on 13/06/23.
//

import UIKit

class HelpCenterVC: UIViewController {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    @IBAction func ActionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ActionShareBtn(_ sender: Any) {
        self.shareProfile()
    }
    func shareProfile(){
        print("share_profile")
        
      //  let img = self.imgProfile.image
        let Email = "\(self.emailLbl.text!)"
      //  let url = ("https://www.apple.com")
        let textToShare = [Email] as [Any]
      let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
      //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
      self.present(activityViewController, animated: true, completion: nil)
        
    }

}

