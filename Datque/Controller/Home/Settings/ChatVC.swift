//
//  ChatVC.swift
//  SocialApp
//
//  Created by mac on 07/01/22.
//

import UIKit
import iOSDropDown
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON
import FirebaseDatabase
import GiphyUISDK
import MobileCoreServices
import AVFoundation
import AVKit


class ChatVC: UIViewController, GiphyDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate,  MapMarkerDelegate {
    
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var viewThreeDots: UIView!
    @IBOutlet weak var viewReportUser: UIView!
    @IBOutlet weak var lblReportTitle: UILabel!
    @IBOutlet weak var lblReportUser: UILabel!
    @IBOutlet weak var btnBlock: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    {
            didSet {
                btnReport.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .disabled)
                btnReport.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
            }
        }
    @IBOutlet weak var ImgTik: UIImageView!
    @IBOutlet weak var lblReceiverName: UILabel!
    @IBOutlet weak var imgReceiverImg: UIImageViewX!
    var strSelection = Bool()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var messageCointainerScroll: UIScrollView!
    @IBOutlet weak var blockedLbl: UILabel!
    var selectedImage : UIImage?
    var lastChatBubbleY: CGFloat = 10.0
    var internalPadding: CGFloat = 8.0
    var lastMessageType: BubbleDataType?
    
    var infoWindow : ChatBubble?
    var imgToSend = UIImage()
    var pdfUrl : URL?
    var docUrl : URL?
    var delegate: MapMarkerDelegate?
    
    var strLastMsgId = ""
    var timer = Timer()
    var videoURL : NSURL?

    func didTapInfoButton(data: String) {
        print("data = \(data)")
    }
    
    var arrChatList = [String]()
    var arrChatDic = [UserChatDetailData]() //this is array of dictionary type UserChatDetailData
    var arrStatusChatDic = [UserChatDetailData]() //this is array of dictionary type UserChatDetailData
    var UserId = ""
    var UserName = ""
    var UserImg = ""
    var ReceiverID = ""
    var ReceiverName = ""
    var ReceiverImg = ""
    var ReceiverFirebaseTokn = ""
    
    var ref1: DatabaseReference! //for real time check data base firebase
    var match_api_run = "" //this is compulsary to come from any screen this is use for first time to start chat
    var blockuser :Bool = false
    @IBOutlet weak var viewMsgShowHide: UIViewX!
    
    let giphy = GiphyViewController()
    let emoji = GiphyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.is_user_chat_blocked(receiverId: ReceiverID)
        //for gif view
        self.viewGif()
        self.viewEmoji()
        
        //for giphy Gif
        giphy.delegate = self
        emoji.delegate = self
        
        //set user if self fb_if(firebaseid)
        self.UserId = Defaults[PDUserDefaults.UserID]
        
        //for get default sender info
        self.getSenderUserDetails()
        
        //for recever firebase token
        self.detailGetFirebase(receiverId: "\(ReceiverID)")
        
        //show receiver image and name
        self.showReceiverNameAndImg(receiverName: "\(ReceiverName)",receiverImg: "\(ReceiverImg)" )
        
        //call API for get receiverInfo (get_user_info_detail)
        self.getReceiverInfo(receiverId: "\(ReceiverID)")
        
        //Call all services
        self.CallAllServices()
        
        //call API get chat data (real time)
        self.getChatData1()
        
        // Do any additional setup after loading the view.
        print("ChatVC")
                
        self.txtMessage.text = "Enter Message"
        self.txtMessage.textColor = UIColor.lightGray
        
        self.messageCointainerScroll.contentSize = CGSize(width: messageCointainerScroll.frame.width, height: lastChatBubbleY + internalPadding)
        self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)

        btnReport.isEnabled = false           
    }
    
    @objc func timerAction() {
        
    }
    
    func CallAllServices(){
        if match_api_run == "0"{// "0" for all time ,and "1" for new chat create
            
            //check user(self) is block or  not
            self.isBlockorNot(userID: "\(Defaults[PDUserDefaults.UserID])", recverID: "\(ReceiverID)")
            
            //check receiver is block or not
            self.receiverIsBlockorNot(userID: "\(Defaults[PDUserDefaults.UserID])", recverID: "\(ReceiverID)")
            
            //check Last Msg Seen Or not
           // self.latMsgSeen(userID: "\(Defaults[PDUserDefaults.UserID])", recverID: "\(ReceiverID)")
            
            //for set status (seen at)
            self.statusCheckInbox(receiverId: "\(ReceiverID)")
            self.statusCheckChatFirst(receiverId: "\(ReceiverID)")
            self.statusCheckChatSecond(receiverId: "\(ReceiverID)")
            
            
        }else{// "1" for new chat create
            
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //set user if self fb_if(firebaseid)
        self.UserId = Defaults[PDUserDefaults.UserID]
        //for recever firebase token
        self.detailGetFirebase(receiverId: "\(ReceiverID)")
        //show receiver image and name
        self.showReceiverNameAndImg(receiverName: "\(ReceiverName)",receiverImg: "\(ReceiverImg)" )
        
        //call API for get receiverInfo (get_user_info_detail)
        self.getReceiverInfo(receiverId: "\(ReceiverID)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.timer.invalidate()
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func ActionVideoCall(_ sender: Any) {
        let PaymentSuccessed = UserDefaults.standard.bool(forKey: "Payment")
        let currentLogin = UserDefaults.standard.bool(forKey: "current")
        let ThreeDays = UserDefaults.standard.bool(forKey: "threedays")
        if PaymentSuccessed == true{
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController" ) as! VideoChatViewController
            VC.UserName = self.UserName
            VC.UserId = self.UserId
            VC.ReceiverID = self.ReceiverID
            self.navigationController?.pushViewController(VC, animated: true)
        }
        if currentLogin == true{
            let VC = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController" ) as! VideoChatViewController
            VC.UserName = self.UserName
            VC.UserId = self.UserId
            VC.ReceiverID = self.ReceiverID
            self.navigationController?.pushViewController(VC, animated: true)
        }
        if ThreeDays == true{
            displayMyAlertMessage()
        }
       
    }
    @objc func displayMyAlertMessage(){
        
        let dialogMessage = UIAlertController(title: "Your Free Trial Expired ", message: "", preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Renew", style: .default, handler: { (action) -> Void in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SelectPlaneVC") as! SelectPlaneVC
            self.navigationController?.pushViewController(vc, animated: false)
            NavigationBool = true
        })
        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    @IBAction func ActionVoiceCall(_ sender: Any) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "VoiceChatViewController" ) as! VoiceChatViewController
        VC.UserName = self.UserName
        VC.UserId = self.UserId
        VC.ReceiverID = self.ReceiverID
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionThreeDots(_ sender: Any) {
        self.viewThreeDots.superview?.bringSubviewToFront(self.viewThreeDots)
    }
    
    @IBAction func actionThreeDotViewCancel(_ sender: Any) {
        self.viewChat.superview?.bringSubviewToFront(self.viewChat)
    }
    
    @IBAction func ActionUnMatchUser(_ sender: Any) {
        self.UnMatchUserServices(senderID: "\(Defaults[PDUserDefaults.UserID])", receiverId: "\(ReceiverID)")
    }
    
    @IBAction func ActionBlockUser(_ sender: UIButton) {
       
//        self.BlockUserServices(senderID: "\(Defaults[PDUserDefaults.UserID])", receiverId: "\(ReceiverID)", btnTag: "\(sender.tag)")
        
        if blockuser == true {//0 is for unblock
            self.btnBlock.setTitle("Block User", for: .normal)
            unBlockUserChat(receiverId: "\(ReceiverID)")
        }else if blockuser == false {//1 is for block
            self.btnBlock.setTitle("Un Block User", for: .normal)
            BlockUserChat(receiverId: "\(ReceiverID)")
        }
        
        
    }
//    @IBAction func ActionReportUser(_ sender: UIButton) {
//        lblReportTitle.text = "Report \(ReceiverName)?"
//        lblReportUser.text = "\(ReceiverName) I'm no longer matched with"
//        self.viewReportUser.superview?.bringSubviewToFront(self.viewReportUser)
//    }
    @IBAction func ActionCheck(_ sender: UIButton) {
        if strSelection == false {
            self.strSelection = true
            btnReport.isEnabled = true
            self.ImgTik.image = #imageLiteral(resourceName: "deselect")
       }else if strSelection == true {
            self.strSelection = false
           self.ImgTik.image = #imageLiteral(resourceName: "untick")
           btnReport.isEnabled = false
       }
    }
    @IBAction func ActionReport(_ sender: UIButton) {
        ReportServices()
       
    }
    @IBAction func ActionReportCancel(_ sender: UIButton) {
        self.viewChat.superview?.bringSubviewToFront(self.viewChat)
    }
    @IBAction func ActionOpenGif(_ sender: Any) {
        present(giphy, animated: true, completion: nil)
    }
    
    @IBAction func ActionOpenEmoji(_ sender: Any) {
        present(emoji, animated: true, completion: nil)
        
    }
    @IBAction func ActionOpenCamera(_ sender: Any) {
        self.selectOption()
    }
}


