//
//  EditProfileVC.swift
//  SocialApp
//
//  Created by mac on 17/12/21.
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
import MobileCoreServices
import AVKit
class EditProfileVC: UIViewController, GoToBackDelegate, GoToBackAppearanceDelegate, GoToBackDOBDelegate ,UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var ViewEditName: UIView!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var txtFirstName: UITextFieldX!
    @IBOutlet weak var txtLastName: UITextFieldX!
    
    @IBOutlet weak var lblUserNameAge: UILabel!
    @IBOutlet weak var txtAbouMe: UITextField!
    
    var userFNameFinal = ""
    var userLNameFinal = ""
    
    @IBOutlet weak var CollectionViewEditProfile: UICollectionView!
    var arrImgEditProfile: [String] = []
    var strUserImg1 = ""
    var strUserImg2 = ""
    var strUserImg3 = ""
    var strUserImg4 = ""
    var strUserImg5 = ""
    @IBOutlet weak var tblviewEditProfile: UITableView!
    var arrNameTitle = ["Living","Status","Children","Smoking","Drinking","Relationship","Appearance","male","DOB","Blood Group","Skin Type","Language","Profession","Religion","Education","Sexuality"]
    var arrNameTblViewEdit = ["","","","","","","","","","","","","","","",""]
    var arrImgTblViewEdit = [  #imageLiteral(resourceName: "home 1") , #imageLiteral(resourceName: "persons.png"),  #imageLiteral(resourceName: "baby.png"), #imageLiteral(resourceName: "smoke.png"), #imageLiteral(resourceName: "drink.png"), #imageLiteral(resourceName: "relation.png"), #imageLiteral(resourceName: "persons.png"), #imageLiteral(resourceName: "male"), #imageLiteral(resourceName: "MAsk"), #imageLiteral(resourceName: "blood"), #imageLiteral(resourceName: "group-face"), #imageLiteral(resourceName: "mdi_spoken-language.png"), #imageLiteral(resourceName: "mingcute_suitcase-2-fill.png"), #imageLiteral(resourceName: "religion 1"), #imageLiteral(resourceName: "study.png") ,  #imageLiteral(resourceName: "male")]
    var arrNameApperance = ["","","","",""]
    var strCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewMain.superview?.bringSubviewToFront(self.viewMain)
        self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
    }
    
    //Back ComeFrom CommomSelect Screen
    func Back(strSelectName: String, strScrentype: String) {
    
        let intScreenType = Int(strScrentype)!
        self.arrNameTblViewEdit[intScreenType] = "\(strSelectName)"
        self.tblviewEditProfile.reloadData()
    }
    
    //Back ComeApperance Screen
    func BackAppearance(finalAppearance: [String]) {
        print("come_From_ComeApperance ComeApperance",finalAppearance)
      
        let strMultiSelect = finalAppearance.joined(separator: "")
        self.arrNameTblViewEdit[6] = strMultiSelect
        self.arrNameApperance = finalAppearance
        self.tblviewEditProfile.reloadData()
    }
    
    //Back Form edit DOB Screen
    func BackDOB(finalDOB: String) {
        print("come_From_BackDOB BackDOB",finalDOB)
        self.arrNameTblViewEdit[8] = finalDOB
        self.tblviewEditProfile.reloadData()
    }
    
   
    @IBAction func ActionSaveEditProfile(_ sender: Any) {
        //Call API here editUserInfo
        if Defaults[PDUserDefaults.UserID] != nil {
            self.editUserInfoServices(userId: "\(Defaults[PDUserDefaults.UserID])")
        }else{
            self.view.makeToast("user if foud nil")
        }
        
    }
    
    @IBAction func ActionSignOutBtn(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC" ) as! AccountVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func ActionBasicInfo(_ sender: Any) {
//        self.txtFirstName.text = userFNameFinal
//        self.txtLastName.text = userLNameFinal
//
//        self.ViewEditName.superview?.bringSubviewToFront(self.ViewEditName)
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BasicInfoVC" ) as! BasicInfoVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionDoneEditName(_ sender: Any) {
        if !txtFirstName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            if !txtLastName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                //apply validation and change in userFNameFinal and userLNameFinal name label
                self.userFNameFinal = self.txtFirstName.text!
                self.userLNameFinal = self.txtLastName.text!
                
                // Read/Get Data/decode userDefault data *****
                if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
                    do {
                        // Create JSON Decoder
                        let decoder = JSONDecoder()
                        // Decode Note
                        let userSaveData = try decoder.decode(Msg.self, from: data)
                       
                        let strUserAge = "\(userSaveData.age!)"
                        print("strUserAge",strUserAge)
                        //for gendr
                        let strUserGender = "\(userSaveData.gender!)"
                        print("strUserGender",strUserGender)
                        self.lblUserNameAge.text = self.userFNameFinal + "," + strUserAge + ", " + strUserGender
                    }catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
                
                self.viewMain.superview?.bringSubviewToFront(self.viewMain)
            }else{
                self.view.makeToast("Enter Second name")
            }
        }else{
            self.view.makeToast("Enter First Name")
        }
    }
    
    @IBAction func btnActionCloseViewEditName(_ sender: Any) {
        self.viewMain.superview?.bringSubviewToFront(self.viewMain)
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func ActionContactUs(_ sender: Any) {
      let phoneNumber = "\(Defaults[PDUserDefaults.UserID])"
            guard let url = URL(string: "telprompt://\(phoneNumber)"),
                UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

//MARK: -Extension for table view
extension EditProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblviewEditProfile.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.lblTitle.text = self.arrNameTitle[indexPath.row]
        if arrNameTblViewEdit.count != 0 {
            cell.lblTblEditProfile.text = self.arrNameTblViewEdit[indexPath.row]
        }
        cell.ImgTblEditProfile.image = self.arrImgTblViewEdit[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let select = indexPath.row  //Screntype
        if select == 6 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "AppearanceVC" ) as! AppearanceVC
            VC.arrNameApperances = self.arrNameApperance
            VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
        else if select == 8 {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "DobVC" ) as! DobVC
            VC.strDob = self.arrNameTblViewEdit[8]
            VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }else {
            
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "BloodGroupVC" ) as! BloodGroupVC
            
            if select == 0 {
                VC.Screntype = "0"
                VC.SelectItemName = self.arrNameTitle[0]
            }else if select == 1 {
                VC.Screntype = "1"
                VC.SelectItemName = self.arrNameTitle[1]
            }else if select == 2 {
                VC.Screntype = "2"
                VC.SelectItemName = self.arrNameTitle[2]
            }else if select == 3 {
                VC.Screntype = "3"
                VC.SelectItemName = self.arrNameTitle[3]
            }else if select == 4 {
                VC.Screntype = "4"
                VC.SelectItemName = self.arrNameTitle[4]
            }else if select == 5 {
                VC.Screntype = "5"
                VC.SelectItemName = self.arrNameTitle[5]
            }
            //            else if select == 6 {
            //                VC.Screntype = "6"
            //                VC.SelectItemName = self.arrNameTitle[6]
            //            }
            else if select == 7 {
                VC.Screntype = "7"
                VC.SelectItemName = self.arrNameTitle[7]
            }
            else if select == 9 {
                VC.Screntype = "9"
                VC.SelectItemName = self.arrNameTitle[9]
            }
            else if select == 10 {
                VC.Screntype = "10"
                VC.SelectItemName = self.arrNameTitle[10]
            }else if select == 11 {
                VC.Screntype = "11"
                VC.SelectItemName = self.arrNameTitle[11]
            }else if select == 12 {
                VC.Screntype = "12"
                VC.SelectItemName = self.arrNameTitle[12]
            }else if select == 13 {
                VC.Screntype = "13"
                VC.SelectItemName = self.arrNameTitle[13]
            }else if select == 14 {
                VC.Screntype = "14"
                VC.SelectItemName = self.arrNameTitle[14]
            }else if select == 15 {
                VC.Screntype = "15"
                VC.SelectItemName = self.arrNameTitle[15]
            }
            
            VC.delegate = self
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
}

