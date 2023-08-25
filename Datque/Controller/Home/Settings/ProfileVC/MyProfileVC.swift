//
//  MyProfileVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
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
import ABGaugeViewKit

class MyProfileVC: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var meterView: ABGaugeView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserNameAge: UILabel!
    @IBOutlet weak var lblTotalLikes: UILabelX!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var progressBar: CircularProgressBar!
    
    @IBOutlet weak var activeLbl: UILabel!
    @IBOutlet weak var lowHighLbl: UILabel!
    var progress: Double = 40
    var userPurchasedData: Msg?
    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(startUpload), with: nil, afterDelay: 1.0)
        
        if self.userPurchasedData?.purchased == "0"{
            self.lowHighLbl.text = "Very Low"
            self.activeLbl.text = "Not Activate"
        }else {
            self.lowHighLbl.text = "Very High"
            self.activeLbl.text = "Activate"

        }
    }
    
    //MARK: - Start uploading
    @objc func startUpload() {
        progressBar.labelSize = 15
        if Defaults[PDUserDefaults.ProfileValue] == 0 {
            progressBar.setProgress(to: 10.0, withAnimation: true)
        }else{
            progressBar.setProgress(to: Defaults[PDUserDefaults.ProfileValue], withAnimation: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.getUserLikeDislike()
        self.getUserInfoService(phone: Defaults[PDUserDefaults.UserID])
        self.tabBarController?.tabBar.unselectedItemTintColor = .black
        self.tabBarController?.tabBar.tintColor = .black
    }
    
    @IBAction func ActionOpenGallery(_ sender: Any) {
        print("upload image")
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
    
    @IBAction func ActionFilter(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionGoSetting(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC" ) as! SettingsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionGoEditProfile(_ sender: Any) {//EditProfileVC
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC" ) as! EditProfileVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionGoProfileLike(_ sender: Any) {
        
        if Defaults[PDUserDefaults.descYourself] == "" || Defaults[PDUserDefaults.relationship] == "" || Defaults[PDUserDefaults.living] == "" || Defaults[PDUserDefaults.children] == "" || Defaults[PDUserDefaults.smoking] == "" || Defaults[PDUserDefaults.drinking] == "" {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileStepVC" ) as! ProfileStepVC
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC" ) as! EditProfileVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @IBAction func ActionKeyPremiumActivate(_ sender: Any) {
        if self.userPurchasedData?.purchased == "0" {
             let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPlaneVC" ) as! SelectPlaneVC
             self.navigationController?.pushViewController(VC, animated: true)
        }else if  self.userPurchasedData?.purchased == "1"{
            let alert = UIAlertController(title: "Datque", message: "you have already purchased this subscriptions", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
              //  self.present(alert, animated: true, completion: nil)
                print("you have already purchased this subscriptions")

            }))
          }
    }
    
    @IBAction func ActionPopularityVeryLow(_ sender: Any) {
        if self.userPurchasedData?.purchased == "0" {
             let VC = self.storyboard?.instantiateViewController(withIdentifier: "SelectPlaneVC" ) as! SelectPlaneVC
             self.navigationController?.pushViewController(VC, animated: true)
        }else if  self.userPurchasedData?.purchased == "1"{
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "ScreenBoostVC" ) as! ScreenBoostVC
            self.navigationController?.pushViewController(VC, animated: true)
        }
     }
}

//MARK: - Extenction for (Camera and Gallery image select)
extension MyProfileVC {
    
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
            self.imgUserProfile.image = profileImage//.normalizedImage()
            dismiss(animated: true, completion: nil)
            
            print("API update user profile image")
            //call API update user profile image
            uploadFirebaseImage(imageData: optimizedImageData)
            } else if let profileImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let optimizedImageData = profileImage.jpegData(compressionQuality: 0.6)
              {
              
              // Set photoImageView to display the selected image.
              self.imgUserProfile.image = profileImage//.normalizedImage()
              dismiss(animated: true, completion: nil)
              
              print("API update user profile image")
               uploadFirebaseImage(imageData: optimizedImageData)
              }
        
            picker.dismiss(animated: true, completion:nil)
    }
}


