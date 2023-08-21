//
//  VerifyPhoneOTPVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import FirebaseAuth
import Toast_Swift
import Alamofire
import PKHUD
import SwiftyJSON

class VerifyPhoneOTPVC: UIViewController {
    
    @IBOutlet weak var txtMobileNo: UILabel!
    @IBOutlet weak var txtOtp1: UITextField!
    @IBOutlet weak var txtOtp2: UITextField!
    @IBOutlet weak var txtOtp3: UITextField!
    @IBOutlet weak var txtOtp4: UITextField!
    @IBOutlet weak var txtOtp5: UITextField!
    @IBOutlet weak var txtOtp6: UITextField!
    
    var userId = ""
    var verificationOTPID = ""
    var userMobNum = ""
    var strOtp = ""
    var strComeFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtMobileNo.text = self.userMobNum
        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp5.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        txtOtp6.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txtOtp1: txtOtp2.becomeFirstResponder()
            case txtOtp2: txtOtp3.becomeFirstResponder()
            case txtOtp3: txtOtp4.becomeFirstResponder()
            case txtOtp4: txtOtp5.becomeFirstResponder()
            case txtOtp5: txtOtp6.becomeFirstResponder()
            case txtOtp6: txtOtp6.resignFirstResponder()
                self.strOtp = "\(txtOtp1.text!)\(txtOtp2.text!)\(txtOtp3.text!)\(txtOtp4.text!)\(txtOtp5.text!)\(txtOtp6.text!)"
            default:
                break
            }
        }
        
        if  text?.count == 0 {
            switch textField{
            case txtOtp1:
                txtOtp1.becomeFirstResponder()
            case txtOtp2:
                txtOtp1.becomeFirstResponder()
            case txtOtp3:
                txtOtp2.becomeFirstResponder()
            case txtOtp4:
                txtOtp3.becomeFirstResponder()
            case txtOtp5:
                txtOtp4.becomeFirstResponder()
            case txtOtp6:
                txtOtp5.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
    @IBAction func ActionConfirm(_ sender: Any) {
        if !txtOtp1.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            if !txtOtp2.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                if !txtOtp3.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                    if !txtOtp4.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                        if !txtOtp5.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                            if !txtOtp6.text!.trimmingCharacters(in: .whitespaces).isEmpty{
                                if self.strOtp.count == 6 {
                                    if self.strComeFrom == "Demo" {
                                        self.getUserInfoService(phone:"918718899830")
                                    } else {
                                        verifyOTP(OTP: "\(self.strOtp)")
                                    }
                                } else {
                                    self.view.makeToast("Please enter valid six digit code")
                                }
                                
                            } else {
                                self.view.makeToast("enter OTP Without Space")
                            }
                        } else {
                            self.view.makeToast("enter OTP Without Space")
                        }
                    } else {
                        self.view.makeToast("enter OTP Without Space")
                    }
                } else {
                    self.view.makeToast("enter OTP Without Space")
                }
            } else {
                self.view.makeToast("enter OTP Without Space")
            }
            
        } else {
            self.view.makeToast("enter OTP Without Space")
        }
    }
   
    @IBAction func ActionResendOTP(_ sender: Any) {
        
        if self.userMobNum != nil {
            if self.userMobNum != "" {
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber("\(self.userMobNum)", uiDelegate: nil) { verificationID, error in
                     if let error = error {
                       self.view.makeToast("\(error.localizedDescription)")
                       return
                     } else {
                         if verificationID != nil {
                             print("verificationID = \(verificationID!)")
                             self.verificationOTPID = verificationID!
                         }
                     }
                }
            }
        }
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
}

extension VerifyPhoneOTPVC {
    func verifyOTP(OTP: String) {
        
        if self.verificationOTPID != nil {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationOTPID, verificationCode: OTP)
                Auth.auth().signIn(with: credential) { (AuthData, error) in
                    if error != nil {
                        self.view.makeToast("The SMS verification code is invalid")
                    }else{
                        print("AUTHENTICATION SUCCESS WITH - " + ((AuthData?.user.phoneNumber)!) )
                        //Call API User is new or not
                        let phoneNo = (AuthData?.user.phoneNumber)!
                        if phoneNo != nil{
                            self.getUserInfoService(phone: "\(phoneNo)")
                        }
                    }
                }
        }else{
            self.view.makeToast("Something went wrong")
        }
    }
    
    //MARK:- API CALL ALAMOFIRE-5 (Post RAW API call)
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
                print("Code is",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetUserInfoData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                let objProfileRes = (dicData.msg!.first)!
                               
                              //  //default save user is login
                                Defaults[PDUserDefaults.isLogin] = true
                                Defaults[PDUserDefaults.UserID] = "\(objProfileRes.fbID!)"
                                print("Defaults_PDUser_Defaults_UserID",objProfileRes.fbID!)
                                
                                //to save default user data with json encode *****
                                do {
                                    let encoder = JSONEncoder()
                                    let data = try encoder.encode(objProfileRes)
                                    UserDefaults.standard.set(data, forKey: "encodeUserData")

                                } catch {
                                    print("Unable to Encode Note (\(error))")
                                }
                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC" ) as! HomeTabBarVC
                             // VC.selectedIndex = 2
                                self.navigationController?.pushViewController(VC, animated: true)
//                                let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocationVC" ) as! EnableLocationVC
//                                self.navigationController?.pushViewController(VC, animated: true)
                            }
                            
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                }else if responseJson["code"] == "201" {
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC" ) as! CreateProfileVC
                    VC.userID = self.userId
                    self.navigationController?.pushViewController(VC, animated: true)
                }else{
                    print("Something went wrong in json")
                }
            }
        }
    }
}