extension ChatVC {
    
    @IBAction func sendMethod(_ sender: UIButton) {
        
        let PaymentSuccessed = UserDefaults.standard.bool(forKey: "Payment")
        let currentLogin = UserDefaults.standard.bool(forKey: "current")
        let ThreeDays = UserDefaults.standard.bool(forKey: "threedays")
        
        if PaymentSuccessed == true{
            let dateFormatterGet = DateFormatter()
            //dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateFormatterGet.dateFormat = "hh:mm a"
            let curDateMSG = dateFormatterGet.string(from: Date())
            dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let curDateFIREBASE = dateFormatterGet.string(from: Date())
                            
            if self.txtMessage.text!.count > 0 && self.txtMessage.text! != "Enter Message"{
                //
               /* let bubbleData = ChatBubbleData(text: self.txtMessage.text! + "\n\(curDateMSG)", image: nil, gif: nil, date: Date(), type: BubbleDataType(rawValue: 0)!)
                
                addChatBubble(data: bubbleData)*/
                //MARK: - //API CALLING TO SEND MESSAGE
                
                if match_api_run == "0"{// for all times
                    self.sendMessageOnFirebase(message: "\(self.txtMessage.text!)", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverName: self.ReceiverName, receiverImg: self.ReceiverImg, timestamp: "\(curDateFIREBASE)", picUrl: "", type: "text")
                }else if match_api_run == "1"{// for only first times chat will create
                    //Call API firstchat
                    self.callFirstChat(message: "\(self.txtMessage.text!)", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverImg: self.ReceiverImg, receiverName: self.ReceiverName, timestamp: "\(curDateFIREBASE)", picUrl: "", type: "text")
                }
                
                self.txtMessage.text = ""
            }
        }
        if ThreeDays == true{
            displayMyAlertMessage()
        }
        if currentLogin == true{
            let dateFormatterGet = DateFormatter()
            //dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            dateFormatterGet.dateFormat = "hh:mm a"
            let curDateMSG = dateFormatterGet.string(from: Date())
            dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let curDateFIREBASE = dateFormatterGet.string(from: Date())
                            
            if self.txtMessage.text!.count > 0 && self.txtMessage.text! != "Enter Message"{
                //
               /* let bubbleData = ChatBubbleData(text: self.txtMessage.text! + "\n\(curDateMSG)", image: nil, gif: nil, date: Date(), type: BubbleDataType(rawValue: 0)!)
                
                addChatBubble(data: bubbleData)*/
                //MARK: - //API CALLING TO SEND MESSAGE
                
                if match_api_run == "0"{// for all times
                    self.sendMessageOnFirebase(message: "\(self.txtMessage.text!)", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverName: self.ReceiverName, receiverImg: self.ReceiverImg, timestamp: "\(curDateFIREBASE)", picUrl: "", type: "text")
                }else if match_api_run == "1"{// for only first times chat will create
                    //Call API firstchat
                    self.callFirstChat(message: "\(self.txtMessage.text!)", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverImg: self.ReceiverImg, receiverName: self.ReceiverName, timestamp: "\(curDateFIREBASE)", picUrl: "", type: "text")
                }
                
                self.txtMessage.text = ""
            }
        }
        
        
    }
    
    
    func addChatBubble(data: ChatBubbleData) {
        let padding:CGFloat = lastMessageType == data.type ? internalPadding/3.0 :  internalPadding
        let chatBubble = ChatBubble(data: data, startY:lastChatBubbleY + padding)
        chatBubble.delegate = self
        self.messageCointainerScroll.addSubview(chatBubble)
        lastChatBubbleY = chatBubble.frame.maxY
                
        self.messageCointainerScroll.contentSize = CGSize(width: messageCointainerScroll.frame.width, height: lastChatBubbleY + internalPadding)
        self.moveToLastMessage()
        lastMessageType = data.type
        //sendButton.isEnabled = false
    }
    
    
    @objc func handleTap(_ tapGesture: UITapGestureRecognizer) {
           print("clicked")
    }
    
    
    func moveToLastMessage() {
        if messageCointainerScroll.contentSize.height > messageCointainerScroll.frame.height {
            let contentOffSet = CGPoint(x: 0.0, y: messageCointainerScroll.contentSize.height - messageCointainerScroll.frame.height)
            self.messageCointainerScroll.setContentOffset(contentOffSet, animated: true)
        }
    }
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let curDate = dateFormatterGet.string(from: Date())
        
