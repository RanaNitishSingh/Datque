//
//  userNameVC.swift
//  Datque
//
//  Created by Zero IT Solutions on 31/08/23.
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

class userNameVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var enterTXtFild: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var userNameExistList = [userNameExist]()
    var userID = ""
    var name = ["simran","simran","simran","simran","simran"]
    var image = ["check-mark.jpeg","check-mark.jpeg","check-mark.jpeg","check-mark.jpeg","check-mark.jpeg"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        enterTXtFild.text = "\(Defaults[PDUserDefaults.userName])"

    }
    
    @IBAction func ActionBackBtn(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumberVC" ) as! PhoneNumberVC
        self.navigationController?.pushViewController(VC, animated: true)
        }
    
    @IBAction func ActionNextBtn(_ sender: Any) {
        
        self.useraNameExist()
        
//         let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC" ) as! CreateProfileVC
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func useraNameExist() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.check_username_existURL()
        
        let parameters: [String: Any] = ["username" : self.enterTXtFild.text!,
                                         "device" : "ios"]
        
        print("Param_getUserInfoURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            
            if let responseData = response.data {
                do {
                    let responseJson = try JSONDecoder().decode(userNameExist.self, from: responseData)
                    print("Code_is_SignUpServices", responseJson.code as Any)
                    
                    if responseJson.code == "200" {
                        if let responseData = responseJson.data {
                            
                            
                            let alert = UIAlertController(title: "Datque", message: "user name already exist, enter different usernme", preferredStyle: .alert)
                            self.present(alert, animated: true, completion: nil)
                            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                                print("user name already exist, enter different usernme")
                            }))
                        }
                        
                    } else if responseJson.code == "201" {
      
                        print("user name does not exist")
                    let VC = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileVC" ) as! CreateProfileVC
                    self.navigationController?.pushViewController(VC, animated: true)
            
                    } else {
                        print("Something went wrong in JSON")
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
          }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNameExistList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! userNameTableViewCell
        let userName = userNameExistList[indexPath.row]
        cell.nameLbl.text = "\(userName.data)"
        
        return cell
    }
    
}

