//
//  LiveRoomViewController.swift
//  OpenLive
//
//  Created by GongYuhua on 6/25/16.
//  Copyright © 2016 Agora. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON
import FirebaseDatabase
import AuthorizeNetAccept

protocol LiveVCDataSource: NSObjectProtocol {
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit
    func liveVCNeedSettings() -> Settings
}

class LiveRoomViewController: UIViewController {
    
    @IBOutlet weak var broadcastersView: AGEVideoContainer!

    @IBOutlet weak var placeholderView: UIImageView!
    
    @IBOutlet weak var videoMuteButton: UIButton!
    @IBOutlet weak var audioMuteButton: UIButton!
    @IBOutlet weak var beautyEffectButton: UIButton!
    
    @IBOutlet var sessionButtons: [UIButton]!
    @IBOutlet weak var Imguser: UIImageView!
    @IBOutlet weak var lblroomname: UILabel!
    @IBOutlet weak var lblame: UILabel!
    var agora_token = ""
    var user_name = ""
    var user_pic = ""
    var strRole = ""
    var user_Id = ""
    private let beautyOptions: AgoraBeautyOptions = {
        let options = AgoraBeautyOptions()
        options.lighteningContrastLevel = .normal
        options.lighteningLevel = 0.7
        options.smoothnessLevel = 0.5
        options.rednessLevel = 0.1
        return options
    }()
    
    private var agoraKit: AgoraRtcEngineKit {
        return dataSource!.liveVCNeedAgoraKit()
    }
    
    private var settings: Settings {
        return dataSource!.liveVCNeedSettings()
    }
    
    private var isMutedVideo = false {
        didSet {
            // mute local video
            agoraKit.muteLocalVideoStream(isMutedVideo)
            videoMuteButton.isSelected = isMutedVideo
        }
    }
    
    private var isMutedAudio = false {
        didSet {
            // mute local audio
            agoraKit.muteLocalAudioStream(isMutedAudio)
            audioMuteButton.isSelected = isMutedAudio
        }
    }
    
    private var isBeautyOn = false {
        didSet {
            // improve local render view
            agoraKit.setBeautyEffectOptions(isBeautyOn,
                                            options: isBeautyOn ? beautyOptions : nil)
            beautyEffectButton.isSelected = isBeautyOn
        }
    }
    
    private var isSwitchCamera = false {
        didSet {
            agoraKit.switchCamera()
        }
    }
    
    private var videoSessions = [VideoSession]() {
        didSet {
            placeholderView.isHidden = (videoSessions.count == 0 ? false : true)
            // update render view layout
            updateBroadcastersView()
//            if strRole == "audience" {
//                updateUser()
//            } else {
//                updateBroadcastersView()
//            }
        }
    }
    
    private let maxVideoSession = 4
    
    weak var dataSource: LiveVCDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblroomname.text = "\(settings.username!)"
        let strUserImg = "\(settings.picture!)"
        if strUserImg != "0" && strUserImg != "" {
          Imguser.sd_setImage(with: URL(string: strUserImg), placeholderImage: nil)
        }
        updateButtonsVisiablity()
        loadAgoraKit()
       // WSliveuser()
    }
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - ui action
    @IBAction func doSwitchCameraPressed(_ sender: UIButton) {
        isSwitchCamera.toggle()
    }
    
    @IBAction func doBeautyPressed(_ sender: UIButton) {
        isBeautyOn.toggle()
    }
    
    @IBAction func doMuteVideoPressed(_ sender: UIButton) {
        isMutedVideo.toggle()
    }
    
    @IBAction func doMuteAudioPressed(_ sender: UIButton) {
        isMutedAudio.toggle()
    }
    
    @IBAction func doLeavePressed(_ sender: UIButton) {
        leaveChannel()
    }
}

