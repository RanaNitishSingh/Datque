//
//  VoiceChatViewController.swift
//
//


import UIKit
import AgoraRtcKit
import AgoraRtcKit
import Firebase
import FirebaseStorage
import SwiftyJSON
import FirebaseDatabase
import GiphyUISDK
import MobileCoreServices
import Alamofire

class VoiceChatViewController: UIViewController {

    @IBOutlet weak var controlButtonsView: UIView!
    @IBOutlet weak var micButton: UIButton!
    var agoraKit: AgoraRtcEngineKit!
    var UserName = ""
    var UserId = ""
    var ReceiverID = ""
    var ReceiverFirebaseTokn = ""
    var strComesFrom = ""
    var dicUserData = NSDictionary()
    var strJoinCall = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       print(strJoinCall)
        initializeAgoraEngine()
        let channelname = Utils.randomString(10)
        fetchRTCToken(Type: "audiocall", channelName: channelname)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.CallEndNotificationScreen(notification:)), name: NSNotification.Name("CallEndByUser"), object: nil)
    }
     @objc func CallEndNotificationScreen(notification: NSNotification){
         print("CallEndByUservideo")
         self.navigationController?.popViewController(animated: true)
      
         //leaveChannel()
     }
    
    func initializeAgoraEngine() {
        // Initializes the Agora engine with your app ID.
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         agoraKit?.leaveChannel(nil)
         AgoraRtcEngineKit.destroy()
     }
    var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
        }
    }
  
    func joinChannel(token:String, channel:String) {
       
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: token, channelId: channel, info: nil, uid: 0 ) { [unowned self] (channel, uid, elapsed) -> Void in
            print("Did join channel demoChannel1", channel)
            //remoteContainer.isHidden = false
            /// self.agoraKit.adjustAudioMixingVolume(3)
            self.agoraKit.muteAllRemoteAudioStreams(false)
            self.agoraKit.muteLocalAudioStream(false)
            self.agoraKit.setEnableSpeakerphone(false)
            isStartCalling = true
            UIApplication.shared.isIdleTimerDisabled = true
            let notifMessage: [String: Any] = [
                
                "to" : self.ReceiverFirebaseTokn,
                "notification" :
                    ["title" : UserName, "body": "calling you...", "senderid": UserId, "senderImage" : "", "message" : channel, "action_type" : "audio", "action" : "call_status","Rtc_Token" :token] ,
                "data" :
                    ["title" : UserName, "body": "calling you...", "senderid": UserId, "senderImage" : "", "message" : channel, "action_type" : "audio", "action" : "call_status","Rtc_Token" :token]
            ]
            
            print("notifMessage",notifMessage)
            sendPushNotification(notData: notifMessage)
            
        }
    }
    
    //MARK: ------Notification------
    func detailGetFirebase(token: String, channel: String){
        let ref = Database.database().reference()
        ref.child("Users").child("\(self.ReceiverID)").child("token").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let firebaseTokenValue = snapshot.value as? String
            if firebaseTokenValue != nil{
                self.ReceiverFirebaseTokn = firebaseTokenValue!
            }
            self.joinChannel(token: token, channel: channel)
        }) { error in
            print(error.localizedDescription)
        }
        
    }
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        hideControlButtons()
        
        UIApplication.shared.isIdleTimerDisabled = false
        print(strJoinCall, "strJoinCall")
        //self.navigationController?.popViewController(animated: true)
       self.navigationController?.popToViewController(ofClass: ChatVC.self)

        if strJoinCall == "join" {
            
            self.navigationController?.popToViewController(ofClass: ChatVC.self)
            strJoinCall = ""
        }else{
            self.navigationController?.popToViewController(ofClass: ChatVC.self)
            let notifMessage: [String: Any] = [

                "to" : self.ReceiverFirebaseTokn,
                "data": [
                    "silentPayloadData": "silentNotification"
                ],
                "content_available": true
            ]
           sendPushNotification(notData: notifMessage)

        }
        
    }
    
    func hideControlButtons() {
        controlButtonsView.isHidden = true
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        //sender.isSelected = !sender.isSelected
        sender.isSelected.toggle()
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchSpeakerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Enables/Disables the audio playback route to the speakerphone.
        //
        // This method sets whether the audio is routed to the speakerphone or earpiece. After calling this method, the SDK returns the onAudioRouteChanged callback to indicate the changes.
        agoraKit.setEnableSpeakerphone(sender.isSelected)
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
                print("response should be 200, but is \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print(responseString ?? "")
            print("responseString should be 200, but is \(responseString)")
        }
        task.resume()
    }
    //MARK:FetchRTCToken
     func fetchRTCToken(Type: String, channelName: String){
         
         let url = AppUrl.getRTcToken()
         
         let parameters: [String: Any] = ["channelName":channelName,
                                          "type":Type,
                                          "device" : "ios" ,
                                          "uid": channelName]
         AF.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
             .responseJSON { response in
                 debugPrint(response)
                 
                 if response.value != nil{
                     let responseJson = JSON(response.value!)
                     print("Code_is_getUserInfoURL",responseJson["msg"])
                     let dict  = responseJson["msg"]
                     let video_token = dict["video_token"]
                     let channelName = dict["channelName"]
                   
                     if self.strComesFrom == "push_notification" {
                         let str_Chanel = self.dicUserData["message"] as! String
                         let device_token = self.dicUserData["Rtc_Token"] as! String
                        
                         self.joinChannel(token:device_token, channel:str_Chanel)
                     }else{
                         self.detailGetFirebase(token:video_token.rawValue as! String, channel:channelName.rawValue as! String)
                     }
                     
                 }
             }
     }
     
}
extension VoiceChatViewController: AgoraRtcEngineDelegate {
//    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
//
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.renderMode = .hidden
//        agoraKit.setupRemoteVideo(videoCanvas)
//    }
    
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
    
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        strJoinCall = "join"
        print("In didjoin method")
        print("In didjoin method with uid = \(uid)")
        
        
    }
    
    /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - uid: ID of the user or host who leaves a channel or goes offline.
    ///   - reason: Reason why the user goes offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        print("In didoffline method")
        leaveChannel()
      
        //Move to back screen
        //self.navigationController?.popToViewController(ofClass: ChatVC.self)
       // self.navigationController?.popViewController(animated: true)
    }
    
    /// Occurs when a remote user’s video stream playback pauses/resumes.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - muted: YES for paused, NO for resumed.
    ///   - byUid: User ID of the remote user.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
    }
    
    /// Reports a warning during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - warningCode: Warning code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        // logVC?.log(type: .warning, content: "did occur warning, code: \(warningCode.rawValue)")
    }
    
    /// Reports an error during SDK runtime.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - errorCode: Error code
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        // logVC?.log(type: .error, content: "did occur error, code: \(errorCode.rawValue)")
    }
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
