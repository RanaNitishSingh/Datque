//
//  VideoChatViewController.swift
//  Agora iOS Tutorial
//
//  Created by James Fang on 7/14/16.
//  Copyright © 2016 Agora.io. All rights reserved.
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
import PKHUD

class VideoChatViewController: UIViewController {
    @IBOutlet weak var localContainer: UIView!
    @IBOutlet weak var remoteContainer: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIView!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    var agoraKit: AgoraRtcEngineKit!
    var localVideo: AgoraRtcVideoCanvas?
    var remoteVideo: AgoraRtcVideoCanvas?
    var UserName = ""
    var UserId = ""
    var ReceiverID = ""
    var ReceiverFirebaseTokn = ""
    var strComesFrom = ""
    var strJoinCall = ""
    var strJoin_Chanel = ""
    var dicUserData = NSDictionary()
    var isRemoteVideoRender: Bool = true {
        didSet {
            if let it = localVideo, let view = it.view {
                if view.superview == localContainer {
                    remoteVideoMutedIndicator.isHidden = isRemoteVideoRender
                    remoteContainer.isHidden = !isRemoteVideoRender
                } else if view.superview == remoteContainer {
                    localVideoMutedIndicator.isHidden = isRemoteVideoRender
                }
            }
        }
    }
    
    var isLocalVideoRender: Bool = false {
        didSet {
            if let it = localVideo, let view = it.view {
                if view.superview == localContainer {
                    localVideoMutedIndicator.isHidden = isLocalVideoRender
                } else if view.superview == remoteContainer {
                    remoteVideoMutedIndicator.isHidden = isLocalVideoRender
                }
            }
        }
    }
    
    var isStartCalling: Bool = true {
        didSet {
            if isStartCalling {
                micButton.isSelected = false
            }
            micButton.isHidden = !isStartCalling
            cameraButton.isHidden = !isStartCalling
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is our usual steps for joining
        // a channel and starting a call.
        initializeAgoraEngine()
        setupVideo()
        setupLocalVideo()
        //setupRemoteVideo()
        remoteContainer.isHidden = true
        let channelname = Utils.randomString(10)
        fetchRTCToken(Type: "videocall", channelName: channelname)
        NotificationCenter.default.addObserver(self, selector: #selector(self.CallEndNotificationScreen(notification:)), name: NSNotification.Name("CallEndByUservoice"), object: nil)
    }
    @objc func CallEndNotificationScreen(notification: NSNotification){
        leaveChannel()
    }
   
    
    func initializeAgoraEngine() {
        // init AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
    }
    
    func setupVideo() {
        
        agoraKit.enableVideo()
        
        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x360,
                                                                             frameRate: .fps15,
                                                                             bitrate: AgoraVideoBitrateStandard,
                                                                             orientationMode: .adaptative, mirrorMode: .auto))
    }
    