private extension LiveRoomViewController {
    func updateBroadcastersView() {
        // video views layout
        if videoSessions.count == maxVideoSession {
            broadcastersView.reload(level: 0, animated: true)
        } else {
            var rank: Int
            var row: Int
            
            if videoSessions.count == 0 {
                broadcastersView.removeLayout(level: 0)
                return
            } else if videoSessions.count == 1 {
                rank = 1
                row = 1
            } else if videoSessions.count == 2 {
                rank = 1
                row = 2
            } else {
                rank = 2
                row = Int(ceil(Double(videoSessions.count) / Double(rank)))
            }
            
            let itemWidth = CGFloat(1.0) / CGFloat(rank)
            let itemHeight = CGFloat(1.0) / CGFloat(row)
            let itemSize = CGSize(width: itemWidth, height: itemHeight)
            let layout = AGEVideoLayout(level: 0)
                        .itemSize(.scale(itemSize))
            
            broadcastersView
                .listCount { [unowned self] (_) -> Int in
                    return self.videoSessions.count
                }.listItem { [unowned self] (index) -> UIView in
                    return self.videoSessions[index.item].hostingView
                }
            
            broadcastersView.setLayouts([layout], animated: true)
        }
    }
//    func updateUser() {
//        // video views layout
//        if videoSessions.count == maxVideoSession {
//            broadcastersView.reload(level: 0, animated: true)
//        } else {
//            var rank: Int
//            var row: Int
//
//            if videoSessions.count == 0 {
//                broadcastersView.removeLayout(level: 0)
//                return
//            } else if videoSessions.count == 1 {
//                rank = 1
//                row = 1
//            }
//                //else if videoSessions.count == 2 {
////                rank = 1
////                row = 2
////            } else {
////                rank = 2
////                row = Int(ceil(Double(videoSessions.count) / Double(rank)))
////            }
//
////            let itemWidth = CGFloat(1.0) / CGFloat(rank)
////            let itemHeight = CGFloat(1.0) / CGFloat(row)
//            //let itemSize = CGSize(width: itemWidth, height: itemHeight)
////            let layout = AGEVideoLayout(level: 0)
////                        .itemSize(.scale(itemSize))
//
//            broadcastersView
//                .listCount { [unowned self] (_) -> Int in
//                    return self.videoSessions.count
//                }.listItem { [unowned self] (index) -> UIView in
//                    return self.videoSessions[index.item].hostingView
//                }
//
////            broadcastersView.setLayouts([layout], animated: true)
//        }
//    }
    func updateButtonsVisiablity() {
        guard let sessionButtons = sessionButtons else {
            return
        }
        
        let isHidden = settings.role == .audience
        
        for item in sessionButtons {
            item.isHidden = isHidden
        }
    }
    
    func setIdleTimerActive(_ active: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !active
    }
}

private extension LiveRoomViewController {
    func getSession(of uid: UInt) -> VideoSession? {
        for session in videoSessions {
            if session.uid == uid {
                return session
            }
        }
        return nil
    }
    
    func videoSession(of uid: UInt) -> VideoSession {
        if let fetchedSession = getSession(of: uid) {
            return fetchedSession
        } else {
            let newSession = VideoSession(uid: uid)
            videoSessions.append(newSession)
            return newSession
        }
    }
}

//MARK: - Agora Media SDK
private extension LiveRoomViewController {
    func loadAgoraKit() {
        guard let channelId = settings.roomName else {
            return
        }
        
        setIdleTimerActive(false)
        agoraKit.delegate = self
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(settings.role)
        agoraKit.enableDualStreamMode(true)
        agoraKit.enableVideo()
        agoraKit.setVideoEncoderConfiguration(
            AgoraVideoEncoderConfiguration(
                size: settings.dimension,
                frameRate: settings.frameRate,
                bitrate: AgoraVideoBitrateStandard,
                orientationMode: .adaptative,
                mirrorMode: .auto
            )
        )
        
        if settings.role == .broadcaster {
            addLocalSession()
            agoraKit.startPreview()
        }
        print(settings.role , "role")
        //print("token", settings.token!)
        print("cahnnel", settings.roomName!)
        agoraKit.joinChannel(byToken: "", channelId: channelId, info: nil, uid: 0, joinSuccess: nil)
        print("didjoino")
       UpdateLiveuser()
//        if strRole == "audience" {
//
//        }else{
//            UpdateLiveuser()
//        }
       
        // Step 6, set speaker audio route
        agoraKit.setEnableSpeakerphone(true)
    }
    func UpdateLiveuser(){
        print("picture",user_pic)
        let ref = Database.database().reference()
        ref.keepSynced(true)
        let childUpdates = ref.child("LiveUsers").child("\(user_Id)")
        childUpdates.keepSynced(true)
        let values = ["user_name" : "\(user_name)","user_id" : "\(user_Id)","user_picture" : "\(user_pic)","rtc_token" : "\(agora_token)"]
        childUpdates.updateChildValues(values) { (err, reference) in
            print("Error_is_here",err)
            if err == nil{
            }
            print("reference_is_here",reference)
        }

    }
    func addLocalSession() {
        let localSession = VideoSession.localSession()
        localSession.updateInfo(fps: settings.frameRate.rawValue)
        videoSessions.append(localSession)
        agoraKit.setupLocalVideo(localSession.canvas)
    }
    
