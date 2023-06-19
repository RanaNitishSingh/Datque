//
//  NotificationUserDetailVC.swift
//  SocialApp
//
//  Created by mac on 14/01/22.
//

import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON

class NotificationUserDetailVC: UIViewController {
    
    @IBOutlet weak var viewMatch: UIView!
    
    @IBOutlet weak var imgProfile: UIImageViewX!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    var userID = ""

   // var dicGetUserNotifications:MsgGetUserNotifications? //this is dictionary
    var dicGetUserNotifications:MsguserNearByMe?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMatch.isHidden = true
        self.showDetails()
        print("popovere_dicGetUserNotifications_is",self.dicGetUserNotifications as Any)
        // Do any additional setup after loading the view.
        print("NotificationUserDetailVC")
    }
    
    @IBAction func ActionShareProfile(_ sender: Any) {
        self.shareProfile()
    }
    
    @IBAction func ActionBlockreport(_ sender: Any) {
        
        let userId = self.dicGetUserNotifications?.fbID!
        print("userId_is_here:- ",userId!)

        if userId != "" && userId != nil {
            self.blockReportUser(UserId: "\(userId!)")
        }
    }
    
    @IBAction func ActionLike(_ sender: Any) {
        self.likeUser()
    }
    
    @IBAction func ActionDislike(_ sender: Any) {
        self.dislikeUser()
    }
    
    @IBAction func ActionStartConversation(_ sender: Any) {
        self.startConversation()
    }
    
    @IBAction func closeViewMatch(_ sender: Any) {
        
        self.viewMatch.isHidden = true
    }
    
}

//MARK: show details of user
extension NotificationUserDetailVC{
    func showDetails(){
        //for image
        var image = self.dicGetUserNotifications?.image1!
        if image != nil && image != ""{
            print("image_user_not_Nil_is :-\(String(describing: image))")
            image = image!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            imgProfile.sd_setImage(with: URL(string: image!), placeholderImage: nil)
        }
        //for name and age
        self.lblNameAge.text = (self.dicGetUserNotifications?.firstName!)!
        + " ," + (self.dicGetUserNotifications?.birthday)!
        //for distance
        self.lblDistance.text = (self.dicGetUserNotifications?.distance!)!
        //+ " miles away"
    }
}

//MARK: extension for share profile
extension NotificationUserDetailVC{
    func shareProfile(){
        print("share_profile")
        
        let img = self.imgProfile.image
        let text = "\(self.lblNameAge.text!)"
        let url = ("https://www.apple.com")
        let textToShare = [ img , text , url] as [Any]
      let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
      activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
      //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
      self.present(activityViewController, animated: true, completion: nil)
        
    }
}

