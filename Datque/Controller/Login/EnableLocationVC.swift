//
//  EnableLocationVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import MapKit
import CoreLocation
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import SwiftUI
import Firebase
import FirebaseStorage
import SwiftyJSON

class EnableLocationVC: UIViewController, CLLocationManagerDelegate {
    
   // var locationManager:CLLocationManager!
    
    var locationManager = CLLocationManager()
    var myCurLat = ""
    var myCurLon = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Defaults[PDUserDefaults.UserLat] = ""
        Defaults[PDUserDefaults.UserLng] = ""
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC" ) as! HomeTabBarVC
//        VC.selectedIndex = 2
//        self.navigationController?.pushViewController(VC, animated: true)
        
        //MARK:- Comment by
       self.isLocationAccessEnabled()
       // self.defaultValueForNearbyUserSearch()
        print("EnableLocationVC")
    }
    
    // for LocationAccess Enabled or not
     func isLocationAccessEnabled() {
         self.getCurrentLocation()
//        if CLLocationManager.locationServicesEnabled() {
//           switch CLLocationManager.authorizationStatus() {
//              case .notDetermined, .restricted, .denied:
//                 print("No_access")
//
//                   locationManager.delegate = self
//                   locationManager.requestWhenInUseAuthorization()
//               UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//               self.view.makeToast("Enable Location Access")
//
//
//              case .authorizedAlways, .authorizedWhenInUse:
//                 print("Access")
//               self.getCurrentLocation()
//
//           @unknown default:
//               print("hhhh")
//           }
//        } else {
//           print("Location services not enabled")
//            locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//            self.view.makeToast("Enable Location Access")
//        }
     }
    
      // for current Lat long
    func getCurrentLocation(){
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!

        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           
            currentLoc = locationManager.location
            print("Current_Latitude is:-",currentLoc.coordinate.latitude)
            print("Current_Longitude is:-",currentLoc.coordinate.longitude)
            self.myCurLat = "\(currentLoc.coordinate.latitude)"
            self.myCurLon = "\(currentLoc.coordinate.longitude)"
           
           if self.myCurLat != "" || self.myCurLon != ""{
               //save current lat log in default
               Defaults[PDUserDefaults.UserLat] = "\(self.myCurLat)"
               Defaults[PDUserDefaults.UserLng] = "\(self.myCurLon)"
               
               //call one more function get user info and save in default
               self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
               

           }else{
               locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
           UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
               self.view.makeToast("Enable Location Access")
           }
           
       }
   }
     
   
    
    @IBAction func ActionNext(_ sender: Any) {
        //MARK:- Comment by Mamta
        self.isLocationAccessEnabled()
// //       let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC" ) as! HomeTabBarVC
// //       self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

//Extension for get user info
extension EnableLocationVC{
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
                                    
                                   //go to Home Screen
                                   let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarVC" ) as! HomeTabBarVC
                                // VC.selectedIndex = 2
                                   self.navigationController?.pushViewController(VC, animated: true)
                                    
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

extension EnableLocationVC{
    func defaultValueForNearbyUserSearch(){
        Defaults[PDUserDefaults.Gender] = ""
        Defaults[PDUserDefaults.Distance] = ""
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
    }
}