        let path = urls[0].lastPathComponent
        if path.contains("pdf") {
            //let data = urls[0]
            pdfUrl = urls[0]
            let bubbleData = ChatBubbleData(text: self.txtMessage.text! + " \(curDate)", image: UIImage.init(named: "pdfimg"), gif: nil, date: Date(), videoURL: nil, type: BubbleDataType(rawValue: 0)!)
            
            addChatBubble(data: bubbleData)
            //MARK: //API Calling to send pdf message
            
            
            
            //self.AttachDocImgService(strType: "pdf")
             self.txtMessage.text = ""
        }else if path.contains("docx"){
            docUrl = urls[0]
            let bubbleData = ChatBubbleData(text: self.txtMessage.text! + " \(curDate)", image: UIImage.init(named: "docimg"), gif: nil, date: Date(), videoURL: nil, type: BubbleDataType(rawValue: 0)!)
            addChatBubble(data: bubbleData)
            //MARK: //API Calling to send document message
            
            
            
            //self.AttachDocImgService(strType: "doc")
             self.txtMessage.text = ""
        }
    }


    func selectOption () {
        
        //Create alert of selection
        let alert = UIAlertController(title: "Select" , message: nil, preferredStyle: UIAlertController.Style.alert)
         let action1 = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default) { _ in
              self.CameraMethod()
         }
         let action2  = UIAlertAction(title: "Choose from Gallery", style: UIAlertAction.Style.default) { (action) in
              self.GalleryMethod()
         }
        let action3  = UIAlertAction(title: "Select Video", style: UIAlertAction.Style.default) { (action) in
            self.openVideoGallery()

        }
          let action4 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
             self.dismiss(animated: true, completion: nil)
          }
         alert.addAction(action1)
         alert.addAction(action2)
         alert.addAction(action3)
         alert.addAction(action4)
         self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- Extenction for (Camera and Gallery image select)
extension ChatVC {
    
    func GalleryMethod(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func CameraMethod() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            self.view.makeToast("Camera is not available")
        }
    }
    func openVideoGallery() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
//        present(picker, animated: true){
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
//               picker.dismiss(animated: false, completion: nil)
//            }
//        }
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let curDate = dateFormatterGet.string(from: Date())
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
//           let optimizedImageData = image.jpegData(compressionQuality: 0.6)
//        {
//
//            //to show image bubble chat
////            let bubbleData = ChatBubbleData(text: "\(curDate)" + "\n\("sent")", image: image, gif: nil, date: Date(), type: BubbleDataType(rawValue: 0)!)
////
////            addChatBubble(data: bubbleData)
//            self.imgToSend = image
//
//            //MARK: //API Calling to send image message
//            //first upload image on firebase storage and then update their firebase image url of firebase database
//            self.uploadFirebaseImage(imageData: optimizedImageData)
//
//        }//if let mediaType =  info[UIImagePickerController.InfoKey.mediaURL] as? String {
//            //if mediaType == kUTTypeMovie as String{
//        else if let video = info[UIImagePickerController.InfoKey.mediaURL] as? Data {
//            let optimizedVideoData = video
//            //{
//
//              //  self.videoURL = video
//                //self.videoURL as! URL = videoURL
//                self.uploadFirebaseVideo(videoData: optimizedVideoData)
//                print("Video URL: \(videoURL)")
//                //}
//                //}
//           // }
//        }
//        self.dismiss(animated: true,  completion: nil)
//        //self.dismiss(animated: true, completion: nil)
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
                if mediaType == kUTTypeImage as String,
                   let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
                   let optimizedImageData = image.jpegData(compressionQuality: 0.6) {
                    
                    // Handle image selection and uploading
                    self.uploadFirebaseImage(imageData: optimizedImageData)
                } else if mediaType == kUTTypeMovie as String,
                          let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    print("Media type is video")
                    print("Video URL: \(videoURL)")
                    do {
                                    let videoData = try Data(contentsOf: videoURL)
                                    // Now you have the video as Data and can use it as needed
                                    // For example, you can upload the video to Firebase Storage
                                    self.uploadFirebaseVideo(videoData: videoData)
                                } catch {
                                    print("Error converting video URL to data: \(error.localizedDescription)")
                                }
                    // Handle video selection and uploading
                   // self.uploadFirebaseVideo(videoData: videoURL)
                }
            }
            
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Extension for upload image on firebase storage
extension ChatVC{
    
func uploadFirebaseImage(imageData: Data)
    {

        let storageReference = Storage.storage().reference()
        let profileImageRef = storageReference.child("images/\(UUID().uuidString)")
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        profileImageRef.putData(imageData, metadata: uploadMetaData) { (uploadedImageMeta, error) in
            
            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                profileImageRef.downloadURL(completion: { [self] (url, error) in
                    print("imgFireBasePath URL: \((url?.absoluteString)!)")
                    
                    //send image url on firebase database
                    let img = (url?.absoluteString)!
                    
                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "hh:mm a"
                    let curDateMSG = dateFormatterGet.string(from: Date())
                    dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let curDateFIREBASE = dateFormatterGet.string(from: Date())
                    
                    if match_api_run == "0"{// for all times
                        self.sendMessageOnFirebase(message: "", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverName: self.ReceiverName, receiverImg: self.ReceiverImg, timestamp: "\(curDateFIREBASE)", picUrl: "\(img)", type: "image")
                    }else if match_api_run == "1"{// for only first times chat will create
                        //Call API firstchat
                        self.callFirstChat(message: "", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverImg: self.ReceiverImg, receiverName: self.ReceiverName, timestamp: "\(curDateFIREBASE)", picUrl: "\(img)", type: "image")
                    }
                    
                   
                })
            }
        }
    }
    func uploadFirebaseVideo(videoData: Data){

        let storageReference = Storage.storage().reference()
        let profileVideoRef = storageReference.child("Video/\(UUID().uuidString).mp4")

        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "Video/mp4"
        
        profileVideoRef.putData(videoData, metadata: uploadMetaData) { (uploadedImageMeta, error) in

            if error != nil
            {
                print("Error took place \(String(describing: error?.localizedDescription))")
                return
            } else {
                print("Meta data of uploaded image \(String(describing: uploadedImageMeta))")
                profileVideoRef.downloadURL(completion: { [self] (url, error) in
                    print("imgFireBasePath URL: \((url?.absoluteString)!)")

                    //send image url on firebase database
                    let Video = (url?.absoluteString)!

                    let dateFormatterGet = DateFormatter()
                    dateFormatterGet.dateFormat = "hh:mm a"
                    let curDateMSG = dateFormatterGet.string(from: Date())
                    dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let curDateFIREBASE = dateFormatterGet.string(from: Date())

                    if match_api_run == "0"{// for all times
                        self.sendMessageOnFirebase(message: "", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverName: self.ReceiverName, receiverImg: self.ReceiverImg, timestamp: "\(curDateFIREBASE)", picUrl: "\(Video)", type: "video")
                    }else if match_api_run == "1"{// for only first times chat will create
                        //Call API firstchat
                        self.callFirstChat(message: "", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverImg: self.ReceiverImg, receiverName: self.ReceiverName, timestamp: "\(curDateFIREBASE)", picUrl: "\(Video)", type: "video")
                    }


                })
            }
        }
        
      
    }
}


extension ChatVC {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.txtMessage.textColor == UIColor.lightGray {
            self.txtMessage.text = nil
            self.txtMessage.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.txtMessage.text.isEmpty {
            self.txtMessage.text = "Enter Message"
            self.txtMessage.textColor = UIColor.lightGray
        }
    }
    
}

//extension for get chat
extension ChatVC {
    