//MARK: extension for Block and Report User call API here
extension NotificationUserDetailVC{
    func blockReportUser(UserId: String){
        print("Block_Report_User_API _Call")
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.flat_userURL()
        
        let parameters: [String: Any] = ["my_id" : Defaults[PDUserDefaults.UserID],
                                         "fb_id" : "\(UserId)",
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

//MARK: extension for like Dislike User
extension NotificationUserDetailVC{
    func likeUser(){
        print("Like_User_Profile")
        //self.viewMatch.isHidden = false
        let UserId =  dicGetUserNotifications?.fbID!
        let UserName = dicGetUserNotifications?.firstName!
       
        print("Selected userName_selected",UserName!)
        self.firebaseMatchEntry(UserID: "\(UserId!)", UserName: "\(UserName!)", UserType: "like")
        self.detailGetFirebase(UserID: "\(UserId!)", UserType: "like")
        
    }
    
    func dislikeUser(){
        print("dislike_User_Profile")
        let UserId =  dicGetUserNotifications?.fbID!
        let UserName = dicGetUserNotifications?.firstName!
       
        print("Selected userName_selected",UserName!)
        self.firebaseMatchEntry(UserID: "\(UserId!)", UserName: "\(UserName!)", UserType: "dislike")
        self.detailGetFirebase(UserID: "\(UserId!)", UserType: "like")
        
    }
    
    func startConversation(){
        print("Start_Conversation_now")
    }
}
//MARK: extension for user like dislike methdo_first
extension NotificationUserDetailVC{
    func firebaseMatchEntry(UserID: String, UserName: String, UserType: String){
        let self_fb_id = Defaults[PDUserDefaults.UserID]
        var self_name = ""
        
        // Read/Get Data/decode userDefault data *****
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let userSaveData = try decoder.decode(Msg.self, from: data)
                self_name = "\(userSaveData.firstName!)"  //for first name
                print("self_name",self_name)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        //below code for create path on firebase database_
        let ref = Database.database().reference()
        
        //other
        let values1 = ["effect" : "true",
                       "match":"false",
                       "name":"\(UserName)",
                       "status":"0",
                       "time":"2",
                       "type":"\(UserType)",]
        
        ref.child("Match").child("\(self_fb_id)").child("\(UserID)").setValue(values1)
        
        //me
        let values2 = ["effect" : "false",
                       "match":"false",
                       "name":"\(self_name)",
                       "status":"0",
                       "time":"2",
                       "type":"\(UserType)",]
        
        ref.child("Match").child("\(UserID)").child("\(self_fb_id)").setValue(values2)
        
    }
    
    func detailGetFirebase(UserID: String, UserType: String){
        
        let ref = Database.database().reference()
        ref.child("Users").child("\(UserID)").child("token").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let firebaseTokenValue = snapshot.value as? String
            self.dismiss(animated: true, completion: nil)
            if firebaseTokenValue != nil{
                self.sendPushNotification(UserID: "\(UserID)", UserType: "\(UserType)", UserFireBaseToken: "\(firebaseTokenValue!)")
            }
            
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    
    //call API Push notification here
    func sendPushNotification(UserID: String, UserType: String, UserFireBaseToken: String){
        
        //        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        //        PKHUD.sharedHUD.show()
        print("sendPushNotification")
        
        let url = AppUrl.sendPushNotificationURL()
        
        var strSendPushUserImg1 = ""
        var strSendPushUserFirstName = ""
        var strSendPushMessage = ""
        var strSendPushActionType = ""
        
        // Read/Get Data/decode userDefault data *****
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let userSaveData = try decoder.decode(Msg.self, from: data)
                strSendPushUserImg1 = "\(userSaveData.image1!)"           //for images1
                print("uaer_Default_image1",strSendPushUserImg1)
                strSendPushUserFirstName = "\(userSaveData.firstName!)"  //for first name
                print("strUserFirstName",strSendPushUserFirstName)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        //set action and Message
        if UserType == "like" {
            strSendPushMessage = "Like you"
            strSendPushActionType = "like"
        }else if UserType == "dislike" {
            strSendPushMessage = "dislike you"
            strSendPushActionType = "dislike"
        }
        
        let parameters: [String: Any] = ["title" : "\(strSendPushUserFirstName)" ,
                                         "message" : "\(strSendPushMessage)",
                                         "icon" : "\(strSendPushUserImg1)" ,
                                         "tokon" : "\(UserFireBaseToken)" ,
                                         "senderid" : "\(Defaults[PDUserDefaults.UserID]) " ,
                                         "receiverid" : "\(UserID)" ,
                                         "action_type" : "\(strSendPushActionType)",
                                         "device" : "ios"]
        
        print("Url_sendPushNotification_is_here:-" , url)
        print("Param_sendPushNotification_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { (response) in
            //  PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.data != nil {
                
                //update:- API updateFromFirbaseServices call
                self.updateFromFirbaseServices()
                
                let responseJson = JSON(response.value!)
                print("Code_is_sendPushNotification",responseJson["success"])
                if responseJson["success"] == 1 {
                    if let responseData = response.data {
                        do {
                            
                            print("API Run Push Notification successfully")
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetSendPushNotificationModel.self, from: responseData)
                            
                            if dicData.success == 1 {
                                print("Push Notification success_true = ",dicData.success!)
                                //  //self.updateFromFirbaseServices()
                            }else{
                                print("Push Notification success_false = ",dicData.success!)
                                //  // self.updateFromFirbaseServices()
                            }
                            
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                }else if responseJson["success"] == 0 {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
        
    }
    
    
    //call API Update From Firebase
    func updateFromFirbaseServices(){
        let url = AppUrl.updateFromFirebaseURL()
        let parameters: [String: Any] = ["" : ""]
        
        print("Param_updateFromFirbaseServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            print("Response",response)
            print("updateFromFirbaseServices_is_Done")
        }
    }
    
}
