//
//  CreateProfileVC.swift
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

class CreateProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var ImgProfile: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtSelectDate: UITextField!
    @IBOutlet weak var txtEnterEmailID: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    var userID = ""
    var ref: DatabaseReference!
    
    var gender = "Male" //1 for male 2 for female
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Create action on text field
        self.txtSelectDate.addTarget(self, action: #selector(showDatePicker(sender:)), for: .editingDidBegin)
        
        // Do any additional setup after loading the view.
        print("CreateProfileVC")
    }
    
    @IBAction func ActionGender(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        if tag == 1 {
            self.gender = "Male"
            self.btnMale.backgroundColor = #colorLiteral(red: 0.6276120543, green: 0.1230647042, blue: 0.9404756427, alpha: 1)
            self.btnFemale.setTitleColor(.black, for: .normal)
            self.btnMale.setTitleColor(.white, for: .normal)
            self.btnFemale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }else if tag == 2 {
            self.gender = "Female"
            self.btnMale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnFemale.setTitleColor(.white, for: .normal)
            self.btnMale.setTitleColor(.black, for: .normal)
            self.btnFemale.backgroundColor = #colorLiteral(red: 0.6276120543, green: 0.1230647042, blue: 0.9404756427, alpha: 1)
        }
    }
    
    @IBAction func ActionOpenGallery(_ sender: Any) {
        print("upload image")
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
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC" ) as! PhoneNumberVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionNext(_ sender: Any) {
        if !txtFirstName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            if !txtLastName.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                if !txtSelectDate.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                    if !txtEnterEmailID.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                        if ImgProfile.image != nil {
                            
                            let optimizedImageData = self.ImgProfile.image!.jpegData(compressionQuality: 0.6)
                            self.uploadFirebaseImage(imageData: optimizedImageData!)
                            // self.uploadImgOnFirebaseStorage()
                            
                        }else{
                            self.view.makeToast("select profile image")
                        }
                    }else{
                        self.view.makeToast("Enter Email ID")
                    }
                }else{
                    self.view.makeToast("Select date of birth")
                }
            }else{
                self.view.makeToast("Enter Last Name")
            }
        }else{
            self.view.makeToast("Enter First Name")
        }
        
        /*
         let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocationVC" ) as! EnableLocationVC
         self.navigationController?.pushViewController(VC, animated: true)*/
    }
    
}

//MARK:- Extension for upload image on firebase storage
extension CreateProfileVC{
    
    func uploadFirebaseImage(imageData: Data)
    {
        let activityIndicator = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        
        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child("images/\(userID).jpg")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                profileImageRef.downloadURL(completion: { [self] (url, error) in
                    print("imgFireBasePath URL: \((url?.absoluteString)!)")
                    let imgFireBasePath = "\((url?.absoluteString)!)"
                    //print("API call for signup Servies")
                    if imgFireBasePath != nil{
                        self.SignUpServices(Img: imgFireBasePath)
                    }else{
                        print("Some error gating image path on firebase")
                    }
                    
                })
            }
        }
    }
    
}

//MARK:- Extension for resize the image with its size
extension CreateProfileVC {
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

//MARK:- Extenction for (Date and time selector)
extension CreateProfileVC {
    
    @objc func showDatePicker(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            //datePickerView.preferredDatePickerStyle = .wheels
        }
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePickerView.maximumDate = date
        datePickerView.date = date!
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        formatter.dateFormat = "dd/MM/yyyy"
        self.txtSelectDate.text  = formatter.string(from: sender.date)
        // print("Start date :- \(self.txtSelectDate.text ?? "NA")")
    }
    
}

//MARK:- Extenction for (Camera and Gallery image select)
extension CreateProfileVC {
    
    func GalleryMethod(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func CameraMethod() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.view.makeToast("Camera is not available")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        self.ImgProfile.image = selectedImage.normalizedImage()
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- Extenction for signup API call
extension CreateProfileVC {
    
    func SignUpServices(Img: String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.SignUpURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(self.userID)",
                                         "first_name" : self.txtFirstName.text!,
                                         "last_name" : self.txtLastName.text!,
                                         "birthday" : self.txtSelectDate.text!,
                                         "email" : self.txtEnterEmailID.text!,
                                         "gender" : "\(self.gender)",
                                         "image1" : "\(Img)",
                                         "device" : "ios"]
        
        print("Url_SignUpServices_is_here:-" , url)
        print("Param_SignUpServices_is_here:-" , parameters)
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            PKHUD.sharedHUD.hide()
            print("Response", response)
            
            if let responseData = response.data {
                do {
                    let responseJson = try JSONDecoder().decode(CommonResponseModel.self, from: responseData)
                    print("Code_is_SignUpServices", responseJson.code as Any)
                    
                    if responseJson.code == "200" {
                        if let responseData = responseJson.data {
                            if let userId = responseData.fb_id {
                                print("User ID:", userId)
                                // Call API to get user data
                                self.getUserInfoService(phone: userId)
                            }
                        }
                    } else if responseJson.code == "201" {
                        print("Something went wrong with error code 201")
                    } else {
                        print("Something went wrong in JSON")
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func getUserInfoService(phone:String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
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
                                let objProfileRes = (dicData.msg!.first)!
                                
                                //Default save usr is login
                                Defaults[PDUserDefaults.isLogin] = true
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
                                    
                                } catch {
                                    print("Unable to Encode Note (\(error))")
                                }
                                
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocationVC" ) as! EnableLocationVC
                                self.navigationController?.pushViewController(VC, animated: true)
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