//MARK: Extenction for collection view
extension EditProfileVC: UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrImgEditProfile.count == 5{
            return 5
        }else if self.arrImgEditProfile.count < 5 {
            return self.arrImgEditProfile.count + 1
        }
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = CollectionViewCell()
        var image = ""
        var Path_ext = ""
        var video_url: URL?
        if self.arrImgEditProfile.count >= 1 && self.arrImgEditProfile.count > indexPath.row {
            
            image =  self.arrImgEditProfile[indexPath.row]
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            print("image_user_not_Nil\(indexPath.row)_is :-\(image)")
            video_url = URL(string: image)
            Path_ext = video_url!.pathExtension  // "mp4"
            
        }
        print("pathExtention",Path_ext)
        if Path_ext != "mp4"
        {
            cell = self.CollectionViewEditProfile.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.imgEditProfile.sd_setImage(with: URL(string: image), placeholderImage: nil)
            cell.btnDeleteEditProfile.tag = indexPath.row
            cell.btnDeleteEditProfile.addTarget(self, action: #selector(DeleteProfilePickMethod(_:)), for: .touchUpInside)
            
            if indexPath.row == 0 || indexPath.row == self.arrImgEditProfile.count {
                cell.viewDeleteEditProfile.isHidden = true
                
                if indexPath.row == self.arrImgEditProfile.count {
                    cell.imgEditProfile.image = nil
                }
                
            }else{
                cell.viewDeleteEditProfile.isHidden = false
            }
            return cell
        }else
        {
            cell = self.CollectionViewEditProfile.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! CollectionViewCell
            
            print("videoURL = \(video_url!)")
            cell.videoplayer = AVPlayer(url: video_url!)
            cell.playerViewController.view.backgroundColor = UIColor.white
            cell.playerViewController.player = cell.videoplayer
            cell.playerViewController.view.frame = cell.videoView.frame
            cell.playerViewController.showsPlaybackControls = false
            cell.playerViewController.player?.play()
            cell.videoView.addSubview(cell.playerViewController.view)
            
            cell.btnDeleteEditProfile.tag = indexPath.row
            cell.btnDeleteEditProfile.addTarget(self, action: #selector(DeleteProfilePickMethod(_:)), for: .touchUpInside)
            
            if indexPath.row == 0 || indexPath.row == self.arrImgEditProfile.count {
                cell.viewDeleteEditProfile.isHidden = true
                
                if indexPath.row == self.arrImgEditProfile.count {
                    cell.imgEditProfile.image = nil
                }
                
            }else{
                cell.viewDeleteEditProfile.isHidden = false
                cell.videoView.addSubview(cell.viewDeleteEditProfile)
            }
            return cell
        }
        
    }
    
    @IBAction func DeleteProfilePickMethod(_ sender: UIButton){
        let tag = sender.tag
        print("Delete_index",tag)
        //call API deleteImages for server side
        let img = self.arrImgEditProfile[tag]
        //Call uploadImages URL for server side upload image
        self.userDeleteImages(Img: "\(img)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = indexPath.row
        print("selectedCell_is",indexPath.row)
        if self.arrImgEditProfile.count == selectedCell{
            print("Select camera")
            //Create alert of selection
            let alert = UIAlertController(title: "Update Profile Picture" , message: nil, preferredStyle: UIAlertController.Style.alert)
            let action1 = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default) { _ in
                self.CameraMethod()
            }
            let action2  = UIAlertAction(title: "Choose from Library", style: UIAlertAction.Style.default) { (action) in
                self.GalleryMethod()
            }
            let action3 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action1)
            alert.addAction(action2)
            alert.addAction(action3)
            self.present(alert, animated: true, completion: nil)
        }else{
            
        }
    }
    
    
}

