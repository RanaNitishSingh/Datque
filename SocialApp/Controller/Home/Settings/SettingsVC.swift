//
//  SettingsVC.swift
//  SocialApp
//
//  Created by mac on 16/12/21.
//

import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var tblViewSettings: UITableView!
    
    var arrNameSetting = ["Basic info", "Account", "Blocked Users", "Privacy Policy", "Help Centre", "About"]
    var arrImgSetting = [ #imageLiteral(resourceName: "basic info") , #imageLiteral(resourceName: "account") , #imageLiteral(resourceName: "blocked") , #imageLiteral(resourceName: "Lock 1") , #imageLiteral(resourceName: "MAsk") , #imageLiteral(resourceName: "about")]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingsVC")
    }
    
    @IBAction func ActonBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func ActionSignOut(_ sender: Any) {
        
        let temStrFCM = "\(Defaults[PDUserDefaults.FCMToken])"
        Utils.RemovePersistentData() // to remove all default data in application
        Defaults[PDUserDefaults.FCMToken] = temStrFCM
        let VC = self.storyboard!.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC
        self.navigationController!.pushViewController(VC, animated: true)
    }
}

extension SettingsVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNameSetting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewSettings.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.imgTblViewSettings.image = self.arrImgSetting[indexPath.row]
        cell.lblTblViewSettings.text = self.arrNameSetting[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = indexPath.row
        if select == 0 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BasicInfoVC" ) as! BasicInfoVC
            self.navigationController?.pushViewController(VC, animated: true)
        } else if select == 1 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC" ) as! AccountVC
            self.navigationController?.pushViewController(VC, animated: true)
        } else if select == 3 {
            let vc = UIStoryboard.init(name: "SecondaryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "webViewController") as? webViewController
            vc?.headerTxt = "Privacy Policy"
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if select == 4 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC" ) as! HelpCenterVC
            self.navigationController?.pushViewController(VC, animated: true)
        } else if select == 5 {
            let vc = UIStoryboard.init(name: "SecondaryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "webViewController") as? webViewController
            vc?.contentUrl = "https://datque.zeroitsolutions.com/about-us.php"
            vc?.headerTxt = "About"
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if select == 7 {
            let vc = UIStoryboard.init(name: "SecondaryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "webViewController") as? webViewController
            vc?.contentUrl = "https://datque.zeroitsolutions.com/terms_conditions.php"
            vc?.headerTxt = "Terms & Conditions"
            self.navigationController?.pushViewController(vc!, animated: true)
        } else if select == 2 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BlockedUsersVC" ) as! BlockedUsersVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
//        else if select == 6 {
//            let VC = self.storyboard?.instantiateViewController(withIdentifier: "InboxSettingChatVC" ) as! InboxSettingChatVC
//            self.navigationController?.pushViewController(VC, animated: true)
//        }
    }
}