    func getChatData1() {
        
        let ref = Database.database().reference()
        ref.child("chat").child("\(self.UserId)" + "-" + "\(self.ReceiverID)").observe(.childAdded) { snapshot in
            let dicObject = snapshot.value as! [String: AnyObject]
            print("New_Chat_Added_Child_added",dicObject)
            
            self.ShowSingleChatMessage(objData: UserChatDetailData(json: dicObject))
            
            //update status as read message
            self.statusCheckInbox(receiverId: "\(self.ReceiverID)")
        }
                
    }
    
   /* func getChatData() {
        //blank array chat list
        self.arrChatDic = []
        
        let ref = Database.database().reference()
        ref.child("chat").child("\(self.UserId)" + "-" + "\(self.ReceiverID)").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            // list all values
            self.arrChatDic = []
            
            if dicValue != nil {
                for (key, valueq) in dicValue! {
                    self.arrChatDic.append(UserChatDetailData(json: valueq as! [String : Any]))
                }
            }
            
            //short an array according to timestamp (short with date and time)
            self.arrChatDic = self.arrChatDic.sorted { (firstItem, secondItem) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

                if let dateAString = firstItem.timestamp,
                   let dateBString = secondItem.timestamp,
                    let dateA = dateFormatter.date(from: dateAString),
                    let dateB = dateFormatter.date(from: dateBString) {
                    return dateA.compare(dateB) == .orderedAscending
                }
                return false
            }
            
          //  self.arrChatDic = self.arrChatDic.sorted { ($0.timestamp!) < ($1.timestamp!) }
            print("After Sort",self.arrChatDic)
            
            if self.arrChatDic.count > 0 {
                self.ShowChatHistory()
            }
            
        }) { error in
          print(error.localizedDescription)
        }
        
    }
    */
    
    func ShowSingleChatMessage(objData:UserChatDetailData) {

        
            let strDate = self.convertDateForiLearning(objData.timestamp!)
            
            if objData.senderID == Defaults[PDUserDefaults.UserID] {
                
                //check chat status(seen or not)
                var chat_Status = "\(objData.status!)"
                if chat_Status == "1"{
                    let chng_Status_time = self.convertDateForiLearningSecond(objData.time!)
                    chat_Status = "seen at " + "\(chng_Status_time)"
                }else{
                    chat_Status = "sent"
                }
                //check message type:-
                let msg_Type = "\(objData.type!)"
                
                switch msg_Type {
                  ////////////////sender case first
                  case "text":
                    print("msg_Type:- text")
                    let chatBubbleData2 = ChatBubbleData(text: objData.text! + "\n\(strDate)" + "\n\(chat_Status)", image:nil, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Mine)
                    self.addChatBubble(data: chatBubbleData2)
                    
                  ////////////////sender case second
                  case "image":
                    print("msg_Type: image")
                    //convert imageUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"
                    
                    if imageSent != "0" && imageSent != "" {
                        
                        let url = URL(string:"\(String(describing: objData.picURL!))")
                        if let data = try? Data(contentsOf: url!)
                        {
                            image = UIImage(data: data)!
                        }
                        
                    }
                    let chatBubbleData2 = ChatBubbleData(text: "\(strDate)" + "\n\(chat_Status)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Mine)
                    self.addChatBubble(data: chatBubbleData2)
                    
                  ////////////////sender case thied
                  case "gif":
                    print("msg_Type:- gif")
                    //convert gifUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"

                    if imageSent != "0" && imageSent != "" {
                        
                        let urlgif = "\(AppUrl.gifFirstURL())" + "\(String(describing: objData.picURL!))" + "\(AppUrl.gifThirdURL())"
                        
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)" + "\n\(chat_Status)", image: nil, gif: "\(urlgif)", date: NSDate() as Date, videoURL: nil, type: .Mine)
                        self.addChatBubble(data: chatBubbleData2)

                    }else{ //if GIf image is blank
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)" + "\n\(chat_Status)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Mine)
                        self.addChatBubble(data: chatBubbleData2)
                    }
                    
                  ///////////////sender case fourth
                  case "video":
                    print("msg_Type:- video")
                    let videoURLString = "\(objData.picURL!)"
                      if !videoURLString.isEmpty {
                          let videoURL = URL(string: videoURLString)
                          let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: nil, gif: nil, date: NSDate() as Date, videoURL: videoURL, type: .Mine)
                          self.addChatBubble(data: chatBubbleData2)
                      }
                 ////////////////sender case five default
                 default:
                    print("Invalid msg_Type")
                }
                
                
            }else{
                
                //check message type:-
                let msg_Type = "\(objData.type!)"
                switch msg_Type {
                    ////////////////receiver case first
                  case "text":
                    print("msg_Type:- text")
                    
                    let chatBubbleData2 = ChatBubbleData(text: objData.text! + "\n\(strDate)", image:nil, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Opponent)
                    self.addChatBubble(data: chatBubbleData2)
                    
                    ////////////////receiver case second
                  case "image":
                    print("msg_Type: image")
                    //convert imageUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"
                    
                    if imageSent != "0" && imageSent != "" {
                        
                        let url = URL(string:"\(String(describing: objData.picURL!))")
                        if let data = try? Data(contentsOf: url!)
                        {
                            image = UIImage(data: data)!
                        }
                        
                    }
                    
                    let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Opponent)
                    self.addChatBubble(data: chatBubbleData2)
                  
                    ////////////////receiver case third
                  case "gif":
                    print("msg_Type:- gif")
                    //convert gifUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"

                    if imageSent != "0" && imageSent != "" {
                        
                        let urlgif = "\(AppUrl.gifFirstURL())" + "\(String(describing: objData.picURL!))" + "\(AppUrl.gifThirdURL())"
                        
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: nil, gif: "\(urlgif)", date: NSDate() as Date, videoURL: nil, type: .Opponent)
                        self.addChatBubble(data: chatBubbleData2)

                    }else{ //if GIf image is blank
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Opponent)
                        self.addChatBubble(data: chatBubbleData2)
                    }
                    
                    ////////////////receiver case fourth
                  case "video":
                    print("msg_Type:- video")
                    let videoURLString = "\(objData.picURL!)"
                      if !videoURLString.isEmpty {
                          let videoURL = URL(string: videoURLString)
                          let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: nil, gif: nil, date: NSDate() as Date, videoURL: videoURL, type: .Opponent)
                          self.addChatBubble(data: chatBubbleData2)
                      }
                    ////////////////receiver case five default
                 default:
                    print("Invalid msg_Type")
                }
                
                
            }
     
        

        
    }
    
    
    func ShowChatHistory() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        for objData in self.arrChatDic {
            
            let strDate = self.convertDateForiLearning(objData.timestamp!)
            
            if objData.senderID == Defaults[PDUserDefaults.UserID] {
                
                //check chat status(seen or not)
                var chat_Status = "\(objData.status!)"
                if chat_Status == "1"{
                    let chng_Status_time = self.convertDateForiLearningSecond(objData.time!)
                    chat_Status = "seen at " + "\(chng_Status_time)"
                }else{
                    chat_Status = "sent"
                }
                //check message type:-
                let msg_Type = "\(objData.type!)"
                
                switch msg_Type {
                  ////////////////sender case first
                  case "text":
                    print("msg_Type:- text")
                    let chatBubbleData2 = ChatBubbleData(text: objData.text! + "\n\(strDate)" + "\n\(chat_Status)", image:nil, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Mine)
                    self.addChatBubble(data: chatBubbleData2)
                    
                  ////////////////sender case second
                  case "image":
                    print("msg_Type: image")
                    //convert imageUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"
                    
                    if imageSent != "0" && imageSent != "" {
                        
                        let url = URL(string:"\(String(describing: objData.picURL!))")
                        if let data = try? Data(contentsOf: url!)
                        {
                            image = UIImage(data: data)!
                        }
                        
                    }
                    let chatBubbleData2 = ChatBubbleData(text: "\(strDate)" + "\n\(chat_Status)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Mine)
                    self.addChatBubble(data: chatBubbleData2)
                    
                  ////////////////sender case thied
                  case "gif":
                    print("msg_Type:- gif")
                    //convert gifUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"

                    if imageSent != "0" && imageSent != "" {
                        
                        let urlgif = "\(AppUrl.gifFirstURL())" + "\(String(describing: objData.picURL!))" + "\(AppUrl.gifThirdURL())"
                        
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)" + "\n\(chat_Status)", image: nil, gif: "\(urlgif)", date: NSDate() as Date, videoURL: nil, type: .Mine)
                        self.addChatBubble(data: chatBubbleData2)

                    }else{ //if GIf image is blank
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)" + "\n\(chat_Status)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Mine)
                        self.addChatBubble(data: chatBubbleData2)
                    }
                    
                  ///////////////sender case fourth
                  case "video":
                    print("msg_Type:- video")
                    let videoURLString = "\(objData.picURL!)"
                      if !videoURLString.isEmpty {
                          let videoURL = URL(string: videoURLString)
                          
                          let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: nil, gif: nil, date: NSDate() as Date, videoURL: videoURL, type: .Mine)
                          self.addChatBubble(data: chatBubbleData2)
                      }
                 ////////////////sender case five default
                 default:
                    print("Invalid msg_Type")
                }
                
                
            }else{
                
                //check message type:-
                let msg_Type = "\(objData.type!)"
                switch msg_Type {
                    ////////////////receiver case first
                  case "text":
                    print("msg_Type:- text")
                    
                    let chatBubbleData2 = ChatBubbleData(text: objData.text! + "\n\(strDate)", image:nil, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Opponent)
                    self.addChatBubble(data: chatBubbleData2)
                    
                    ////////////////receiver case second
                  case "image":
                    print("msg_Type: image")
                    //convert imageUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"
                    
                    if imageSent != "0" && imageSent != "" {
                        
                        let url = URL(string:"\(String(describing: objData.picURL!))")
                        if let data = try? Data(contentsOf: url!)
                        {
                            image = UIImage(data: data)!
                        }
                        
                    }
                    
                    let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Opponent)
                    self.addChatBubble(data: chatBubbleData2)
                  
                    ////////////////receiver case third
                  case "gif":
                    print("msg_Type:- gif")
                    //convert gifUrl to UIImage
                    var image:UIImage = UIImage(named:"imageFail")!
                    let imageSent = "\(String(describing: objData.picURL!))"
                    if imageSent != "0" && imageSent != "" {
                        let urlgif = "\(AppUrl.gifFirstURL())" + "\(String(describing: objData.picURL!))" + "\(AppUrl.gifThirdURL())"
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: nil, gif: "\(urlgif)", date: NSDate() as Date, videoURL: nil, type: .Opponent)
                        self.addChatBubble(data: chatBubbleData2)

                    }else{ //if GIf image is blank
                        let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: image, gif: nil, date: NSDate() as Date, videoURL: nil, type: .Opponent)
                        self.addChatBubble(data: chatBubbleData2)
                    }
                    
                    ////////////////receiver case fourth
                  case "video":
                    print("msg_Type:- video")
                    let videoURLString = "\(objData.picURL!)"
                      if !videoURLString.isEmpty {
                          let videoURL = URL(string: videoURLString)
                          let chatBubbleData2 = ChatBubbleData(text: "\(strDate)", image: nil, gif: nil, date: NSDate() as Date, videoURL: videoURL, type: .Opponent)  
                          self.addChatBubble(data: chatBubbleData2)
                         
                      }
                    
                    ////////////////receiver case five default
                    ///
                 default:
                    print("Invalid msg_Type")
                }
                
                
            }
        }
        
        PKHUD.sharedHUD.hide()
        
    }
    
    
    func convertDateForiLearning(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        
        if date != nil {
            return dateFormatter.string(from: date!)
        }else{
            return ""
        }
    }
    
    func convertDateForiLearningSecond(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        
        if date != nil {
            return dateFormatter.string(from: date!)
        }else{
            return ""
        }
    }
    
}