//MARK: - Extension for upload image on firebase storage
extension MyProfileVC{
    
    func uploadFirebaseImage(imageData: Data) {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
//            Utility.showLoading()
            let storageReference = Storage.storage().reference()
            let profileImageRef = storageReference.child("images/\(Defaults[PDUserDefaults.UserID]).jpg")
            
            let uploadMetaData = StorageMetadata()
            uploadMetaData.contentType = "image/jpeg"
            
            profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
                
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                
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
}

extension MyProfileVC {
    func ChangeProfilePictureServices(Img: String) {
        let url = AppUrl.changeProfilePictureURL()
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "image_link" : "\(Img)",
                                         "device" : "ios"]
        
        print("Url_ChangeProfilePictureServices_is_here:-" , url)
        print("Param_ChangeProfilePictureServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
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
                                self.userPurchasedData = objProfileRes
                                Defaults[PDUserDefaults.UserID] = "\(objProfileRes.fbID!)"
                                print("Defaults_PDUser_Defaults_UserID",objProfileRes.fbID!)
                                self.meterView.needleValue = 30
                                do {
                                    let encoder = JSONEncoder()
                                    let data = try encoder.encode(objProfileRes)
                                    UserDefaults.standard.set(data, forKey: "encodeUserData")
                                    self.showUserImg()
                                } catch {
                                    print("Unable to Encode Note (\(error))")
                                    self.meterView.needleValue = 30
                                }
                            }
                    } catch {
                        self.meterView.needleValue = 30
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

//MARK: - extension for getUserLikeDislike API call
extension MyProfileVC{
    func getUserLikeDislike(){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("getUserLikeDislike")
        let url = AppUrl.getUserLikeDislikeURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "device" : "ios"]
        
        print("Url_getUserLikeDislikeURL_is_here:-" , url)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_getUserLikeDislikeURL",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetUserLikeDislikeData.self, from: responseData)
                            if (dicData.msg?.count)! > 0 {
                                let objProfileRes = (dicData.msg!.first)!
                                self.lblTotalLikes?.text = "\(objProfileRes.likeCount ?? "0")"
                                self.lblStatus?.text = "\(objProfileRes.status ?? "")"
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


//MARK: - Extension for resize the image with its size
extension MyProfileVC {
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


//MARK: extension for getuser image from default save data
extension MyProfileVC{
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
                        self.imgUserProfile.sd_setImage(with: URL(string: image), placeholderImage: nil)
                        
                    }else {
                        print("image_user_Nil")
                        self.imgUserProfile.image = #imageLiteral(resourceName: "ic_avatar")
                    }
                    
                    //for first name
                    let strUserFirstName = "\(userSaveData.firstName!)"
                    //for last name
                    let strUserLastName = "\(userSaveData.lastName!)"
                    //for age
                    let strUserAge = "\(userSaveData.age!)"
                    
                    self.lblUserNameAge.text = strUserFirstName + " " + strUserLastName + ", " + strUserAge
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
    }
}


//  MARK: image picker delegate method
//        //MARK:
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//            var image : UIImage!
//            if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
//                image = img
//            } else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
//                image = img
//            }
//picker.dismiss(animated: true,completion: nil)
//     }

/*  func uploadImgOnFirebaseStorage(){
      print("upload_Img_On_Firebase_Storage")
      
      let storageRef = Storage.storage().reference().child("images/\(Defaults[PDUserDefaults.UserID]).jpg")
      let compressedImage = self.resizeImage(image: self.imgUserProfile.image!, targetSize: CGSize(width: 550, height: 550))
      
      let imageData = compressedImage!.pngData()! as NSData
  
      storageRef.putData(imageData as Data, metadata: nil
                         , completion: { (metadat,error) in
          if error != nil {
              print("Some Error")
              return
          }
          else{
              storageRef.downloadURL(completion: { [self] (url, error) in
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
      })
  }*/