    func leaveChannel() {
        agoraKit.setupLocalVideo(nil)
        agoraKit.leaveChannel(nil)
        if settings.role == .broadcaster {
            agoraKit.stopPreview()
        }
        setIdleTimerActive(true)
        let defaultID = "\(Defaults[PDUserDefaults.UserID])"
        if self.user_Id == defaultID {
            Database.database().reference().child("LiveUsers").child("\(self.user_Id)").removeValue()
            UserDefaults.standard.set(self.user_Id, forKey: "liveUsers")
        }else{
            Database.database().reference().child("LiveUsers").child("\(defaultID)").removeValue()
            UserDefaults.standard.set(self.user_Id, forKey: "liveUsers")
        }
        self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
    }
}

// MARK: - AgoraRtcEngineDelegate
extension LiveRoomViewController: AgoraRtcEngineDelegate {
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstLocalVideoFrameWith size: CGSize, elapsed: Int) {
        if let selfSession = videoSessions.first {
            selfSession.updateInfo(resolution: size)
        }
    }
    
    /// Reports the statistics of the current call. The SDK triggers this callback once every two seconds after the user joins the channel.
    func rtcEngine(_ engine: AgoraRtcEngineKit, reportRtcStats stats: AgoraChannelStats) {
        if let selfSession = videoSessions.first {
            selfSession.updateChannelStats(stats)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        guard videoSessions.count <= maxVideoSession else {
            return
        }
        
        let userSession = videoSession(of: uid)
        userSession.updateInfo(resolution: size)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        guard videoSessions.count <= maxVideoSession else {
            return
        }
        let userSession = videoSession(of: uid)
        agoraKit.setupRemoteVideo(userSession.canvas)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        var indexToDelete: Int?
        for (index, session) in videoSessions.enumerated() where session.uid == uid {
            indexToDelete = index
            break
        }
        
        if let indexToDelete = indexToDelete {
            let deletedSession = videoSessions.remove(at: indexToDelete)
            deletedSession.hostingView.removeFromSuperview()
            
            // release canvas's view
            deletedSession.canvas.view = nil
        }
    }
    
    /// Reports the statistics of the video stream from each remote user/host.
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteVideoStats stats: AgoraRtcRemoteVideoStats) {
        if let session = getSession(of: stats.uid) {
            session.updateVideoStats(stats)
        }
    }
    
    /// Reports the statistics of the audio stream from each remote user/host.
    func rtcEngine(_ engine: AgoraRtcEngineKit, remoteAudioStats stats: AgoraRtcRemoteAudioStats) {
        if let session = getSession(of: stats.uid) {
            session.updateAudioStats(stats)
        }
    }
    
    /// Reports a warning during SDK runtime.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print("warning code: \(warningCode.description)")
    }
    
    /// Reports an error during SDK runtime.
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print("warning code error: \(errorCode.description)")
        
    }
}

//extension for
extension LiveRoomViewController{
    func WSliveuser(){
        let ref = Database.database().reference()
        ref.child("LiveUsers").queryOrdered(byChild: "timestamp").observe(.value, with:{ snapshot in
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
//            print("dicValue_is",dicValue)
            // list all values
            if dicValue != nil{
                for (_, _) in dicValue! {
                   print("user live")
                }
            }else{
               // popup
                self.navigationController?.popToViewController(self.navigationController!.viewControllers[1], animated: true)
            }
            
        }) { error in
            print(error.localizedDescription)
        }
    }
    
}