//extension for gif Show
extension ChatVC {
    func viewGif(){
        giphy.mediaTypeConfig = [.gifs, .stickers, .text, .emoji]
        giphy.mediaTypeConfig = [.gifs, .stickers, .recents]
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.stickerColumnCount = GPHStickerColumnCount.three
        giphy.showConfirmationScreen = true
        giphy.rating = .ratedPG13
        giphy.renditionType = .fixedWidth
        giphy.shouldLocalizeSearch = false
        GiphyViewController.trayHeightMultiplier = 0.7
        // present(giphy, animated: true, completion: nil) // this line is user to show gif view controller
        Giphy.configure(apiKey: "srnWCacnoxSOC9Fw6hZW5h273VxmfNxf") //key for Gipy GIF
        
    }
    func viewEmoji(){
        emoji.mediaTypeConfig = [.emoji, .stickers, .text, .emoji]
        emoji.mediaTypeConfig = [.emoji, .stickers, .recents]
        emoji.theme = GPHTheme(type: .lightBlur)
        emoji.stickerColumnCount = GPHStickerColumnCount.three
        emoji.showConfirmationScreen = true
        emoji.rating = .ratedPG13
        emoji.renditionType = .fixedWidth
        emoji.shouldLocalizeSearch = false
        GiphyViewController.trayHeightMultiplier = 0.7
        // present(giphy, animated: true, completion: nil) // this line is user to show gif view controller
        Giphy.configure(apiKey: "srnWCacnoxSOC9Fw6hZW5h273VxmfNxf") //key for Gipy GIF
        
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia)   {
        //this is for dismiss gippy view
        giphyViewController.dismiss(animated: true, completion: nil)
        //get gippy media id
        let Gippy_id = media.id
        print("Gippy_id_is",Gippy_id)
        
        //MARK: //API Calling to send url GIF message
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "hh:mm a"
        let curDateMSG = dateFormatterGet.string(from: Date())
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let curDateFIREBASE = dateFormatterGet.string(from: Date())
        
        if Gippy_id != "" {
//            let urlgif = "\(AppUrl.gifFirstURL())" + "\(Gippy_id)" + "\(AppUrl.gifThirdURL())"
//
//            let chatBubbleData2 = ChatBubbleData(text: "\(curDateMSG)" + "\n\("sent")", image: nil, gif: "\(urlgif)", date: NSDate() as Date, type: .Mine)
//            self.addChatBubble(data: chatBubbleData2)
            
            //MARK: //API Calling to send url GIF message
            if match_api_run == "0"{// for all times
                self.sendMessageOnFirebase(message: "", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverName: self.ReceiverName, receiverImg: self.ReceiverImg, timestamp: "\(curDateFIREBASE)", picUrl: "\(Gippy_id)", type: "gif")
            }else if match_api_run == "1"{// for only first times chat will create
                //Call API firstchat
                self.callFirstChat(message: "", userID: self.UserId, userName: self.UserName, userImg: self.UserImg, receiverId: self.ReceiverID, receiverImg: self.ReceiverImg, receiverName: self.ReceiverName, timestamp: "\(curDateFIREBASE)", picUrl: "\(Gippy_id)", type: "gif")
            }
        }
        
        
    }
    
