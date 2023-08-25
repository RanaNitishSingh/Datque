//
//  AccountVC.swift
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

class AccountVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imgUser: UIImageViewX!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var ImgTik: UIImageView!
    @IBOutlet weak var btnTick: UIButtonX!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ImgTik.image = #imageLiteral(resourceName: "stop")
        self.btnTick.tag = 0
        self.showUserImg()
        print("AccountVC")
    }
    
    @IBAction func ActionTick(_ sender: Any) {
        
        if (sender as AnyObject).tag == 0 {//for tick
            self.ImgTik.image = #imageLiteral(resourceName: "deselect")
            self.btnTick.tag = 1
            self.showHideProfileService(btntag: "1")
        } else if (sender as AnyObject).tag == 1 {//for untick
            self.ImgTik.image = #imageLiteral(resourceName: "stop")
            self.btnTick.tag = 0
            self.showHideProfileService(btntag: "0")
        }
    }
    
    @IBAction func ActionChangeImage(_ sender: Any) {
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
    }
    
    @IBAction func ActionSignOut(_ sender: Any) {
        self.signOut()
    }
    
    @IBAction func ActionDeleteAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "Datque" , message: "Are you sure to delete Account?", preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "NO", style: UIAlertAction.Style.default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let action2  = UIAlertAction(title: "YES", style: UIAlertAction.Style.destructive) { _ in
            self.deleteAccount()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
}

extension AccountVC {
    func deleteAccount() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.deleteAccountURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "device" : "ios"]
        
        print("Url_deleteAccountURL_is_here:-" , url)
        print("Param_deleteAccountURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_deleteAccountURL",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(ShoworhideprofileData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                let dicFirstData = (dicData.msg!.first)!
                                Utils.RemovePersistentData()
                                let VC = self.storyboard!.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC
                                self.navigationController!.pushViewController(VC, animated: true)
//                                if dicFirstData.response! == "success"{
//                                    print("API run successfuly")
//
//                                    Utils.RemovePersistentData() // to remove all default data in application
//                                    let VC = self.storyboard!.instantiateViewController(withIdentifier: "PhoneNumberVC") as! PhoneNumberVC
//                                    self.navigationController!.pushViewController(VC, animated: true)
//                                }
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
    
    func GalleryMethod(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func CameraMethod() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.view.makeToast("Camera is not available")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
           let optimizedImageData = profileImage.jpegData(compressionQuality: 0.6)
        {
            
            // Set photoImageView to display the selected image.
            self.imgUser.image = profileImage//.normalizedImage()
            dismiss(animated: true, completion: nil)
            
            print("API update user profile image")
            //call API update user profile image
            uploadFirebaseImage(imageData: optimizedImageData)
        } else if let profileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                  let optimizedImageData = profileImage.jpegData(compressionQuality: 0.6)
        {
            
            // Set photoImageView to display the selected image.
            self.imgUser.image = profileImage//.normalizedImage()
            dismiss(animated: true, completion: nil)
            
            print("API update user profile image")
            uploadFirebaseImage(imageData: optimizedImageData)
        }
        
        picker.dismiss(animated: true, completion:nil)
    }
}

//extension for signout
extension AccountVC{
    func signOut(){
        
        let temStrFCM = "\(Defaults[PDUserDefaults.FCMToken])"
        Utils.RemovePersistentData() // to remove all default data in application
        Defaults[PDUserDefaults.FCMToken] = temStrFCM
        let alert = UIAlertController(title: "Datque", message: "Are you sure you want to signout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "SignOut", style: .destructive, handler: { action in
//             UserDefaults.standard.removeObject(forKey: "UserUid")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let VC = self.storyboard!.instantiateViewController(withIdentifier: "SpleshVC") as! SpleshVC
            self.navigationController!.pushViewController(VC, animated: true)
        }))
    }
}

//extension for API Call showHideProfileService
extension AccountVC{
    func showHideProfileService(btntag: String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.showorhideprofileURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])" ,
                                         "status" : btntag,
                                         "device" : "ios"]
        
        print("Url_showorhideprofileURLL_is_here:-" , url)
        print("Param_showorhideprofileURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_showorhideprofileURL",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(ShoworhideprofileData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                let dicFirstData = (dicData.msg!.first)!
                                if dicFirstData.response! == "success"{
                                    print("API run successfuly")
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

//extension for Default Data
extension AccountVC{
    func showUserImg(){
        // Read/Get Data/decode userDefault data *****
            if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    // Decode Note
                    let userSaveData = try decoder.decode(Msg.self, from: data)
                    
                    //for image
                    let strUserImg = "\(userSaveData.image1!)"
                    print("uaer_Default_image_is",strUserImg)
                    //show image to image view
                    if strUserImg != "0" && strUserImg != "" {
                        var image = "\(userSaveData.image1!)"
                        print("image_user_not_Nil :-\(image)")
                        image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                        self.imgUser.sd_setImage(with: URL(string: image), placeholderImage: nil)
                        
                    }else {
                        print("image_user_Nil")
                        self.imgUser.image = #imageLiteral(resourceName: "ic_avatar")
                    }
                    
                    //for first name
                    let strUserFirstName = "\(userSaveData.firstName!)"
                    //for age
                    let strUserAge = "\(userSaveData.age!)"
                    
                    self.lblNameAge.text = strUserFirstName + ", " + strUserAge
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
    }
}

extension AccountVC {
    
    func uploadFirebaseImage(imageData: Data) {
        Utility.showLoading()
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child("images/\(Defaults[PDUserDefaults.UserID]).jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            if error != nil {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                profileImageRef.downloadURL(completion: { [self] (url, error) in
                    print("Image URL: \((url?.absoluteString)!)")
                    let imgFireBasePath = "\((url?.absoluteString)!)"
                    //print("API call for signup Servies")
                    if imgFireBasePath != nil{
                        
                        self.ChangeProfilePictureServices(Img: imgFireBasePath)
                    }else{
                        print("Some error gating image path on firebase")
                    }
                })
            }
        }
    }
    
    func ChangeProfilePictureServices(Img: String) {
        let url = AppUrl.changeProfilePictureURL()
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "image_link" : "\(Img)",
                                         "device" : "ios"]
        
        print("Url_ChangeProfilePictureServices_is_here:-" , url)
        print("Param_ChangeProfilePictureServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { (response) in
            Utility.hideLoading()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_ChangeProfilePictureServices",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    print("getUserInfoService_to_call_0",Defaults[PDUserDefaults.UserID])
                    self.getUserInfoService(phone: Defaults[PDUserDefaults.UserID])
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code_201")
                }else{
                    print("Something went wrong in_json")
                }
            }
        }
    }
    
    func getUserInfoService(phone:String) {
        print("getUserInfoService_1")
        let url = AppUrl.getUserInfoURL()
        
        let strPhone = phone.replacingOccurrences(of: "+", with: "")
        let parameters: [String: Any] = ["fb_id" : strPhone,
                                         "device" : "ios"]
        
        print("Url_getUserInfoURL_is_here:-" , url)
        print("Param_getUserInfoURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
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
                            if (dicData.msg?.count)! > 0 {
                                let objProfileRes = (dicData.msg!.first)!
                                Defaults[PDUserDefaults.UserID] = "\(objProfileRes.fbID!)"
                                do {
                                    let encoder = JSONEncoder()
                                    let data = try encoder.encode(objProfileRes)
                                    UserDefaults.standard.set(data, forKey: "encodeUserData")
                                    self.showUserImg()
                                } catch {
                                    print("Unable to Encode Note (\(error))")
                                }
                            }
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
}
