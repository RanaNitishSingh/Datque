//
//  PhoneNumberVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import CountryPickerView
import FirebaseAuth
import Toast_Swift

class PhoneNumberVC: UIViewController, CountryPickerViewDataSource,CountryPickerViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var countryPicker : CountryPickerView!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var ImgTik: UIImageView!
    
    
    var phoneCode = ""
    var PhoneAuth = ""
    var strSelection = Bool()
    var nextdate  = String()
    var counter = 5
    var timer = Timer()
    var bool = false
    var cureent = false
    var currenttime = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentdate()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.setCountryByCode("US")
        self.txtPhoneNumber.delegate = self
        self.txtPhoneNumber.maxLength = 12
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let message =  "Code: \(country.code) Phone: \(country.phoneCode)"
        self.phoneCode = country.phoneCode
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func ActionContinue(_ sender: Any) {
        
        //phone number outhentication
        if self.ImgTik.image == UIImage(named: "deselect") {
            if !phoneCode.trimmingCharacters(in: .whitespaces).isEmpty{
                if self.phoneCode != ""{
                    if !txtPhoneNumber.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                        
                        //                    if self.txtPhoneNumber.text! == "8718899830" {
                        //                        //instanciate to next screen for otp verification
                        //
                        //                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneOTPVC" ) as! VerifyPhoneOTPVC
                        //                        VC.strComeFrom = "Demo"
                        //                        VC.verificationOTPID = ""
                        //                        VC.userMobNum = "+918718899830"
                        //
                        //                        VC.userId = "918718899830"
                        //                        self.navigationController?.pushViewController(VC, animated: true)
                        //
                        //                    }else{
                        //                        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocationVC" ) as! EnableLocationVC
                        //                        self.navigationController?.pushViewController(VC, animated: true)
                        //  self.view.makeToast("Please check terms and condition policy")
                        
                        self.PhoneAuth = phoneCode + txtPhoneNumber.text!
                        print("PhoneAuth_is_here",self.PhoneAuth)
                        mobileOth(mobNum : "\(self.PhoneAuth)")
                        //                    }
                        
                    }else{
                        self.view.makeToast("Enter Mobile No")
                    }
                }else{
                    self.view.makeToast("Select Country Code")
                }
            }else{
                self.view.makeToast("Select Country Code")
            }
        }else{
            self.view.makeToast("Please check terms and condition policy")
        }
    }
    
    @IBAction func OnClickTerms(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "SecondaryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "webViewController") as? webViewController
        vc?.headerTxt = "Terms & Conditions"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ActionTermAndCondition(_ sender: Any) {
        if strSelection == false {
            self.strSelection = true
            self.ImgTik.image = #imageLiteral(resourceName: "deselect")
        }else if strSelection == true {
            self.strSelection = false
            self.ImgTik.image = #imageLiteral(resourceName: "untick")
        }
    }
    
    func currentdate(){
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy h:mm "
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        let time = todaysDate.timeIntervalSince1970
        let int = Int(time)
        let ndate = int * 1000
        self.currenttime = Double(ndate)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 3, to: todaysDate as Date)
        let nextTimeDate = dateFormatter.string(from: tomorrow! )
        self.nextdate = nextTimeDate
        guard let timeInterval = tomorrow?.timeIntervalSince1970 else { return }
        let myInt = Int(timeInterval)
        let nitDate = myInt * 1000
        
        if bool == false {
            if UserDefaults.standard.bool(forKey: "isfirsttime") == false {
                UserDefaults.standard.set(ndate, forKey: "CurrentTime")
                UserDefaults.standard.set(ndate, forKey: "CurrentTime")
                UserDefaults.standard.set(nitDate, forKey: "NextTime")
                bool = true
                cureent =  true
                UserDefaults.standard.set(cureent, forKey: "current")
                UserDefaults.standard.set(bool, forKey: "isfirsttime")
            }
        }
        
        let current = UserDefaults.standard.integer(forKey: "CurrentTime")
        let After7time =  UserDefaults.standard.double(forKey: "NextTime")
        let bools = UserDefaults.standard.bool(forKey: "isfirsttime")
    }
}

extension PhoneNumberVC {
    func mobileOth(mobNum: String ) {
//       Auth.auth().settings?.isAppVerificationDisabledForTesting = true
         PhoneAuthProvider.provider()
            .verifyPhoneNumber("\(mobNum)", uiDelegate: nil) { verificationID, error in
              if let error = error {
                self.view.makeToast("\(error.localizedDescription)")
                return
              }else{
                  if verificationID != nil {
                      let VC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyPhoneOTPVC") as! VerifyPhoneOTPVC
                      print("verificationID = \(verificationID!)")
                      VC.verificationOTPID = verificationID!
                      VC.userMobNum = mobNum
                      let strPhone = mobNum.replacingOccurrences(of: "+", with: "")
                      VC.userId = strPhone
                      self.navigationController?.pushViewController(VC, animated: true)
                  }
              }
          }
    }
}

//        if (1665044776000.0 > 1665044716000.0) == true{
//          displayMyAlertMessage()
//            print("asdidhs")
//        }
//         if (currenttime > After7time) == true{
//           displayMyAlertMessage()
//         }