    func didDismiss(controller: GiphyViewController?) {
            // your user dismissed the controller without selecting a GIF.
        print("close Gif_Ayush")
       }
    
}

//MARK: - real time automatic functions
//extenion for check real time is block or not
extension ChatVC {
    
    //for real time check block or not
    func isBlockorNot(userID: String, recverID: String){
        ref1 = Database.database().reference()
        ref1.child("Inbox").child("\(recverID)").child("\(userID)").observe(.value) { (snapshot) in
            let dicValue = snapshot.value as? NSDictionary
            //print("dicValue_is_Message_Value:Child change_is",dicValue)
            let bblok = dicValue?.value(forKey: "block")
            print("bBlok",bblok)
            if bblok != nil{
                self.isBlock(block: "\(bblok!)")
            }else{
                //GO to back screen
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    func isBlock(block: String){
        print("bBlok1",block)
        if block == "1" {//user is block
            self.viewMsgShowHide.isHidden = true
        }else if block == "0" {//user  is unblock
            self.viewMsgShowHide.isHidden = false
        }
    }
    
    //real time check receiver is block or not
    func receiverIsBlockorNot(userID: String, recverID: String){
        ref1 = Database.database().reference()
        ref1.child("Inbox").child("\(userID)").child("\(recverID)").observe(.value) { (snapshot) in
            let dicValue = snapshot.value as? NSDictionary
            //print("dicValue_is_Message_Value:Child change_is",dicValue)
            let bblok = dicValue?.value(forKey: "block")
            print("bBlokreceiver",bblok)
            if bblok != nil{
                self.isBlockReceiver(block: "\(bblok!)")
            }else{
                //GO to back screen
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    func isBlockReceiver(block: String){
        print("bBlok1receiver",block)
        if block == "1" {//0 is for unblock
            self.btnBlock.setTitle("Un Block User", for: .normal)
            self.btnBlock.tag = 0
        }else if block == "0" {//1 is for block
            self.btnBlock.setTitle("Block User", for: .normal)
            self.btnBlock.tag = 1
        }
    }
    

}

//exteniosn for statusCheckInbox (deliver read or not)
extension ChatVC{
    ///////for inbox update
    func statusCheckInbox(receiverId: String){
        
        let ref = Database.database().reference()
        ref.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").child("\(receiverId)").observeSingleEvent(of: .value, with: { snapshot in
            
            if self.match_api_run == "0"{
                // Get user value
                let dicValue = snapshot.value as? NSDictionary
                let rid = dicValue!.value(forKey: "rid")
                
                if rid as! String == receiverId {
                    //change status in inbox folder on firebase
                    self.statusChangeInbox(receiverId: "\(receiverId)")
                }
            }else if self.match_api_run == "1"{
                
            }
            
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    func statusChangeInbox(receiverId: String) {
        //change status from inbox folder
        let ref = Database.database().reference()
        let childUpdates = ref.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").child("\(receiverId)")
        
        let values = ["status" : "1"]  // i thik also update real time here too
        childUpdates.updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                //reload chat
               // print("change_status_successfully")
            }
        }
    }
    
    ///////////for chat update first (UserId - ReceiverId)
    func statusCheckChatFirst(receiverId: String){
        let ref = Database.database().reference()
        let query = ref.child("chat").child("\(self.UserId)" + "-" + "\(receiverId)").queryOrdered(byChild: "status").queryEqual(toValue: "0")
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            // list all values
            self.arrStatusChatDic = []
            if dicValue != nil{
                for (key, valueq) in dicValue! {
                    self.arrStatusChatDic.append(UserChatDetailData(json: valueq as! [String : Any]))
                }
            }
            //print("arrStatusChatDic_is",self.arrStatusChatDic)
            
            if self.arrStatusChatDic.count >= 1{
                for objData in self.arrStatusChatDic {
                    let chatID = objData.chatID!
                    let senderId = objData.senderID!
                    if senderId != self.UserId {
                        //call Function statusChangeInbox
                        self.statusChangeChatFirst(receiverId: "\(receiverId)", ChatId: "\(chatID)")
                    }
                }
            }
        })
        
    }
    
    func statusChangeChatFirst(receiverId: String,ChatId: String){
        //get current date and time
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm"
        let curDate = dateFormatterGet.string(from: Date())
        
        //change status in chate
        let ref = Database.database().reference()
        let childUpdateschat = ref.child("chat").child("\(self.UserId)" + "-" + "\(receiverId)").child("\(ChatId)")
        
        let values = ["status" : "1",
                      "time" : "\(curDate)"]
        childUpdateschat.updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                //reload chat
              //  print("change_status_successfully_inChat_First")
            }
        }
    }
    
    ///////////for chat update second (ReceiverId - UserId)
    func statusCheckChatSecond(receiverId: String){
        let ref = Database.database().reference()
        let query = ref.child("chat").child("\(receiverId)" + "-" + "\(self.UserId)").queryOrdered(byChild: "status").queryEqual(toValue: "0")
        query.observeSingleEvent(of: .value, with: { snapshot in
            
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            // list all values
            self.arrStatusChatDic = []
            if dicValue != nil{
                for (key, valueq) in dicValue! {
                    self.arrStatusChatDic.append(UserChatDetailData(json: valueq as! [String : Any]))
                }
            }
            //print("arrStatusChatDic_is",self.arrStatusChatDic)
            
            if self.arrStatusChatDic.count >= 1{
                for objData in self.arrStatusChatDic {
                    let chatID = objData.chatID!
                    let senderId = objData.senderID!
                    if senderId != self.UserId {
                        //call Function statusChangeInbox
                        self.statusChangeChatSecond(receiverId: "\(receiverId)", ChatId: "\(chatID)")
                    }
                }
            }
        })
        
    }
    
    func statusChangeChatSecond(receiverId: String,ChatId: String){
        //get current date and time
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy HH:mm"
        let curDate = dateFormatterGet.string(from: Date())
        
        //change status in chate
        let ref = Database.database().reference()
        let childUpdateschat = ref.child("chat").child("\(receiverId)" + "-" + "\(self.UserId)").child("\(ChatId)")
        
        let values = ["status" : "1",
                      "time" : "\(curDate)"]
        childUpdateschat.updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                //reload chat
              //  print("change_status_successfully_inChat_Second")
            }
        }
    }
    
}