//MARK: - Extension for show user default data
extension EditProfileVC {
    func showUserDefaultData(){
        // Read/Get Data/decode userDefault data *****
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let userSaveData = try decoder.decode(Msg.self, from: data)
                
                //blank array
                self.arrImgEditProfile = []
                
                //for images1
                
                strUserImg1 = "\(userSaveData.image1!)"
                print("uaer_Default_image1",strUserImg1)
                if strUserImg1 != "0" && strUserImg1 != "" {
                    let strImage1 = "\(userSaveData.image1!)"
                    //append this str user image in array of arrImgEditProfile
                    self.arrImgEditProfile.append(strImage1)
                }
                
                //for images2
                strUserImg2 = "\(userSaveData.image2!)"
              
                if strUserImg2 != "0" && strUserImg2 != "" {
                    let strImage2 = "\(userSaveData.image2!)"
                    //append this str user image in array of arrImgEditProfile
                    self.arrImgEditProfile.append(strImage2)
                }
                
                //for images3
                strUserImg3 = "\(userSaveData.image3!)"
                print("uaer_Default_image3",strUserImg3)
                if strUserImg3 != "0" && strUserImg3 != "" {
                    let strImage3 = "\(userSaveData.image3!)"
                    //append this str user image in array of arrImgEditProfile
                    self.arrImgEditProfile.append(strImage3)
                }
                strUserImg4 = "\(userSaveData.image4!)"
                print("uaer_Default_image4",strUserImg4)
                if strUserImg4 != "0" && strUserImg4 != "" {
                    let strImage4 = "\(userSaveData.image4!)"
                    //append this str user image in array of arrImgEditProfile
                    self.arrImgEditProfile.append(strImage4)
                }
                strUserImg5 = "\(userSaveData.image5!)"
                print("uaer_Default_image5",strUserImg5)
                if strUserImg5 != "0" && strUserImg5 != "" {
                    let strImage5 = "\(userSaveData.image5!)"
                    //append this str user image in array of arrImgEditProfile
                    self.arrImgEditProfile.append(strImage5)
                }
                //Now reload collection view which can show user images
                if self.arrImgEditProfile.count != 0 {
                    self.CollectionViewEditProfile.reloadData() }
                
                //for first name
                let strUserFirstName = "\(userSaveData.firstName!)"
                self.userFNameFinal = strUserFirstName
                print("strUserFirstName",strUserFirstName)
                //for Last name
                let strUserLastName = "\(userSaveData.lastName!)"
                self.userLNameFinal = strUserLastName
                print("strUserLastName",strUserLastName)
                //for age
                let strUserAge = "\(userSaveData.age!)"
                print("strUserAge",strUserAge)
                //for gendr
                let strUserGender = "\(userSaveData.gender!)"
                print("strUserGender",strUserGender)
                self.lblUserNameAge.text = strUserFirstName + "," + strUserAge + ", " + strUserGender
                
                //for Amboume
                let strUserAboutMe = "\(userSaveData.aboutMe ?? "")"
                self.txtAbouMe.text = strUserAboutMe
                print("strUserAboutMe",strUserAboutMe)
                
                //-------------
                
                //for height
                let strUserheight = "\(userSaveData.height ?? "")"
                if strUserheight != "" {
                    strCount = strCount + 1
                    self.arrNameApperance[0] = strUserheight }
                print("strUserheight",strUserheight)
                
                //for Weight
                
                let strUserWeightt = "\(userSaveData.weight ?? "")"
                if strUserWeightt != "" {
                    strCount = strCount + 1
                    self.arrNameApperance[1] = strUserWeightt }
                print("strUserWeightt",strUserWeightt)
                
                //for BodyType
                let strUserBodyType = "\(userSaveData.bodyType ?? "")"
                if strUserWeightt != "" {
                strCount = strCount + 1
                self.arrNameApperance[2] = strUserBodyType
                    print("strUserBodyType",strUserBodyType)
                }
                
                //for EyeColour
                let strUserEyeColour = "\(userSaveData.eyeColor ?? "")"
                if strUserEyeColour != "" {
                    strCount = strCount + 1
                    self.arrNameApperance[3] = strUserEyeColour }
                print("strUserEyeColour",strUserEyeColour)
                
                //for HairColour
                let strUserHairColour = "\(userSaveData.hairColor ?? "")"
                if strUserHairColour != "" {
                    strCount = strCount + 1
                    self.arrNameApperance[4] = strUserHairColour}
                print("strUserHairColour",strUserHairColour)
                self.arrNameTblViewEdit[6] = strUserWeightt + "," +  strUserheight + "," + strUserBodyType + "," + strUserEyeColour + "," + strUserHairColour
                //--------------
                
                //for Status
                
                let strUserStatus = "\(userSaveData.status ?? "")"
                if strUserStatus != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[1] = strUserStatus }
                print("strUserStatus",strUserStatus)
                
