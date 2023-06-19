//
//  HelpCenterVC.swift
//  SocialApp
//
//  Created by Zero IT Solutions on 13/06/23.
//

import UIKit

class HelpCenterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func ActionBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
