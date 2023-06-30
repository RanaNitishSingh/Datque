//
//  BlockedUsersVC.swift
//  SocialApp
//
//  Created by mac on 30/12/21.
//

import UIKit
import iOSDropDown
import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON

class BlockedUsersVC: UIViewController {

    @IBOutlet weak var lblNoRecoedFound: UILabel!
    @IBOutlet weak var tblBlockedUser: UITableView!
    @IBOutlet weak var heightTblBlockdUser: NSLayoutConstraint!
    
    var arrChatDic  = [ChatUserInfo]() //this is array of dictionary type ChatUserInfo
    var arrBlockUserDic = [ChatUserInfo]() //this is array of dictionary type chatUserInfo
    var arrayBlockUsersList = [blockList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show no recoed found
        self.lblNoRecoedFound.isHidden = false
        //self.myInboxChat()
        self.blockUserList()
        self.tblBlockedUser.delegate = self
        self.tblBlockedUser.dataSource = self
        // Do any additional setup after loading the view.
        print("BlockedUsersVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

//Extension for table view
extension BlockedUsersVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //self.heightTblBlockdUser.constant = CGFloat((self.arrBlockUserDic.count * 60 ) + 10 )
        
        if self.arrayBlockUsersList.count >= 1 {
            //show no recoed found
            self.lblNoRecoedFound.isHidden = true
        }else{
            //show no recoed found
            self.lblNoRecoedFound.isHidden = false
        }
        
        return self.arrayBlockUsersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblBlockedUser.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let userDic = self.arrayBlockUsersList[indexPath.row]
        //for Name
        cell.lblNameTblBlockedUser.text = "\(userDic.first_name ?? "")" +  "\(userDic.last_name ?? "")"
        //for image
        let strUserImg1 = userDic.image!
        if  strUserImg1 != "" {
            var image = userDic.image!
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgProfileTblBlockedUser.sd_setImage(with: URL(string: image), placeholderImage: nil)
        }else {
           // print("image_user_Nil")
            cell.imgProfileTblBlockedUser.image = #imageLiteral(resourceName: "ic_avatar")
        }
        
        //Add LongPress Gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(BlockedUsersVC.handleLongPress))
        cell.addGestureRecognizer(longPress)
        longPress.cancelsTouchesInView = true
        cell.tblBlockUserView.layer.cornerRadius = 28
        cell.tblBlockUserView.layer.borderWidth = 2
        cell.tblBlockUserView.layer.borderColor = UIColor(red:147/255, green:44/255, blue:231/255, alpha: 1).cgColor
        cell.selectionStyle = .none
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    
    //Action of Long press gesture
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tblBlockedUser)
            if let indexPath = tblBlockedUser.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                print("Long press Pressed:)",indexPath.row)
                let blockUserDic = self.arrayBlockUsersList[indexPath.row]
                let blockUserName = "\(blockUserDic.first_name ?? "")" +  "\(blockUserDic.last_name ?? "")"
                let blockUserRid = blockUserDic.fb_id ?? ""
                //Create alert of selection
                let alert = UIAlertController(title: "UnBlock:- \(blockUserName)" , message: nil, preferredStyle: UIAlertController.Style.alert)
                 let action1  = UIAlertAction(title: "Un Block", style: UIAlertAction.Style.default) { (action) in
                     self.unBlockReportUser(UserId: blockUserRid)
                 }
                  let action2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                     self.dismiss(animated: true, completion: nil)
                  }
                 alert.addAction(action1)
                 alert.addAction(action2)
                 self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}



// MARK: - Extenction For Inbox chat firbase
extension BlockedUsersVC{
    
    func blockUserList(){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.blockUsersListURL()
        let parameters: [String: String] =
        ["fb_id" : "\(Defaults[PDUserDefaults.UserID])" ,
         "device_token" : "\(Defaults[PDUserDefaults.FCMToken]) " ,
         "device" : "ios"
        ]
        print("Url_userNearByMeServices_is_here:-" , url)
        print("Param_userNearByMeServices_is_here:-" , parameters)

        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_userNearByMeServices",responseJson)
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            self.arrayBlockUsersList.removeAll()
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(UserBlockList.self, from: responseData)
                            self.arrayBlockUsersList = dicData.msg!
                            print("dic_NearbyUser_Data",self.arrayBlockUsersList)
                            self.tblBlockedUser.reloadData()
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                } else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                } else {
                    print("Something went wrong in json")
                }
            }
            
        }
    }
    
    
    func unBlockReportUser(UserId: String){
        print("Block_Report_User_API _Call")
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.blockUserProfileURL()
        
        let parameters: [String: Any] = ["action_type" : "unblock",
                                         "fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "other_id" : "\(UserId)",
                                         "device" : "ios"]
        
        print("Url_blockReportUser_is_here:-" , url)
        print("Param_blockReportUser_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_blockReportUser",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetFlatUserData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            let message = dicData.msg?.first
                            let response = message?.response!
                            self.blockUserList()
                            self.view.makeToast("\(response!)")
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
        
    }
}
