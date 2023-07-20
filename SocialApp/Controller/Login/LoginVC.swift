//
//  LoginVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit

class LoginVC: UIViewController {
 var strSelection = Bool()
    @IBOutlet weak var ImgTik: UIImageView!
    
    var nextdate  = String()
    var counter = 5
      var timer = Timer()
    var bool = false
var cureent = false
    var currenttime = Double()
    override func viewDidLoad() {
        super.viewDidLoad()

        
        currentdate()

 
        
//        let deadlineTime = DispatchTime.now() + .seconds(10)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//            self.currentdate()
//            self.displayMyAlertMessage()
//        }
//
        
        print("LoginVC")
    }
    
    @IBAction func ActionContinueWithPhoneNumber(_ sender: Any) {
        if self.ImgTik.image == UIImage(named: "deselect") {
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC" ) as! PhoneNumberVC
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            self.view.makeToast("Please check terms and condition policy")
        }
        
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
    
    @IBAction func OnClickTerms(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "SecondaryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "webViewController") as? webViewController
        vc?.headerTxt = "Terms & Conditions"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
//    @objc func displayMyAlertMessage(){
//
//
//
//        let dialogMessage = UIAlertController(title: "Alert ", message: " Payment Reminder", preferredStyle: .alert)
//        // Create OK button with action handler
//        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//            print("Ok button tapped")
//        })
//        // Create Cancel button with action handlder
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//            print("Cancel button tapped")
//        }
//        //Add OK and Cancel button to an Alert object
//        dialogMessage.addAction(ok)
//        dialogMessage.addAction(cancel)
//        // Present alert message to user
//        self.present(dialogMessage, animated: true, completion: nil)
//
//
//
//
//     }
     func currentdate(){
         let todaysDate = NSDate()

         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd MM yyyy h:mm "
         let DateInFormat = dateFormatter.string(from: todaysDate as Date)
          print(DateInFormat)

         let time = todaysDate.timeIntervalSince1970
       let int = Int(time)
         let ndate = int * 1000
         self.currenttime = Double(ndate)
         print(ndate)
         print(currenttime)
         //1665045592000.0

         let tomorrow = Calendar.current.date(byAdding: .day, value: 3, to: todaysDate as Date)
         let nextTimeDate = dateFormatter.string(from: tomorrow! )
         print(nextTimeDate)
         self.nextdate = nextTimeDate
         guard let timeInterval = tomorrow?.timeIntervalSince1970 else { return }
         let myInt = Int(timeInterval)
         let nitDate = myInt * 1000

         print(nitDate)

         if bool == false {
             if UserDefaults.standard.bool(forKey: "isfirsttime") == false {
                 UserDefaults.standard.set(ndate, forKey: "CurrentTime")
                 UserDefaults.standard.set(ndate, forKey: "CurrentTime")
                 UserDefaults.standard.set(nitDate, forKey: "NextTime")
                bool = true
                 cureent =  true
                 UserDefaults.standard.set(cureent, forKey: "current")
                 UserDefaults.standard.set(bool, forKey: "isfirsttime")
             }else {
                 print("nothing happenned")
             }

         }


         let current = UserDefaults.standard.integer(forKey: "CurrentTime")
         print(current)

         let After7time =  UserDefaults.standard.double(forKey: "NextTime")
         print (After7time)
         //1665045652000.0


         let bools = UserDefaults.standard.bool(forKey: "isfirsttime")
          print(bools)




 //        if (1665044776000.0 > 1665044716000.0) == true{
 //          displayMyAlertMessage()
 //            print("asdidhs")
 //        }
//         if (currenttime > After7time) == true{
//           displayMyAlertMessage()
//
//
//         }
     }
}
