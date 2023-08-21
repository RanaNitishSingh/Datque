//
//  NearProfileVC.swift
//  SocialApp
//
//  Created by mac on 20/6/22.
//

import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON

class NearProfileVC: UIViewController, NotificationUserDetailDelegate {
    
    @IBOutlet weak var lblSubscribeUS: UILabel!
    @IBOutlet weak var collectionViewLikes: UICollectionView!
    var arrDicProfileLikes = [MsguserNearByMe]() //this is array of dictionary type MsgGetProfileLikesData
    var strLat = ""
    var strLon = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscribeus label
        self.lblSubscribeUS.isHidden = false
        //Call API myLikiesService
        self.userNearByMeServices()
        // Do any additional setup after loading the view.
        print("ProfileLikeVC")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.unselectedItemTintColor = .black
        self.tabBarController?.tabBar.tintColor = .black
        self.userNearByMeServices()
    }
    
    
    @IBAction func FilterBtnAction(_ sender: Any) {
        Defaults[PDUserDefaults.ResetFilter] = ""
        Defaults[PDUserDefaults.Distance] = ""
        Defaults[PDUserDefaults.Gender] = ""
        Defaults[PDUserDefaults.AgeMin] = ""
        Defaults[PDUserDefaults.AgeMax] = ""
        Defaults[PDUserDefaults.MarriedStatus] = ""
        Defaults[PDUserDefaults.Height] = ""
        Defaults[PDUserDefaults.Weight] = ""
        Defaults[PDUserDefaults.BloodGroup] = ""
        Defaults[PDUserDefaults.SkinType] = ""
        Defaults[PDUserDefaults.Language] = ""
        Defaults[PDUserDefaults.Profession] = ""
        Defaults[PDUserDefaults.Religion] = ""
        Defaults[PDUserDefaults.Education] = ""
        Defaults[PDUserDefaults.BodyType] = ""
        Defaults[PDUserDefaults.HairColor] = ""
        Defaults[PDUserDefaults.EyeColor] = ""
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        VC.strLat = self.strLat
        VC.strLon = self.strLon
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
}

//MARK: - Extension for collection view
extension NearProfileVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrDicProfileLikes != nil && self.arrDicProfileLikes.count >= 1{
            self.lblSubscribeUS.isHidden = true
        }
        return self.arrDicProfileLikes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewLikes.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let dicUserData = self.arrDicProfileLikes[indexPath.row]
        print(dicUserData)
       // let dicProfileInfo = dicUserData.ima
        
        //for image
        let strUserImg = dicUserData.image1!
        if strUserImg != nil && strUserImg != "" {
            var image = dicUserData.image1
           // print("image_user_not_Nil :-\(image)")
            image = image!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgcollectionViewLikes.sd_setImage(with: URL(string: image!), placeholderImage: nil)
        }else {
           // print("image_user_Nil")
            cell.imgcollectionViewLikes.image = #imageLiteral(resourceName: "avatar")
        }
//
//        //for name
        cell.lblcollectionViewLikes.text = "\(dicUserData.firstName!)"
        
        return cell
    }
    
    //did select row at index path
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectindex = indexPath.row
        self.infoTapSwipe(Index: selectindex)
//        let selectUserData = self.arrDicProfileLikes[selectindex]
//       // let dicProfileInfo = selectUserData.profileInfo
//        let selectUserId = selectUserData.fbID ?? ""
//        print("selectUserId_is_here",selectUserId)
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LikeYourProfileVC" ) as! LikeYourProfileVC
//        VC.userID = selectUserId
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func infoTapSwipe(Index: Int){
//        print("infoTapSwipe",Index)
//        if self.arrDicProfileLikes.count != 0 {
//            let dictuser = self.arrDicProfileLikes[Index]
//            print("dictuser",dictuser)
//            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "NotificationUserDetailVC") as! NotificationUserDetailVC
//            popoverContent.modalPresentationStyle = .popover
//            popoverContent.dicGetUserNotifications = dictuser
//            self.present(popoverContent, animated: true, completion: nil)
//        }
        
        print("infoTapSwipe", Index)
        if self.arrDicProfileLikes.count != 0 {
            let dictuser = self.arrDicProfileLikes[Index]
            print("dictuser", dictuser)
            
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "NotificationUserDetailVC") as! NotificationUserDetailVC
            popoverContent.modalPresentationStyle = .popover
            popoverContent.dicGetUserNotifications = dictuser
            popoverContent.delegate = self // Set the delegate to receive dismissal callback
            
            self.present(popoverContent, animated: true, completion: nil)
        }
        
    }
    func notificationUserDetailDismissed() {
        self.userNearByMeServices() // Reload collection view after dismissal
        }
    
}

//MARK: - extension foe api call MylikesURL
extension NearProfileVC{ //this post raw API here for alamofire 5.5
    func userNearByMeServices() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("userNearByMeServices")
        
        let url = AppUrl.userNearByMeURL()
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])" ,
                                         "lat_long" : "\(Defaults[PDUserDefaults.UserLat]), \(Defaults[PDUserDefaults.UserLng])",
                                         "gender" :  Defaults[PDUserDefaults.Gender] ?? "all",
                                         "distance" : "\(Defaults[PDUserDefaults.Distance] ?? "10000" )" ,
                                         "device_token" : "\(Defaults[PDUserDefaults.FCMToken]) " ,
                                         "device" : "ios" ,
                                         "age_min" : "\(Defaults[PDUserDefaults.AgeMin])",
                                         "age_max" : "\(Defaults[PDUserDefaults.AgeMax])"  ,
                                         "version" : "1.0" ,
                                         "purchased" : "1" ,
                                         "height" : "\(Defaults[PDUserDefaults.Height])",
                                         "weight" : "\(Defaults[PDUserDefaults.Weight])" ,
                                         "blood_group" : "\(Defaults[PDUserDefaults.BloodGroup])" ,
                                         "skin_type" : "\(Defaults[PDUserDefaults.SkinType])" ,
                                         "language" : "\(Defaults[PDUserDefaults.Language])" ,
                                         "profession" : Defaults[PDUserDefaults.Profession] ,
                                         "religion" : "\(Defaults[PDUserDefaults.Religion])" ,
                                         "education" : "\(Defaults[PDUserDefaults.Education])" ,
                                         "body_type" : "\(Defaults[PDUserDefaults.BodyType])" ,
                                         "hair_color" : "\(Defaults[PDUserDefaults.HairColor])" ,
                                         "eye_color" : "\(Defaults[PDUserDefaults.EyeColor])"]
        
        print("Url_userNearByMeServices_is_here:-" , url)
        print("Param_userNearByMeServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_userNearByMeServices",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(userNearByMeData.self, from: responseData)
                            
    //po print(try JSONSerialization.jsonObject(with: responseData, options: []))
                            self.arrDicProfileLikes = dicData.msg!
                            self.collectionViewLikes.reloadData()
                            print("arrDicNearbyUser_Count_-1")
//                            self.kolodaView.reloadData()
                           
                            
//                            if (dicData.msg?.count)! > 0 {
//                                let objProfileRes = (dicData.msg!.first)!
//                                let userid = objProfileRes.fbID
//                                //call api get User data
//                                self.getUserInfoService(phone: userid!)
//                            }
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