                //for Gender
                if strUserGender != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[7] = strUserGender }
                
                //for DOB
                
                let strUserDOB = "\(userSaveData.birthday ?? "")"
                if strUserDOB != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[8] = strUserDOB }
                print("strUserDOB",strUserDOB)
                
                //for BloodGroup
                
                let strUserBloodGroup = "\(userSaveData.bloodGroup ?? "")"
                if strUserBloodGroup != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[9] = strUserBloodGroup }
                print("strUserBloodGroup",strUserBloodGroup)
                //for Living
                
                let strUserliving = "\(userSaveData.living ?? "")"
                if strUserliving != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[0] = strUserliving }
                print("strUserLivin",strUserliving)
                //for children
                
                let strUserchildren = "\(userSaveData.children ?? "")"
                if strUserchildren != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[2] = strUserchildren }
                print("children",strUserchildren)
                //for smoking
                
                let strUsersmoking = "\(userSaveData.smoking ?? "")"
                if strUsersmoking != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[3] = strUsersmoking }
                print("smoking",strUsersmoking)
                //for drinking
                
                let strUserdrinking = "\(userSaveData.drinking ?? "")"
                if strUserdrinking != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[4] = strUserdrinking }
                print("drinking",strUserdrinking)
                //for relationship
                
                let strUserrelationship = "\(userSaveData.relationship ?? "")"
                if strUserdrinking != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[5] = strUserrelationship }
                print("relationship",strUserrelationship)
                //for SkinType
                
                let strUserSkinType = "\(userSaveData.skinType ?? "")"
                if strUserSkinType != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[10] = strUserSkinType }
                print("strUserSkinType",strUserSkinType)
                
                //for Language
                
                let strUserLanguage = "\(userSaveData.language ?? "")"
                if strUserLanguage != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[11] = strUserLanguage}
                print("strUserLanguage",strUserLanguage)
                
                //for religion
                
                let strUserProfession = "\(userSaveData.profession ?? "")"
                if strUserProfession != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[12] = strUserProfession }
                print("strUserProfession",strUserProfession)
                
                //for Profession
                
                let strUserReligion = "\(userSaveData.religion ?? "")"
                if strUserReligion != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[13] = strUserReligion }
                print("strUserReligion",strUserReligion)
                
                //for education
                
                let strUserEducation = "\(userSaveData.education ?? "")"
                if strUserEducation != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[14] = strUserEducation
                    print("strUserEducation",strUserEducation) }
                //for sexuality
                
                let strUsersexuality = "\(userSaveData.sexuality ?? "")"
                if strUsersexuality != "" {
                    strCount = strCount + 1
                    self.arrNameTblViewEdit[15] = strUsersexuality
                    }
                
                let result = Double(strCount) / Double(arrNameTitle.count) * Double(100)
                Defaults[PDUserDefaults.ProfileValue] = (result)
                self.tblviewEditProfile.reloadData()
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
}

