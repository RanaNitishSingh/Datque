//
//  NotificationVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON

class NotificationVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var tblViewNotification: UITableView!
    @IBOutlet weak var NSHeightTblViewNotification: NSLayoutConstraint!
    var arrDicGetUserNotifications = [MsgGetUserNotifications]() //this is array of dictionary type MsgGetUserNotifications
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Call API getUserNotificationsService here
        self.getUserNotificationsService()
        // Do any additional setup after loading the view.
        print("NotificationVC")
    }
    
    @IBAction func ActionFilter(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

extension NotificationVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.NSHeightTblViewNotification.constant = CGFloat(((self.arrDicGetUserNotifications.count) * 80) + 10)
        return self.arrDicGetUserNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewNotification.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        //For image
        let dicUser = self.arrDicGetUserNotifications[indexPath.row]
        print("dicUser_is_here_Notification",dicUser)
        let dicUserNotification = dicUser.notification!
        let strUserImg = dicUserNotification.icon!
        if strUserImg != "0" && strUserImg != "" {
            var image = dicUserNotification.icon!
            print("image_user_not_Nil :-\(image)")
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgTblViewNotification.sd_setImage(with: URL(string: image), placeholderImage: nil)
            
        }else {
            print("image_user_Nil")
            cell.imgTblViewNotification.image = #imageLiteral(resourceName: "avatar")
        }
        
        //for title
        cell.lblTitleTblViewNotification.text = "\(dicUserNotification.title!)"
        //for body
        cell.lblBodyTblViewNotification.text = "\(dicUserNotification.body!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "NotificationUserDetailVC") as! NotificationUserDetailVC
        popoverContent.modalPresentationStyle = .popover
     //   popoverContent.dicGetUserNotifications = self.arrDicGetUserNotifications[indexPath.row]
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
}

extension NotificationVC{
    
    func getUserNotificationsService() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.getUserNotificationsURL()
        
        let parameters: [String: Any] = ["receiver_id" : Defaults[PDUserDefaults.UserID]]
        
        print("Url_getUserNotificationsURL_is_here:-" , url)
        print("Param_getUserNotificationsURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_getUserNotificationsURL",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetUserNotificationsData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                
                                self.arrDicGetUserNotifications = dicData.msg!
                                print("arrDicGetUserNotifications",self.arrDicGetUserNotifications)
                                self.tblViewNotification.reloadData()
                                
                            }
                            
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