//extension for showReceiverNameAndImg
extension ChatVC {
    func showReceiverNameAndImg(receiverName: String, receiverImg: String){
        //for name
        self.lblReceiverName.text = receiverName
        
        //for image
        if receiverImg != nil && receiverImg != "" {
            var image = "\(receiverImg)"
          //  print("image_receiver_is_not_Nil :-\(image)")
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            self.imgReceiverImg.sd_setImage(with: URL(string: image), placeholderImage: nil)
        }else{
          //  print("Receiver_image_Nil")
            self.imgReceiverImg.image = #imageLiteral(resourceName: "ic_avatar")
        }
        
        //for real time receiver image change
        
    }
}

//Extension for get Receiver Info
extension ChatVC {
    func getReceiverInfo(receiverId: String){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
      //  print("getReceiverInfo")
        let url = AppUrl.getUserInfoURL()
        
        let strPhone = receiverId.replacingOccurrences(of: "+", with: "")
        let parameters: [String: Any] = ["fb_id" : strPhone,
                                         "device" : "ios"]
        
      //  print("Url_getReceiverInfo_is_here:-" , url)
      //  print("Param_getReceiverInfo_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
         //   print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
           //     print("Code_is_getReceiverInfo",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetUserInfoData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                let objProfileRes = (dicData.msg!.first)!
                                
                                //for name
                                self.lblReceiverName.text = "\(objProfileRes.firstName!)" + "\(objProfileRes.lastName!)"
                                
                                let receiverImg = "\(objProfileRes.image1!)"
                                
                                //for image
                                if receiverImg != nil && receiverImg != "" {
                                    var image = "\(receiverImg)"
                           //         print("image_receiver_is_not_Nil :-\(image)")
                                    image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                                    self.imgReceiverImg.sd_setImage(with: URL(string: image), placeholderImage: nil)
                                }else{
                            //        print("Receiver_image_Nil")
                                    self.imgReceiverImg.image = #imageLiteral(resourceName: "ic_avatar")
                                }

                            }
                        } catch {
                      //      print("Something went wrong in json.")
                        }
                    }
                }else if responseJson["code"] == "201" {
              //      print("Something went wrong error code 201")
                }else{
             //       print("Something went wrong in json")
                }
            }
        }
    }
}