//MARK: - extension for get user info services
extension EditProfileVC{
    func getUserInfoService(phone:String) {
        //        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        //        PKHUD.sharedHUD.show()
        print("getUserInfoService_1")
        let url = AppUrl.getUserInfoURL()
        
        let strPhone = phone.replacingOccurrences(of: "+", with: "")
        let parameters: [String: Any] = ["fb_id" : strPhone,
                                         "device" : "ios"]
        
        print("Url_getUserInfoURL_is_here:-" , url)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            //PKHUD.sharedHUD.hide()
            Utility.hideLoading()
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
                                let objProfileRes = (dicData.msg!.first)!
                                
                                //Default save user is login
                                Defaults[PDUserDefaults.UserID] = "\(objProfileRes.fbID!)"
                                print("Defaults_PDUser_Defaults_UserID",objProfileRes.fbID!)
                                
                                //to save default user data with json encode *****
                                do {
                                    // Create JSON Encoder
                                    let encoder = JSONEncoder()
                                    
                                    // Encode Note
                                    let data = try encoder.encode(objProfileRes)
                                    
                                    // Write/Set Data
                                    UserDefaults.standard.set(data, forKey: "encodeUserData")
                                    
                                    //Show user default data
                                    self.showUserDefaultData()
                                    
                                } catch {
                                    print("Unable to Encode Note (\(error))")
                                }
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

//MARK: - Extenction for (Camera and Gallery image select)
extension EditProfileVC {
    
    func GalleryMethod(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        //imagePicker.mediaTypes = ["public.image"]
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func CameraMethod() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
             imagePicker.mediaTypes = ["public.image", "public.movie"]
            
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.view.makeToast("Camera is not available")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print(videoURL)
            uploadVideoTofirebase(file: videoURL)
        }
        
        
        if let profileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
           let optimizedImageData = profileImage.jpegData(compressionQuality: 0.6)
        {
            print("call",optimizedImageData)
            // upload image from here
            uploadFirebaseImage(imageData: optimizedImageData)
        }
        picker.dismiss(animated: true, completion:nil)
    }
}

//MARK: - Extension for upload image on firebase storage
extension EditProfileVC{
    
