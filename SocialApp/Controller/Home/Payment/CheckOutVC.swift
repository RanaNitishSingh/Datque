//
//  CheckOutVC.swift
//  SocialApp
//
//  Created by mac on 19/01/22.
//

import UIKit

class CheckOutVC: UIViewController {

    var SelectMonth = ""
    var SelectPrice = ""
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Show Value
        self.lblMonth.text = SelectMonth
        self.lblPrice.text = "$ " + SelectPrice
        // Do any additional setup after loading the view.
        print("CheckOutVC")
    }
    
    @IBAction func ActionCheckOut(_ sender: Any) { //CardDetailVC
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CardDetailVC" ) as! CardDetailVC
        VC.selectedAmount = SelectPrice
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}
