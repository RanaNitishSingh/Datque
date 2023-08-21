//
//  LikeYourProfileVC.swift
//  SocialApp
//
//  Created by mac on 07/01/22.
//

import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import SwiftUI
import Firebase
import FirebaseStorage
import SwiftyJSON

class LikeYourProfileVC: UIViewController {
    
    var userID = ""
    
    var arrUserPersonality = [String]()
    @IBOutlet weak var viewDetails: UIView!
    @IBOutlet weak var viewCongratulations: UIView!
    
    @IBOutlet weak var lblHaderName: UILabel!
    @IBOutlet weak var imgProfilePick: UIImageViewX!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabelX!
    @IBOutlet weak var imgImageOne: UIImageView!
    @IBOutlet weak var imgImegeTwo: UIImageView!
    @IBOutlet weak var imgImageThree: UIImageView!
    
    @IBOutlet weak var tblViewLikeYourProfile: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Call API Get user data
        self.getUserInfoService(phone: "\(self.userID)")
        
        self.viewDetails.superview?.bringSubviewToFront(self.viewDetails)
        // Do any additional setup after loading the view.
        print("LikeYourProfileVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func ActionLike(_ sender: Any) {
        self.viewCongratulations.superview?.bringSubviewToFront(self.viewCongratulations)
        //Call like API
    }
    
    @IBAction func ActionDislike(_ sender: Any) {
        //Call Dislike API
    }
    
    @IBAction func ActionDismissCongratutalionView(_ sender: Any) {
        self.viewDetails.superview?.bringSubviewToFront(self.viewDetails)
    }
    
    @IBAction func ActionStartConversationNow(_ sender: Any) {
        //Instanciate to chate screen
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC" ) as! ChatVC
//        VC.ReceiverID = userDic.rid!
//        VC.ReceiverName = userDic.name!
//        VC.ReceiverImg = userDic.pic!
//        VC.match_api_run = "" //for create new chat it will be 1 otherwise 0
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARK: extension for table view
extension LikeYourProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUserPersonality.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewLikeYourProfile.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        return cell
    }
    
}