    func uploadFirebaseImage(imageData: Data)
    {
        //        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        //        activityIndicator.startAnimating()
        //        activityIndicator.center = self.view.center
        //        self.view.addSubview(activityIndicator)
        Utility.showLoading()
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child("images/\(UUID().uuidString)")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
           
            //            activityIndicator.stopAnimating()
            //            activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                profileImageRef.downloadURL(completion: { [self] (url, error) in
                    print("imgFireBasePath URL: \((url?.absoluteString)!)")
                    let img = (url?.absoluteString)!
                    //Call uploadImages URL for server side upload image
                    self.userUploadImages(Img: "\(img)")
                    
                })
            }
        }
    }
    func uploadVideoTofirebase(file: URL) {
        Utility.showLoading()
//        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
//        activityIndicator.startAnimating()
//        activityIndicator.center = self.view.center
//        self.view.addSubview(activityIndicator)
//
        
        let name = "\(Int(Date().timeIntervalSince1970)).mp4"
        do {
            let data = try Data(contentsOf: file)
            
            let storageRef =
            Storage.storage().reference().child("videos/\(UUID().uuidString)").child(name)
            if let uploadData = data as Data? {
                let metaData = StorageMetadata()
                metaData.contentType = "video/mp4"
                storageRef.putData(uploadData, metadata: metaData
                                   , completion: { (metadata, error) in
//                    activityIndicator.stopAnimating()
           //         activityIndicator.removeFromSuperview();
                    if let error = error {
                        
                    }else{
                        storageRef.downloadURL { (url, error) in
                            guard let downloadURL = url else {
                                
                                return
                            }
                            print("imgFireBasePath URL: \((url?.absoluteString)!)")
                            let img = (url?.absoluteString)!
                            //Call uploadImages URL for server side upload image
                            // self.uploadVideoTofirebase(file: downloadURL)
                            self.userUploadImages(Img: "\(img)");                                            print("downloadURL",downloadURL)
                        }
                    }
                })
            }
        }catch let error {
            print(error.localizedDescription)
        }
        
    }
}