    func setupLocalVideo() {
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: localContainer.frame.size))
        localVideo = AgoraRtcVideoCanvas()
        localVideo!.view = view
        localVideo!.renderMode = .hidden
        localVideo!.uid = 0
        localContainer.addSubview(localVideo!.view!)
        agoraKit.setupLocalVideo(localVideo)
        agoraKit.startPreview()
    }
    func setupRemoteVideo() {
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: remoteContainer.frame.size))
        remoteVideo = AgoraRtcVideoCanvas()
        remoteVideo!.view = view
        remoteVideo!.renderMode = .hidden
        remoteVideo!.uid = 0
        remoteContainer.addSubview(remoteVideo!.view!)
        agoraKit.setupLocalVideo(remoteVideo)
        agoraKit.startPreview()
    }
    func joinChannel(token:String, channel:String) {
       
        agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        agoraKit.joinChannel(byToken: token, channelId: channel, info: nil, uid: 0 ) { [unowned self] (channel, uid, elapsed) -> Void in
            print("Did join channel demoChannel1", channel)
            //remoteContainer.isHidden = false
            /// self.agoraKit.adjustAudioMixingVolume(3)
            self.agoraKit.muteAllRemoteAudioStreams(false)
            self.agoraKit.muteLocalAudioStream(false)
            self.agoraKit.setEnableSpeakerphone(true)
            self.isLocalVideoRender = true
            isStartCalling = true
            UIApplication.shared.isIdleTimerDisabled = true
            let notifMessage: [String: Any] = [
                
                "to" : self.ReceiverFirebaseTokn,
                "notification" :
                    ["title" : UserName, "body": "calling you...", "senderid": UserId, "senderImage" : "", "message" : channel, "action_type" : "video", "action" : "call_status","Rtc_Token" :token] ,
                "data" :
                    ["title" : UserName, "body": "calling you...", "senderid": UserId, "senderImage" : "", "message" : channel, "action_type" : "video", "action" : "call_status","Rtc_Token" :token]
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
    
    func leaveChannel() {
        // leave channel and end chat
        print(strJoinCall)
        agoraKit.leaveChannel(nil)
        
        isRemoteVideoRender = false
        isLocalVideoRender = false
        isStartCalling = false
        UIApplication.shared.isIdleTimerDisabled = false
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
            print(notifMessage)
            sendPushNotification(notData: notifMessage)
            //self.navigationController?.popToViewController(ofClass: ChatVC.self)
        }
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
       // sender.isSelected.toggle()
        print("hangup")
        // if sender.isSelected {
        
        leaveChannel()
        //removeFromParent(localVideo)
        localVideo = nil
        //removeFromParent(remoteVideo)
        remoteVideo = nil
        //Move to back screen
        
        //        } else {
        //            setupLocalVideo()
        //            joinChannel()
        //        }
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        // mute local audio
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraKit.switchCamera()
    }
    
    @IBAction func didClickLocalContainer(_ sender: Any) {
        switchView(localVideo)
        switchView(remoteVideo)
    }
    
    func removeFromParent(_ canvas: AgoraRtcVideoCanvas?) -> UIView? {
        if let it = canvas, let view = it.view {
            let parent = view.superview
            if parent != nil {
                view.removeFromSuperview()
                return parent
            }
        }
        return nil
    }
    
    func switchView(_ canvas: AgoraRtcVideoCanvas?) {
        let parent = removeFromParent(canvas)
        if parent == localContainer {
            canvas!.view!.frame.size = remoteContainer.frame.size
            remoteContainer.addSubview(canvas!.view!)
        } else if parent == remoteContainer {
            canvas!.view!.frame.size = localContainer.frame.size
            localContainer.addSubview(canvas!.view!)
        }
    }
}

extension VideoChatViewController: AgoraRtcEngineDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
        if (remoteContainer.isHidden) {
            remoteContainer.isHidden = false
        }
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.view = remoteContainer
        videoCanvas.renderMode = .hidden
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        isRemoteVideoRender = true
        
        var parent: UIView = remoteContainer
        if let it = localVideo, let view = it.view {
            if view.superview == parent {
                parent = localContainer
            }
        }
        
        // Only one remote video view is available for this
        // tutorial. Here we check if there exists a surface
        // view tagged as this uid.
        if remoteVideo != nil {
            return
        }
        remoteContainer.isHidden = false
        setupVideo()
        strJoinCall = "join"
        print("In didjoin method")
        print("In didjoin method with uid = \(uid)")
        
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: parent.frame.size))
        remoteVideo = AgoraRtcVideoCanvas()
        remoteVideo!.view = view
        remoteVideo!.renderMode = .hidden
        remoteVideo!.uid = uid
        parent.addSubview(remoteVideo!.view!)
        agoraKit.setupRemoteVideo(remoteVideo!)
    }
    
    /// Occurs when a remote user (Communication)/host (Live Broadcast) leaves a channel.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - uid: ID of the user or host who leaves a channel or goes offline.
    ///   - reason: Reason why the user goes offline
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        isRemoteVideoRender = false
        if let it = remoteVideo, it.uid == uid {
            removeFromParent(it)
            remoteVideo = nil
        }
        leaveChannel()
        //removeFromParent(localVideo)
        localVideo = nil
        //removeFromParent(remoteVideo)
        remoteVideo = nil
        
        //Move to back screen
        // self.navigationController?.popToViewController(ofClass: ChatVC.self)
        // self.navigationController?.popViewController(animated: true)
    }
    
    /// Occurs when a remote user’s video stream playback pauses/resumes.
    /// - Parameters:
    ///   - engine: RTC engine instance
    ///   - muted: YES for paused, NO for resumed.
    ///   - byUid: User ID of the remote user.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
        isRemoteVideoRender = !muted
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
   //MARK:FetchRTCToken
    func fetchRTCToken(Type: String, channelName: String){
        
        let url = AppUrl.getRTcToken()
        
        let parameters: [String: Any] = ["channelName":channelName,
                                         "type":Type,
                                         "device" : "ios" ,
                                         "uid":"0" ]
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
                        print(self.strJoin_Chanel, "strJoin_Chanel")
                        self.setupLocalVideo()
                        self.joinChannel(token:device_token, channel:str_Chanel)
                    }else{
                        self.detailGetFirebase(token:video_token.rawValue as! String, channel:channelName.rawValue as! String)
                    }
                    
                }
            }
    }
    
    
}