//MARK: - extendion for getUserInfoService URL
extension LikeYourProfileVC{
    func getUserInfoService(phone:String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("getUserInfoService_1")
        let url = AppUrl.getUserInfoURL()
        
        let strPhone = phone.replacingOccurrences(of: "+", with: "")
        let parameters: [String: Any] = ["fb_id" : strPhone,
                                         "device" : "ios"]
        
        print("Url_getUserInfoURL_is_here:-" , url)
        print("Param_getUserInfoURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_getUserInfoURL",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetUserInfoData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                let objProfileUsr = (dicData.msg!.first)!
                                
                                self.lblHaderName.text = "\(objProfileUsr.firstName ?? "") \(objProfileUsr.lastName ?? "")" + "Likes your profile"
                                
                                //for profile image1
                                let strUserImg1 = objProfileUsr.image1 ?? ""
                                if strUserImg1 != nil && strUserImg1 != "" {
                                    var image = objProfileUsr.image1 ?? ""
                                   // print("image_user_not_Nil :-\(image)")
                                    image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                                    self.imgProfilePick.sd_setImage(with: URL(string: image), placeholderImage: nil)
                                }else {
                                   // print("image_user_Nil")
                                    self.imgProfilePick.image = #imageLiteral(resourceName: "ic_avatar")
                                }
                                //for name
                                self.lblName.text = "\(objProfileUsr.firstName ?? "") \(objProfileUsr.lastName!)"
                                //for status
                                self.lblStatus.text = "\(objProfileUsr.status ?? "")"
                                
                                //for image2
                                let strUserImg2 = objProfileUsr.image2 ?? ""
                                if strUserImg2 != nil && strUserImg2 != "" {
                                    var image = objProfileUsr.image2 ?? ""
                                   // print("image_user_not_Nil :-\(image)")
                                    image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                                    self.imgImageOne.sd_setImage(with: URL(string: image), placeholderImage: nil)
                                }else {
                                   // print("image_user_Nil")
                                    self.imgImageOne.image = #imageLiteral(resourceName: "ic_avatar")
                                }
                                
                                //for image3
                                let strUserImg3 = objProfileUsr.image3 ?? ""
                                if strUserImg3 != nil && strUserImg3 != "" {
                                    var image = objProfileUsr.image3 ?? ""
                                   // print("image_user_not_Nil :-\(image)")
                                    image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                                    self.imgImegeTwo.sd_setImage(with: URL(string: image), placeholderImage: nil)
                                }else {
                                   // print("image_user_Nil")
                                    self.imgImegeTwo.image = #imageLiteral(resourceName: "ic_avatar")
                                }
                                
                                //for image4
                                let strUserImg4 = objProfileUsr.image4 ?? ""
                                if strUserImg4 != nil && strUserImg4 != "" {
                                    var image = objProfileUsr.image4 ?? ""
                                   // print("image_user_not_Nil :-\(image)")
                                    image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                                    self.imgImageThree.sd_setImage(with: URL(string: image), placeholderImage: nil)
                                }else {
                                   // print("image_user_Nil")
                                    self.imgImageThree.image = #imageLiteral(resourceName: "ic_avatar")
                                }
                                
                                //append likeduser data in arrUserPersonality
                                self.arrUserPersonality = [] //first blank array
                                //for height
                                var likeUserheight = objProfileUsr.height ?? ""
                                if likeUserheight != "" && likeUserheight != nil {
                                    likeUserheight = "Height:" + likeUserheight
                                    self.arrUserPersonality.append(likeUserheight)
                                }
                                //for Weight
                                var likeUserWeightt = objProfileUsr.weight ?? ""
                                if likeUserWeightt != "" && likeUserWeightt != nil {
                                    likeUserWeightt = "Weight:" + likeUserWeightt
                                    self.arrUserPersonality.append(likeUserWeightt)
                                }
                                //for BodyType
                                var likeUserBodyType = objProfileUsr.bodyType ?? ""
                                if likeUserBodyType != "" && likeUserBodyType != nil {
                                    likeUserBodyType = "BodyType:" + likeUserBodyType
                                    self.arrUserPersonality.append(likeUserBodyType)
                                }
                                //for EyeColour
                                var likeUserEyeColour = objProfileUsr.eyeColor ?? ""
                                if likeUserEyeColour != "" && likeUserEyeColour != nil {
                                    likeUserEyeColour = "Eye Color:" + likeUserEyeColour
                                    self.arrUserPersonality.append(likeUserEyeColour)
                                }
                                //for HairColour
                                var likeUserHairColour = objProfileUsr.hairColor ?? ""
                                if likeUserHairColour != "" && likeUserHairColour != nil {
                                    likeUserHairColour = "Hair Color:" + likeUserHairColour
                                    self.arrUserPersonality.append(likeUserHairColour)
                                }
                                //for Gender
                                var likeUserGender = objProfileUsr.gender ?? ""
                                if likeUserGender != "" && likeUserGender != nil {
                                    likeUserGender = "Gender:" + likeUserGender
                                    self.arrUserPersonality.append(likeUserGender)
                                }
                                //for Dob
                                var likeUserDob = objProfileUsr.birthday ?? ""
                                if likeUserDob != "" && likeUserDob != nil {
                                    likeUserDob = "DOB:" + likeUserDob
                                    self.arrUserPersonality.append(likeUserDob)
                                }
                                //for BloodGroup
                                var likeUserBloodGroup = objProfileUsr.bloodGroup ?? ""
                                if likeUserBloodGroup != "" && likeUserBloodGroup != nil {
                                    likeUserBloodGroup = "Blood Group:" + likeUserBloodGroup
                                    self.arrUserPersonality.append(likeUserBloodGroup)
                                }
                                //for SkinType
                                var likeUserSkinType = objProfileUsr.skinType ?? ""
                                if likeUserSkinType != "" && likeUserSkinType != nil {
                                    likeUserSkinType = "SkinType:" + likeUserSkinType
                                    self.arrUserPersonality.append(likeUserSkinType)
                                }
                                //for Language
                                var likeUserLanguage = objProfileUsr.language ?? ""
                                if likeUserLanguage != "" && likeUserLanguage != nil {
                                    likeUserLanguage = "Language:" + likeUserLanguage
                                    self.arrUserPersonality.append(likeUserLanguage)
                                }
                                //for Profession
                                var likeUserProfession = objProfileUsr.profession ?? ""
                                if likeUserProfession != "" && likeUserProfession != nil {
                                    likeUserProfession = "Profession:" + likeUserProfession
                                    self.arrUserPersonality.append(likeUserProfession)
                                }
                                //for Religion
                                var likeUserReligion = objProfileUsr.religion ?? ""
                                if likeUserReligion != "" && likeUserReligion != nil {
                                    likeUserReligion = "Religion:" + likeUserReligion
                                    self.arrUserPersonality.append(likeUserReligion)
                                }
                                //for Education
                                var likeUserEducation = objProfileUsr.education ?? ""
                                if likeUserEducation != "" && likeUserEducation != nil {
                                    likeUserEducation = "Education:" + likeUserEducation
                                    self.arrUserPersonality.append(likeUserEducation)
                                }
                                
                                //reload table view
                                self.tblViewLikeYourProfile.reloadData()
                                
                                
                               
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