//MARK: - Extension for uploadImages image URL
extension EditProfileVC{
    func userUploadImages(Img:String) {
        //        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        //        PKHUD.sharedHUD.show()
       // Utility.showLoading()
        print("UploadImages Services")
        let url = AppUrl.uploadImagesURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "image_link" : "\(Img)",
                                         "device" : "ios"]
        
        
        
        print("Url_UploadImages_is_here:-" , url)
        print("Param_UploadImages_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            //PKHUD.sharedHUD.hide()
            Utility.hideLoading()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_UploadImages",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    print("Upload image successfully on our Server")
                    //CAll API get user info services
                    self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
                    self.CollectionViewEditProfile.reloadData()
                    
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
    }
    
}

//MARK: - Extension for deleteImages image URL
extension EditProfileVC{
    func userDeleteImages(Img:String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("DeleteImages Services")
        let url = AppUrl.deleteImagesURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "image_link" : "\(Img)",
                                         "device" : "ios"]
        
        
        print("Url_DeleteImages_is_here:-" , url)
        print("Param_DeleteImages_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_DeleteImages",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    print("Delete image successfully on our Server")
                    //CAll API get user info services
                    self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
                    
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
    }
}

//MARK: - Extension for resize the image with its size
extension EditProfileVC {
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

//MARK: - Extension for resize the image with its size
extension EditProfileVC{
    func editUserInfoServices(userId: String){
        
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("editUserInfoServices Services")
        let url = AppUrl.editProfileInfoURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "birthday" : self.arrNameTblViewEdit[8] ,
                                         "about_me" : self.txtAbouMe.text! as Any ,
                                         "gender" : self.arrNameTblViewEdit[7],
                                         "status" : self.arrNameTblViewEdit[1],
                                         "height" : self.arrNameApperance[0] ,
                                         "weight" : self.arrNameApperance[1],
                                         "body_type" : self.arrNameApperance[2],
                                         "eye_color" : self.arrNameApperance[3],
                                         "hair_color" : self.arrNameApperance[4],
                                         "blood_group" : self.arrNameTblViewEdit[9],
                                         "skin_type" : self.arrNameTblViewEdit[10],
                                         "language" : self.arrNameTblViewEdit[11],
                                         "profession" : self.arrNameTblViewEdit[12],
                                         "religion" : self.arrNameTblViewEdit[13],
                                         "education" : self.arrNameTblViewEdit[14],
                                         "first_name" : "\(self.userFNameFinal)",
                                         "last_name" : "\(self.userLNameFinal)",
                                         "device" : "ios",
                                         "image1" : strUserImg1,
                                         "image2" : strUserImg2,
                                         "image3" : strUserImg3 ,
                                         "image4" : strUserImg4,
                                         "image5" : strUserImg5,
                                         "job_title": "",
                                         "company": "",
                                         "school": "",
                                         "living" :  self.arrNameTblViewEdit[0],
                                         "children" : self.arrNameTblViewEdit[2],
                                         "smoking" :  self.arrNameTblViewEdit[3],
                                         "drinking" : self.arrNameTblViewEdit[4],
                                         "relationship" : self.arrNameTblViewEdit[5],
                                         "sexuality": self.arrNameTblViewEdit[15]]
        print("Url_editUserInfoServices_is_here:-" , url)
        print("Param_editUserInfoServices_is_here:-" , parameters)         
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_editUserInfoServices",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    print("editUserInfoServices successfully")
                    //CAll API get user info services
                    self.view.makeToast("Profile update successfully!")
                    self.navigationController?.popViewController(animated: true)
                    self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
                    
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
    }
    
}