/////////////below codes for send message images gif doc upload on firebase server
extension ChatVC{
    func ReportServices() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.ReportURL()
        let parameters: [String: Any] = ["user_fb_id" : "\(self.UserId)",
                                         "report_fb_id" : "\(self.ReceiverID)",
                                         "message" : "reported",
                                         "device" : "ios"]
        print("Url_SignUpServices_is_here:-" , url)
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
              if responseJson["code"] == "200" {
                    self.view.makeToast("\(responseJson["msg"])")
                    self.viewChat.superview?.bringSubviewToFront(self.viewChat)
                }else{
                    print("Something went wrong in json")
                }
            }
        }
    }
    //Call API firstchat
    func callFirstChat(message: String, userID: String, userName: String, userImg: String, receiverId: String, receiverImg: String, receiverName: String, timestamp: String, picUrl: String, type: String){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.firstChatURL()
        
        let parameters: [String: Any] = ["fb_id": userID,
                                         "effected_id": receiverId,
                                         "device" : "ios"]
        print("Url_firstChatURL_is_here:-" , url)
        print("Param_firstChatURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
         //   print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_firstChatURL",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    
                   // call firebase API to store data on firebase
                    self.sendMessageOnFirebase(message: message, userID: userID, userName: userName, userImg: userImg, receiverId: receiverId, receiverName: receiverName, receiverImg: receiverImg, timestamp: timestamp, picUrl: picUrl, type: type)

                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                }else if responseJson["code"] == "202"{
                    print("Something went wrong error code 202")
                }
            }
        }
    }
    
   //Upload texte message on firebase chat folder
    func sendMessageOnFirebase(message: String, userID: String,userName: String,userImg: String, receiverId: String, receiverName: String, receiverImg: String, timestamp: String, picUrl: String, type: String){
        let ref = Database.database().reference()
        let childCreateChatSender = ref.child("chat").child("\(userID)" + "-" + "\(receiverId)")
        let childCreateChatRecever = ref.child("chat").child("\(receiverId)" + "-" + "\(userID)")
        
        let  referencekey = ref.child("chat").child("\(userID)" + "-" + "\(receiverId)").childByAutoId().key
        // print("referencekey_is_here",referencekey)
        
        let values = ["chat_id" : "\(referencekey!)",
                      "lat" : "",
                      "long" : "",
                      "pic_url" : "\(picUrl)",
                      "rec_img" : "\(receiverImg)",
                      "receiver_id" : "\(receiverId)",
                      "sender_id" : "\(userID)",
                      "sender_name" : "\(userName)",
                      "status" : "0",
                      "text" : "\(message)",
                      "time" : "",
                      "timestamp" : "\(timestamp)",
                      "type" : "\(type)"]
        
        childCreateChatSender.child("\(referencekey!)").updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                //firebase inbox folder
                self.sendInboxFirebaseMessage(message: message, userID: userID, userName: userName, userImg: userImg, receiverId: receiverId, receiverName: receiverName, receiverImg: receiverImg, timestamp: timestamp, picUrl: picUrl, type: type)
            }
        }
        childCreateChatRecever.child("\(referencekey!)").updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                
            }
        }
    }
    
    //Upload texte message on firebase inbox folder
    func sendInboxFirebaseMessage(message: String, userID: String,userName: String,userImg: String, receiverId: String, receiverName: String, receiverImg: String, timestamp: String, picUrl: String, type: String){
        
        var msg:String = ""
        
        if type == "text" {
            msg = message
        }else if type == "image" {
            msg = "Send an image"
        }else if type == "gif" {
            msg = "Send an Gif"
        }else if type == "video" {
            msg = "Send an video"
        }
        
        let ref = Database.database().reference()
        let childInboxSender = ref.child("Inbox").child("\(receiverId)").child("\(userID)")
        let childInboxRecever = ref.child("Inbox").child("\(userID)").child("\(receiverId)")
        
        let valuesSender = ["block" : "0",
                      "date" : "\(timestamp)",
                      "like" : "0",
                      "msg" : "\(msg)",
                      "name" : "\(userName)",
                      "pic" : "\(userImg)",
                      "read" : "0",
                      "rid" : "\(userID)",
                      "sort" : "",
                      "status" : "0",
                      "timestamp" : "\(timestamp)"]
        
        childInboxSender.updateChildValues(valuesSender) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                //API Call for Push Notification
                self.sendPushNotification(message: message, userID: userID, userName: userName, userImg: userImg, receiverId: receiverId, receiverName: receiverName, receiverImg: receiverImg, timestamp: timestamp, picUrl: picUrl, type: type)
            }
        }
        
        let valuesRecever = ["block" : "0",
                      "date" : "\(timestamp)",
                      "like" : "0",
                      "msg" : "\(msg)",
                      "name" : "\(receiverName)",
                      "pic" : "\(receiverImg)",
                      "read" : "0",
                      "rid" : "\(receiverId)",
                      "sort" : "",
                      "status" : "1",
                      "timestamp" : "\(timestamp)"]
        
        childInboxRecever.updateChildValues(valuesRecever) { (err, reference) in
            // handle errors or anything related to completion block
            if err == nil {
                //reload chat
            }
        }
        
    }
    
    //function for push notification
    func sendPushNotification(message: String, userID: String,userName: String,userImg: String, receiverId: String, receiverName: String, receiverImg: String, timestamp: String, picUrl: String, type: String){
        print("sendPushNotification")
        
        var msg:String = ""
        if type == "text" {
            msg = message
        }else if type == "image" {
            msg = "Send an image"
        }else if type == "gif" {
            msg = "Send an Gif"
        }else if type == "video" {
            msg = "Send an video"
        }
        
        let url = AppUrl.sendPushNotificationURL()
       
        let parameters: [String: Any] = ["title" : "\(userName)" ,
                                         "message" : "\(msg)",
                                         "icon" : "\(userImg)" ,
                                         "tokon" : "\(self.ReceiverFirebaseTokn)" ,
                                         "senderid" : "\(userID) " ,
                                         "receiverid" : "\(receiverId)" ,
                                         "action_type" : "message",
                                         "device" : "ios"]
        
        print("Url_sendPushNotification_is_here:-" , url)
        print("Param_sendPushNotification_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { (response) in
          //  PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.data != nil {
                
                //update:- API updateFromFirbaseServices call
                self.updateFromFirbaseServices()
                
                let responseJson = JSON(response.value!)
                print("Code_is_sendPushNotification",responseJson["success"])
                if responseJson["success"] == 1 {
                    if let responseData = response.data {
                        do {
                            
                            print("API Run Push Notification successfully")
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetSendPushNotificationModel.self, from: responseData)
                            
                            self.updateFromFirbaseServices()
                            
                            if dicData.success == 1 {
                                print("Push Notification success_true = ",dicData.success!)
                              //  //self.updateFromFirbaseServices()
                            }else{
                                print("Push Notification success_false = ",dicData.success!)
                             //  // self.updateFromFirbaseServices()
                            }
                            
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                }else if responseJson["success"] == 0 {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
        
    }
    
    //call API Update From Firebase
    func updateFromFirbaseServices(){
        print("updateFromFirbaseServices")
        
        let url = AppUrl.updateFromFirebaseURL()
        let parameters: [String: Any] = ["" : ""]
        
        print("Url_updateFromFirbaseServices_is_here:-" , url)
        print("Param_updateFromFirbaseServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            print("Response",response)
            print("updateFromFirbaseServices_is_Done")
            
            self.match_api_run = "0"
            
            
        }
    }
    
}


//extension for three dots
extension ChatVC{
    //Call API for unmatchUserSrvices
    func UnMatchUserServices(senderID: String, receiverId: String){
        print("ActionUnMatchUser")
        
        let url = AppUrl.unMatchURL()
       
        let parameters: [String: Any] = ["fb_id" : "\(senderID)" ,
                                         "other_id" : "\(receiverId)",
                                         "device" : "ios"]
        
        print("Url_UnMatchUser_is_here:-" , url)
        print("Param_UnMatchUser_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { (response) in
          //  PKHUD.sharedHUD.hide()
            print("Response_UnMatchUser",response)
            if response.data != nil {
                
                //GO to back screen
                self.navigationController!.popViewController(animated: true)
                print("API Run UnMatchUser successfully")

            }
        }
        
    }
    
    func BlockUserServices(senderID: String, receiverId: String, btnTag: String){
        print("ActionBlockUser",btnTag)
        
        let ref = Database.database().reference()
        let childUpdates = ref.child("Inbox").child("\(senderID)").child("\(receiverId)")
        
        let values = ["block" : "\(btnTag)"]
        childUpdates.updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            
            if err == nil {
                //reload chat
                
            }
            
        }
    }
    
    func BlockUserChat(receiverId: String){
        print("Block_Report_User_API _Call")
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.blockUserChatURL()
        let parameters: [String: Any] = ["action_type" : "block",
                                         "fb_id" : "\(UserId)",
                                         "other_id" : "\(receiverId)",
                                         "device" : "ios"]
        
        print("Url_blockReportUser_is_here:-" , url)
        print("Param_blockReportUser_is_here:-" , parameters)
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_blockReportUser",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetFlatUserData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            let message = dicData.msg?.first
                            let response = message?.response!
                           // self.blockedLbl.isHidden = false
                         //   self.blockedLbl.text = "\(response!)"
                            self.txtMessage.isUserInteractionEnabled = false
                            self.view.makeToast("\(response!)")
                            
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
    
    
    func is_user_chat_blocked(receiverId: String){
        print("Block_Report_User_API _Call")
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.is_user_chat_blocked()
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "other_id" : "\(receiverId)",
                                         "device" : "ios"]
        
        print("Url_blockReportUser_is_here:-" , url)
        print("Param_blockReportUser_is_here:-" , parameters)
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_blockReportUser",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetFlatUserData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            let message = dicData.msg?.first
                            let response = message?.response!
                            self.blockuser = (message?.is_block)!
                            self.blockedLbl.isHidden = false
                            self.blockedLbl.text = "\(response!)"
                            self.txtMessage.isUserInteractionEnabled = false
                            if self.blockuser == true {//0 is for unblock
                                self.btnBlock.setTitle("Un Block User", for: .normal)
                            }else if self.blockuser == false {//1 is for block
                                self.btnBlock.setTitle("Block User", for: .normal)
                            }
                            self.view.makeToast("\(response!)")
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
    
    func unBlockUserChat(receiverId: String){

        print("Block_Report_User_API _Call")
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.blockUserChatURL()
        let parameters: [String: Any] = ["action_type" : "unblock",
                                         "fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "other_id" : "\(receiverId)",
                                         "device" : "ios"]

        print("Url_blockReportUser_is_here:-" , url)
        print("Param_blockReportUser_is_here:-" , parameters)

        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_blockReportUser",responseJson["code"])

                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetFlatUserData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            let message = dicData.msg?.first
                            let response = message?.response!
                            self.blockedLbl.isHidden = true
                            self.txtMessage.isUserInteractionEnabled = true
                            self.view.makeToast("\(response!)")
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

//extension for Default Data use
extension ChatVC{
    func getSenderUserDetails(){
        // Read/Get Data/decode userDefault data *****
            if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()
                    // Decode Note
                    let userSaveData = try decoder.decode(Msg.self, from: data)
                    
                    //for user name(sender name)
                    self.UserName = "\(userSaveData.firstName!)" + "\(userSaveData.lastName!)"
                    self.UserImg = "\(userSaveData.image1!)"
                    
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
    }
    
    func detailGetFirebase(receiverId: String){
        
        let ref = Database.database().reference()
        ref.child("Users").child("\(receiverId)").child("token").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let firebaseTokenValue = snapshot.value as? String
            
            if firebaseTokenValue != nil{
                self.ReceiverFirebaseTokn = firebaseTokenValue!
            }
           
        }) { error in
          print(error.localizedDescription)
        }
        
    }
    
}

