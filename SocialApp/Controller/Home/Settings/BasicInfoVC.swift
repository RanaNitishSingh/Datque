//
//  BasicInfoVC.swift
//  SocialApp
//
//  Created by mac on 17/12/21.
//

import UIKit

class BasicInfoVC: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserDOB: UILabel!
    @IBOutlet weak var ImgMale: UIImageView!
    @IBOutlet weak var ImgFemale: UIImageView!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fatchUserData()
        print("BasicInfoVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

extension BasicInfoVC{
    func fatchUserData(){
            if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
                do {
                    let decoder = JSONDecoder()
                    let userSaveData = try decoder.decode(Msg.self, from: data)
                    let strUserFirstName = "\(userSaveData.firstName ?? "")"
                    let strUserLastName = "\(userSaveData.lastName ?? "")"
                    let strUserDOB = "\(userSaveData.birthday ?? "Not updated")"
                    let strUserGender = "\(userSaveData.gender ?? "")"
                    self.lblUserDOB.text = strUserDOB
                    if strUserFirstName == "" && strUserLastName == "" {
                        self.lblUserName.text = "Not updated"
                    } else {
                        self.lblUserName.text = strUserFirstName + " " + strUserLastName
                    }
                    
                    if strUserGender == "Male" || strUserGender == "male" || strUserGender == "1" {
                        self.btnMale.setImage(UIImage(named: "radioOn"), for: .normal)
                    } else if strUserGender == "Female" || strUserGender == "female" || strUserGender == "0" {
                        self.btnFemale.setImage(UIImage(named: "radioOff"), for: .normal)
                    } else {
                        self.btnMale.setImage(UIImage(named: "radioOff"), for: .normal)
                        self.btnFemale.setImage(UIImage(named: "radioOff"), for: .normal)
                    }
                    
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        
    }
}

