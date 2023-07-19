//
//  MainViewController.swift
//  OpenLive
//
//  Created by GongYuhua on 6/25/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Alamofire
import SwiftyJSON
import Firebase
import FirebaseStorage
import FirebaseDatabase

class MainViewController: UIViewController {

    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var logoTop: NSLayoutConstraint!
    @IBOutlet weak var inputTextFieldTop: NSLayoutConstraint!
    var strComesFrom = ""
    var audi_name = ""
    var audi_Id = ""
    var audi_Pic = ""
    var channel_Name = ""
    var rtc_token = ""
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()
    
    private var settings = Settings()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        inputTextField.isUserInteractionEnabled = false
        if strComesFrom == "audience" {
            inputTextField.text = "\(audi_name)"
        }else{
            inputTextField.text = "\(Defaults[PDUserDefaults.userName])"
        }
           
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        inputTextField.endEditing(false)
    }
   
//    @IBAction func ActionOnSetting(_ sender: Any) {
//        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC" ) as! SettingsVC
//        self.navigationController?.pushViewController(VC, animated: true)
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        inputTextField.endEditing(false)
    }
    @IBAction func OnCliCkBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
       
                                                                   
    @IBAction func doStartButton(_ sender: UIButton) {
        guard let roomName = roomNameTextField.text,
            roomName.count > 0 else {
                return
        }
        settings.roomName = roomName
        if strComesFrom == "audience" {
           print("audi_Id", audi_name)
            print("self.rtc_token", self.rtc_token)
            self.settings.picture = self.audi_Pic
            self.settings.username = self.audi_name
            self.settings.roomName = self.audi_Id
            self.settings.token =  self.rtc_token
            selectedRoleToLive(role: .audience)
        }else{
            print("Broadcast", "\(roomNameTextField.text!)")
           // selectedRoleToLive(role: .broadcaster)
            fetchRTCToken(Type: "Broadcast", channelName: "\(Defaults[PDUserDefaults.UserID])")
        }
       
        //performSegue(withIdentifier: "roleToLive", sender: nil)
    }
    func selectedRoleToLive(role: AgoraClientRole) {
       // delegate?.roleVC(self, didSelect: role)
        let VC = self.storyboard!.instantiateViewController(withIdentifier: "LiveRoomViewController") as! LiveRoomViewController
        VC.dataSource = self
        VC.user_Id = self.settings.roomName ?? ""
        VC.user_pic = self.settings.picture ?? ""
        VC.user_name = self.settings.username ?? ""
        VC.agora_token = self.settings.token ?? ""
        VC.strRole =  strComesFrom
        self.navigationController!.pushViewController(VC, animated: true)
       // performSegue(withIdentifier: "roleToLive", sender: nil)
    }
    @IBAction func doExitPressed(_ sender: UIStoryboardSegue) {
    }
    //MARK:FetchRTCToken
     func fetchRTCToken(Type: String, channelName: String){
         
         let url = AppUrl.getRTcToken()
         
         let parameters: [String: Any] = ["channelName":channelName,
                                          "type":Type,
                                          "device" : "ios" ,
                                          "uid":"0" ]
         AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
             .responseJSON { response in
                 print(response)
                 if response.value != nil{
                     let responseJson = JSON(response.value!)
                     let dict  = responseJson["msg"]
                     self.rtc_token = dict["video_token"].rawValue as! String
                     let channel_Name = dict["channelName"].rawValue as! String
                     self.settings.roomName = channel_Name
                     self.settings.token =  self.rtc_token
                     self.settings.username = "\(Defaults[PDUserDefaults.userName])"
                     self.settings.picture = "\(Defaults[PDUserDefaults.profileImg])"
                     self.selectedRoleToLive(role: .broadcaster)
                     
                 }
             }
     }
}

private extension MainViewController {
    func updateViews() {
        let key = NSAttributedString.Key.foregroundColor
        let color = UIColor(red: 156.0 / 255.0, green: 217.0 / 255.0, blue: 1.0, alpha: 1)
        let attributed = [key: color]
        let attributedString = NSMutableAttributedString(string: "Enter a channel name", attributes: attributed)
        inputTextField.attributedPlaceholder = attributedString
        
        startButton.layer.shadowOpacity = 0.3
        startButton.layer.shadowColor = UIColor.black.cgColor
        
        if UIScreen.main.bounds.height <= 568 {
            logoTop.constant = 69
            inputTextFieldTop.constant = 37
        }
    }
}

extension MainViewController: LiveVCDataSource {
    func liveVCNeedSettings() -> Settings {
        return settings
    }
    
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit {
        return agoraKit
    }
}

extension MainViewController: SettingsVCDelegate {
    func settingsVC(_ vc: SettingsViewController, didSelect dimension: CGSize) {
        settings.dimension = dimension
    }
    
    func settingsVC(_ vc: SettingsViewController, didSelect frameRate: AgoraVideoFrameRate) {
        settings.frameRate = frameRate
    }
}

extension MainViewController: SettingsVCDataSource {
    func settingsVCNeedSettings() -> Settings {
        return settings
    }
}

//extension MainViewController: RoleVCDelegate {
//    func roleVC(_ vc: RoleViewController, didSelect role: AgoraClientRole) {
//        settings.role = role
//    }
//}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.endEditing(true)
        return true
    }
}
