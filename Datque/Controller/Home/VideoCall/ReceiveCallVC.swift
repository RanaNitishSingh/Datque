//
//  ReceiveCallVC.swift
//  SocialApp
//
//  Created by mac on 9/7/22.
//

import UIKit
import AgoraRtcKit
import Firebase
import FirebaseStorage
import SwiftyJSON
import FirebaseDatabase
import GiphyUISDK
import MobileCoreServices
import Alamofire

class ReceiveCallVC: UIViewController {
    
    var dicUserData = NSDictionary()
    var ReceiverID = ""
    var ReceiverFirebaseTokn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("dicUserData", dicUserData)
        ReceiverID = dicUserData["senderid"] as! String
        print(ReceiverID , "ReceiverID")
        NotificationCenter.default.addObserver(self, selector: #selector(self.CallEndNotificationScreen(notification:)), name: NSNotification.Name("CallEndByUser"), object: nil)
        detailGetFirebase()
    }
     @objc func CallEndNotificationScreen(notification: NSNotification){
         self.navigationController?.popViewController(animated: true)
         print("voicecall")
         //self.navigationController?.popToViewController(ofClass: ChatVC.self)

     }

    @IBAction func OnClickBtnAccept(_ sender: UIButton) {
        let call_type = dicUserData["action_type"] as! String
        if call_type == "audio" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceChatViewController" ) as! VoiceChatViewController
                vc.strComesFrom = "push_notification"
                vc.dicUserData = dicUserData
            vc.strJoinCall = "join"

                self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController" ) as! VideoChatViewController
                vc.strComesFrom = "push_notification"
                vc.dicUserData = dicUserData
                self.navigationController!.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func OnClickBtnReject(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

        let notifMessage: [String: Any] = [
            
            "to" : self.ReceiverFirebaseTokn,
            "data": [
                "silentPayloadData": "silentNotification"
            ],
            "content_available": true
        ]
        sendPushNotification(notData: notifMessage)

    }
    //MARK: ------Notification------
    func detailGetFirebase(){
        let ref = Database.database().reference()
        ref.child("Users").child("\(self.ReceiverID)").child("token").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let firebaseTokenValue = snapshot.value as? String
            if firebaseTokenValue != nil{
                self.ReceiverFirebaseTokn = firebaseTokenValue!
            }
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    func sendPushNotification(notData: [String: Any]) {
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(serverKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: notData, options: [])
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error ?? "")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print(response ?? "")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString ?? "")

        }
        task.resume()
    }
}
