//
//  HomeVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import UIColor_FlatColors
import Cartography
import ZLSwipeableViewSwift
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON
import CoreLocation

var NavigationBool = false
class HomeVC: UIViewController, CLLocationManagerDelegate {
    
    //MARK: Variables
    var numberView:Int = 0
    var swipeableView: ZLSwipeableView!
    var ReceiverID = ""
    var ReceiverName = ""
    var arrDicNearbyUser = [MsguserNearByMe]() //this is array of dictionary type MsguserNearByMe
    var colorIndex = 0
    var loadCardsFromXib = false
    var reloadBarButtonItem: UIBarButtonItem!
    var leftBarButtonItem: UIBarButtonItem!
    var upBarButtonItem: UIBarButtonItem!
    var rightBarButtonItem: UIBarButtonItem!
    var downBarButtonItem:UIBarButtonItem!
    var locationManager = CLLocationManager()
    var myCurLat = ""
    var myCurLon = ""
    var nextdate  = String()
    var counter = 5
    var timer = Timer()
    var bool = false
    var currenttime = Int()
    var threedays = false
    var cureent = true
    var payment =  true
    
    //MARK: Outlets
    @IBOutlet weak var imgUserRadioWave: UIImageViewX!
    @IBOutlet weak var viewAnimated: UIRadioWaveAnimationView!
    @IBOutlet weak var viewThreeDots: UIView!
    @IBOutlet weak var viewReportUser: UIView!
    @IBOutlet weak var viewUserRadioWave: UIView!
    @IBOutlet weak var viewCard: CardView!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnDiscovery: UIButton!
    @IBOutlet weak var lblReportTitle: UILabel!
    @IBOutlet weak var lblReportUser: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    {
        didSet {
            btnReport.setTitleColor(UIColor.init(white: 1, alpha: 0.3), for: .disabled)
            btnReport.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        }
    }
    @IBOutlet weak var ImgTik: UIImageView!
    
    //MARK: LifeCycle and Layout Subviews
    func viewDidLayoutSubviewsa() {
        if self.arrDicNearbyUser.count < 4 {
            swipeableView.numberOfActiveView = UInt(self.arrDicNearbyUser.count)
        } else {
            swipeableView.numberOfActiveView = 4
        }
        swipeableView.nextView = {
            if self.arrDicNearbyUser.count >= 1 {
                return self.nextCardView()
                self.viewCard.superview?.bringSubviewToFront(self.viewCard)
            }else if self.arrDicNearbyUser.count < 1 {
                self.viewUserRadioWave.superview?.bringSubviewToFront(self.viewUserRadioWave)
            }
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewAnimated.startAnimation(setThemeColor: true)
        self.getCurrentLocation()
        self.deleteUser()
        viewThreeDots.isHidden = true
        viewThreeDots.frame = view.bounds
        view.addSubview(viewThreeDots)
        viewReportUser.isHidden = true
        viewReportUser.frame = view.bounds
        view.addSubview(viewReportUser)
        self.updateFCMToken()
        navigationController?.setToolbarHidden(false, animated: false)
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        reloadBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadButtonAction))
        leftBarButtonItem = UIBarButtonItem(title: "←", style: .plain, target: self, action: #selector(leftButtonAction))
        upBarButtonItem = UIBarButtonItem(title: "↑", style: .plain, target: self, action: #selector(upButtonAction))
        rightBarButtonItem = UIBarButtonItem(title: "→", style: .plain, target: self, action: #selector(rightButtonAction))
        downBarButtonItem = UIBarButtonItem(title: "↓", style: .plain, target: self, action: #selector(downButtonAction))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let items = [fixedSpace, reloadBarButtonItem!, flexibleSpace, leftBarButtonItem!, flexibleSpace, upBarButtonItem!, flexibleSpace, rightBarButtonItem!, flexibleSpace, downBarButtonItem!, fixedSpace]
        toolbarItems = items
        swipeableView = ZLSwipeableView()
        viewCard.addSubview(swipeableView)
        
        swipeableView.didStart = { view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = { view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = { view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = { view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
            if direction == .Left {
                self.numberView = self.numberView + 1
                var index = Int()
                if self.colorIndex >= self.arrDicNearbyUser.count {
                    index = (self.colorIndex - 1)
                }else{
                    index = (self.colorIndex - 4)
                }
                self.dislikeLeftSwipe(Index: index)
            } else if direction == .Right {
                self.numberView = self.numberView + 1
                var index = Int()
                if self.colorIndex >= self.arrDicNearbyUser.count {
                    index = (self.colorIndex - 1)
                }else{
                    index = (self.colorIndex - 4)
                }
                self.likeRightSwipe(Index:index)
            }
            
            if self.numberView == self.arrDicNearbyUser.count {
                self.viewCard.isHidden = true
                self.viewUserRadioWave.superview?.bringSubviewToFront(self.viewUserRadioWave)
            }
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        swipeableView.didTap = {view, location in
            var index = Int()
            if self.colorIndex >= self.arrDicNearbyUser.count {
                index = (self.colorIndex - 1)
            }else{
                index = (self.colorIndex - 4)
            }
            self.infoTapSwipe(Index:index )
        }
        swipeableView.didDisappear = { view in
            print("Did disappear swiping view,,last disapper view ",view.tag)
        }
        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+20
            view1.right == view2.right-20
            view1.top == view2.top + 95
            view1.bottom == view2.bottom - 100
        }
        currentdate()
        let user_id  = UserDefaults.standard.value(forKey: "liveUsers") as? String
        let defaultID = "\(Defaults[PDUserDefaults.UserID])"
        if user_id ?? ""  == defaultID {
            Database.database().reference().child("LiveUsers").child("\(user_id ?? "")").removeValue()
        } else {
            Database.database().reference().child("LiveUsers").child("\(defaultID )").removeValue()
        }
    }
    
    @objc func displayMyAlertMessage(){
        let dialogMessage = UIAlertController(title: "Your Free Trial Expired ", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Renew", style: .default, handler: { (action) -> Void in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SelectPlaneVC") as! SelectPlaneVC
            self.navigationController?.pushViewController(vc, animated: false)
            NavigationBool = true
        })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func currentdate(){
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy h:mm "
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        let time = todaysDate.timeIntervalSince1970
        let int = Int(time)
        let ndate = int * 1000
        self.currenttime = Int(ndate)
        let tomorrow = Calendar.current.date(byAdding: .year, value: 2, to: todaysDate as Date)
        let nextTimeDate = dateFormatter.string(from: tomorrow! )
        self.nextdate = nextTimeDate
        guard let timeInterval = tomorrow?.timeIntervalSince1970 else { return }
        let myInt = Int(timeInterval)
        let nitDate = myInt * 1000
        if bool == false {
            if UserDefaults.standard.bool(forKey: "isfirsttime") == false {
                UserDefaults.standard.set(nitDate, forKey: "NextTime")
                bool = true
                UserDefaults.standard.set(bool, forKey: "isfirsttime")
            }else {
                print("nothing happenned")
            }
        }
        
        let After7time =  UserDefaults.standard.integer(forKey: "NextTime")
        let PaymentSuccessed = UserDefaults.standard.bool(forKey: "Payment")
        if (After7time != 0 && PaymentSuccessed == false) == true{
            if (Int(currenttime) > After7time) == true{
                threedays = true
                UserDefaults.standard.set(threedays, forKey: "threedays")
                cureent = false
                payment =  false
                UserDefaults.standard.set(cureent, forKey: "current")
                UserDefaults.standard.set(payment, forKey: "Payment")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.viewAnimated.startAnimation(setThemeColor: true)
        currentdate()
        getCurrentLocation()
        deleteUser()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ChatAtLawyerNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.ShowChatNotificationScreen(notification:)), name: NSNotification.Name("ChatAtLawyerNotification"), object: nil)
        self.tabBarController?.tabBar.unselectedItemTintColor = .black
        self.tabBarController?.tabBar.tintColor = .black
        let expire =  UserDefaults.standard.string(forKey: "ExpireDate")
    }
    
    @objc func ShowChatNotificationScreen(notification: NSNotification){
        print("ReceiveCallhome")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReceiveCallVC" ) as! ReceiveCallVC
        vc.dicUserData = (notification.object! as? NSDictionary)!
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func ActionDiscoverySetting(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionElevate(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ScreenBoostVC" ) as! ScreenBoostVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func OnClickReset(_ sender: Any) {
        Defaults[PDUserDefaults.ResetFilter] = ""
        Defaults[PDUserDefaults.Distance] = ""
        Defaults[PDUserDefaults.Gender] = ""
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
        userNearByMeServices()
    }
    
    //MARK: ------Action Methods------------
    @IBAction func actionThreeDotViewCancel(_ sender: Any) {
        viewThreeDots.isHidden = true
        // self.viewThreeDots.superview?.removeFromSuperview()
    }
    
    @IBAction func ActionFilter(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionBlockUser(_ sender: UIButton) {
        self.BlockUserServices(senderID: "\(Defaults[PDUserDefaults.UserID])", receiverId: "\(ReceiverID)", btnTag: "\(sender.tag)")
    }
    
    @IBAction func ActionReportUser(_ sender: UIButton) {
        lblReportTitle.text = "Report User?"
        lblReportUser.text = "I'm no longer matched with"
        self.viewThreeDots.isHidden = true
        self.viewReportUser.isHidden = false
    }
    
    @IBAction func ActionCancelReport(_ sender: UIButton) {
        self.viewReportUser.isHidden = true
    }
    
    @IBAction func ActionReport(_ sender: UIButton) {
        ReportServices()
    }
    
    @IBAction func ActionCheck(_ sender: UIButton) {
        if sender.tag == 0 {
            sender.tag = 1
            btnReport.isEnabled = true
            self.ImgTik.image = #imageLiteral(resourceName: "deselect")
        }else{
            sender.tag = 0
            self.ImgTik.image = #imageLiteral(resourceName: "untick")
            btnReport.isEnabled = false
        }
    }
    
    // MARK: - Actions
    @objc func reloadButtonAction() {
        self.loadCardsFromXib = false
        self.colorIndex = 0
        self.swipeableView.discardViews()
        self.swipeableView.loadViews()
    }
    
    @objc func leftButtonAction() {
        self.swipeableView.swipeTopView(inDirection: .Left)
    }
    
    @objc func upButtonAction() {
        self.swipeableView.swipeTopView(inDirection: .Up)
    }
    
    @objc func rightButtonAction() {
        self.swipeableView.swipeTopView(inDirection: .Right)
    }
    
    @objc func downButtonAction() {
        self.swipeableView.swipeTopView(inDirection: .Down)
    }
    
    func nextCardView() -> UIView? {
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = .clear
        if colorIndex >= self.arrDicNearbyUser.count {
            //colorIndex = 0
        }else{
            colorIndex += 1
        }
        print(colorIndex,"colorIndex2")
        let index = colorIndex - 1
        print(index, "index")
        let images = #imageLiteral(resourceName: "avatar")
        let imageView = UIImageView(image: images)
        let dicNearbyUser = self.arrDicNearbyUser[index]
        let strUserImg = dicNearbyUser.image1!
        if strUserImg != "0" && strUserImg != "" {
            var image = dicNearbyUser.image1!
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named:"AppIcon"))
        } else {
            imageView.image = #imageLiteral(resourceName: "avatar")
        }
        
        imageView.frame = CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height - 40 )
        imageView.layer.cornerRadius = 10.0;
        imageView.clipsToBounds = true
        cardView.addSubview(imageView)
        //bgImageView
        let images1 = #imageLiteral(resourceName: "cardbg")
        let imageView1 = UIImageView(image: images1)
        imageView1.frame = CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height - 40)
        imageView1.layer.cornerRadius = 10.0;
        imageView1.clipsToBounds = true
        //get nameStatusView
        let nameStatusView = UIView(frame: CGRect(x: 0, y: imageView.frame.size.height - 70, width: cardView.frame.size.width, height: 70))
        nameStatusView.layer.cornerRadius = 10.0;
        imageView1.addSubview(nameStatusView)
        //get namelabel
        ReceiverID = dicNearbyUser.fbID!
        let strUserName = dicNearbyUser.firstName! + " " + dicNearbyUser.lastName!
        print("strUserName_is",strUserName)
        let namelabel = UILabel(frame: CGRect(x: 5, y: -5, width: nameStatusView.frame.size.width, height: 20))
        namelabel.text = "\(strUserName)"
        namelabel.textColor = .white
        namelabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        nameStatusView.addSubview(namelabel)
        ReceiverName = "\(strUserName)"
        //get statuslabel
        let strStatus = dicNearbyUser.distance ?? ""
        let statuslabel = UILabel(frame: CGRect(x: 5, y: 15, width: nameStatusView.frame.size.width, height: 20))
        statuslabel.text = "\(strStatus)"
        statuslabel.textColor = .white
        statuslabel.font = statuslabel.font.withSize(15)
        nameStatusView.addSubview(statuslabel)
        //MOREBUTTOn
        let MoreBtnView =  UIView(frame: CGRect(x: (cardView.frame.size.width / 2) + 120 , y: imageView.frame.size.height - 80, width: cardView.frame.size.width, height: 50))
        MoreBtnView.backgroundColor = UIColor.clear
        cardView.addSubview(MoreBtnView)
        let btnView2 = UIView()
        btnView2.layer.cornerRadius = 25
        btnView2.frame = CGRect(x: 0 , y: 0, width: 50, height: 50)
        MoreBtnView.addSubview(btnView2)
        let newBtnView = UIView(frame: CGRect(x: 0, y: imageView.frame.size.height - 45, width: cardView.frame.size.width, height: 70))
        newBtnView.backgroundColor = UIColor.clear
        cardView.addSubview(newBtnView)
        let btnView = UIView()
        btnView.layer.cornerRadius = 30
        btnView.backgroundColor = .clear
        btnView.frame = CGRect(x: (cardView.frame.size.width / 2) - 30   , y: 10, width: 60, height: 60)
        let myFirstButton = UIButton()
        if let image = UIImage(named: "homeHeart") {
            myFirstButton.setImage(image, for: .normal)
        }
        myFirstButton.tag = colorIndex
        myFirstButton.frame = CGRect(x: 0 , y: 0, width: 60, height: 60)
        myFirstButton.addTarget(self, action: #selector(btnlikepressed(_:)), for: .touchUpInside)
        btnView.addSubview(myFirstButton)
        newBtnView.addSubview(btnView)
        let btnView1 = UIView()
        btnView1.layer.cornerRadius = 27.5
        btnView1.backgroundColor = .clear
        btnView1.frame = CGRect(x: (cardView.frame.size.width / 2) - 110 , y: 10, width: 55, height: 55)
        let mySecondButton = UIButton()
        if let image = UIImage(named: "homeClose") {
            mySecondButton.setImage(image, for: .normal)
        }
        mySecondButton.tag = colorIndex
        mySecondButton.frame = CGRect(x:0 , y: 0, width: 55, height: 55)
        mySecondButton.addTarget(self, action: #selector(btnDislikepressed(_:)), for: .touchUpInside)
        btnView1.addSubview(mySecondButton)
        newBtnView.addSubview(btnView1)
        let MAYBEBtnView = UIView(frame: CGRect(x: 5, y: 5 , width: cardView.frame.size.width, height: 60))
        MAYBEBtnView.backgroundColor = UIColor.clear
        cardView.addSubview(MAYBEBtnView)
        let btnView3 = UIView()
        btnView3.layer.cornerRadius = 27.5
        btnView3.backgroundColor = .clear
        btnView3.frame = CGRect(x: (cardView.frame.size.width / 2) + 55 , y: 10, width: 55, height: 55)
        let maybeButton = UIButton()
        if let image = UIImage(named: "homeMaybe") {
            maybeButton.setImage(image, for: .normal)
        }
        maybeButton.tag = colorIndex
        maybeButton.frame = CGRect(x:0 , y: 0, width: 55, height: 55)
        maybeButton.addTarget(self, action: #selector(btnMaybepressed(_:)), for: .touchUpInside)
        btnView3.addSubview(maybeButton)
        newBtnView.addSubview(btnView3)
        Utils.Addshadow(mySecondButton)
        Utils.Addshadow(myFirstButton)
        Utils.Addshadow(maybeButton)
        mySecondButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        myFirstButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 10, bottom: 10, right: 10)
        maybeButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        if loadCardsFromXib {
            let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! UIView
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.backgroundColor = cardView.backgroundColor
            cardView.addSubview(contentView)
            cardView.backgroundColor = UIColor.clear
            constrain(contentView, cardView) { view1, view2 in
                view1.left == view2.left
                view1.top == view2.top
                view1.width == cardView.bounds.width
                view1.height == cardView.bounds.height
            }
        }
        return cardView
    }
    @objc func btnInfopressed(_ sender: UIButton) {
        print("btnInfopressed")
    }
    @objc func btnMorepressed(_ sender: UIButton) {
        print("more btn 1")
        viewThreeDots.isHidden = false}
    @objc func btnlikepressed(_ sender: UIButton) {
        self.rightButtonAction()
    }
    @objc func btnMaybepressed(_ sender: UIButton) {
        self.rightButtonAction()
    }
    @objc func btnDislikepressed(_ sender: UIButton) {
        self.leftButtonAction()
    }
}

// MARK: extension for like / dislike function
extension HomeVC {
    func infoTapSwipe(Index: Int){
        print("infoTapSwipe",Index)
        if self.arrDicNearbyUser.count != 0 {
            let dictuser = self.arrDicNearbyUser[Index]
            print("dictuser",dictuser)
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "NotificationUserDetailVC") as! NotificationUserDetailVC
            popoverContent.modalPresentationStyle = .popover
            popoverContent.dicGetUserNotifications = dictuser
            self.present(popoverContent, animated: true, completion: nil)
        }
    }
    func likeRightSwipe(Index: Int){
        print("like right swipe UserID",Index)
        if self.arrDicNearbyUser.count != 0 {
            let userDic = self.arrDicNearbyUser[Index]
            let UserId =  userDic.fbID!
            let UserName = userDic.firstName!
            print("Selected userName_selected",UserName)
            self.firebaseMatchEntry(UserID: "\(UserId)", UserName: "\(UserName)", UserType: "like")
            self.detailGetFirebase(UserID: "\(UserId)", UserType: "like")
        }
    }
    
    func dislikeLeftSwipe(Index: Int){
        print("dislike Left swipe UserID",Index)
        if self.arrDicNearbyUser.count != 0 {
            let userDic = self.arrDicNearbyUser[Index]
            let UserId =  userDic.fbID!
            let UserName = userDic.firstName!
            print("Selected userName_selected",UserName)
            self.firebaseMatchEntry(UserID: "\(UserId)", UserName: "\(UserName)", UserType: "dislike")
            self.detailGetFirebase(UserID: "\(UserId)", UserType: "dislike")
        }
    }
}

//MARK: extension for user like dislike methdo_first
extension HomeVC{
    func firebaseMatchEntry(UserID: String, UserName: String, UserType: String){
        let self_fb_id = Defaults[PDUserDefaults.UserID]
        var self_name = ""
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                let decoder = JSONDecoder()
                let userSaveData = try decoder.decode(Msg.self, from: data)
                self_name = "\(userSaveData.firstName!)"  //for first name
                print("self_name",self_name)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        let ref = Database.database().reference()
        let values1 = ["effect" : "true",
                       "match":"false",
                       "name":"\(UserName)",
                       "status":"0",
                       "time":"2",
                       "type":"\(UserType)",]
        ref.child("Match").child("\(self_fb_id)").child("\(UserID)").setValue(values1)
        
        let values2 = ["effect" : "false",
                       "match":"false",
                       "name":"\(self_name)",
                       "status":"0",
                       "time":"2",
                       "type":"\(UserType)",]
        
        ref.child("Match").child("\(UserID)").child("\(self_fb_id)").setValue(values2)
        
    }
    func BlockUserServices(senderID: String, receiverId: String, btnTag: String){
        let ref = Database.database().reference()
        let childUpdates = ref.child("Inbox").child("\(senderID)").child("\(receiverId)")
        let values = ["block" : "\(btnTag)"]
        childUpdates.updateChildValues(values) { (err, reference) in
            if err == nil {
                self.viewThreeDots.isHidden = true
            }
        }
    }
    func ReportServices() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.ReportURL()
        let parameters: [String: Any] = ["user_fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "report_fb_id" : "\(self.ReceiverID)",
                                         "message" : "reported"]
        print("Url_SignUpServices_is_here:-" , url)
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                if responseJson["code"] == "200" {
                    self.view.makeToast("\(responseJson["msg"])")
                    self.viewReportUser.isHidden = true
                } else {
                    print("Something went wrong in json")
                }
            }
        }
    }
}

//MARK: extension for user like dislike methdo_second
extension HomeVC {
    
    func detailGetFirebase(UserID: String, UserType: String){
        let ref = Database.database().reference()
        ref.child("Users").child("\(UserID)").child("token").observeSingleEvent(of: .value, with: { snapshot in
            let firebaseTokenValue = snapshot.value as? String
            
            if firebaseTokenValue != nil{
                self.sendPushNotification(UserID: "\(UserID)", UserType: "\(UserType)", UserFireBaseToken: "\(firebaseTokenValue!)")
            }
        }) { error in
            print(error.localizedDescription)
        }
    }
    
    //call API Push notification here
    func sendPushNotification(UserID: String, UserType: String, UserFireBaseToken: String){
        let url = AppUrl.sendPushNotificationURL()
        var strSendPushUserImg1 = ""
        var strSendPushUserFirstName = ""
        var strSendPushMessage = ""
        var strSendPushActionType = ""
        
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                let decoder = JSONDecoder()
                let userSaveData = try decoder.decode(Msg.self, from: data)
                strSendPushUserImg1 = "\(userSaveData.image1!)"           //for images1
                print("uaer_Default_image1",strSendPushUserImg1)
                strSendPushUserFirstName = "\(userSaveData.firstName!)"  //for first name
                print("strUserFirstName",strSendPushUserFirstName)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        
        if UserType == "like" {
            strSendPushMessage = "Like you"
            strSendPushActionType = "like"
        } else if UserType == "dislike" {
            strSendPushMessage = "dislike you"
            strSendPushActionType = "dislike"
        }
        
        let parameters: [String: Any] = ["title" : "\(strSendPushUserFirstName)" ,
                                         "message" : "\(strSendPushMessage)",
                                         "icon" : "\(strSendPushUserImg1)" ,
                                         "tokon" : "\(UserFireBaseToken)" ,
                                         "senderid" : "\(Defaults[PDUserDefaults.UserID]) " ,
                                         "receiverid" : "\(UserID)" ,
                                         "action_type" : "\(strSendPushActionType)" ]
        
        print("Url_sendPushNotification_is_here:-" , url)
        print("Param_sendPushNotification_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default).responseJSON { (response) in
            print("Response",response)
            if response.data != nil {
                self.updateFromFirbaseServices()
                let responseJson = JSON(response.value!)
                print("Code_is_sendPushNotification",responseJson["success"])
                if responseJson["success"] == 1 {
                    if let responseData = response.data {
                        do {
                            
                            print("API Run Push Notification successfully")
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetSendPushNotificationModel.self, from: responseData)
                            
                            if dicData.success == 1 {
                                print("Push Notification success_true = ", dicData.success!)
                            } else {
                                print("Push Notification success_false = ", dicData.success!)
                            }
                            
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                } else if responseJson["success"] == 0 {
                    print("Something went wrong error code 201")
                } else {
                    print("Something went wrong in json")
                }
            }
        }
    }
    
    //call API Update From Firebase
    func updateFromFirbaseServices(){
        let url = AppUrl.updateFromFirebaseURL()
        let parameters: [String: Any] = ["" : ""]
        
        print("Param_updateFromFirbaseServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            print("Response",response)
            print("updateFromFirbaseServices_is_Done")
        }
    }
}

// MARK: get user default data
extension HomeVC {
    func userDefaultData() {
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                let decoder = JSONDecoder()
                let userSaveData = try decoder.decode(Msg.self, from: data)
                Defaults[PDUserDefaults.UserID] = "\(userSaveData.fbID!)"
                print("uaerID_Default_is",userSaveData.fbID! as Any)
                let strUserFirstName = "\(userSaveData.firstName!)"
                let strUserLastName = "\(userSaveData.lastName!)"
                
                Defaults[PDUserDefaults.userName] = strUserFirstName + " " + strUserLastName
                let img = "\(userSaveData.image1!)"
                if img != "" && img != nil {
                    var image = "\(userSaveData.image1!)"
                    print("image_user_not_Nil :-\(image)")
                    image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
                    Defaults[PDUserDefaults.profileImg] = "\(image)"
                    if imgUserRadioWave != nil {
                        self.imgUserRadioWave.sd_setImage(with: URL(string: image), placeholderImage: nil)
                    }
                    
                } else {
                    print("image_user_Nil")
                    self.imgUserRadioWave.image = #imageLiteral(resourceName: "ic_avatar")
                }
                
                if Defaults[PDUserDefaults.UserID] != nil || Defaults[PDUserDefaults.UserID] != "" {
                    self.userNearByMeServices()
                }
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
}

// MARK: call API for userNearByMeServices
extension HomeVC {
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func userNearByMeServices() {
        if Defaults[PDUserDefaults.ResetFilter] == "" {
            btnReset.isHidden =  true
        } else {
            btnReset.isHidden =  false
        }
        if Defaults[PDUserDefaults.AgeMin] == "" {
            Defaults[PDUserDefaults.AgeMin] = "18"
        }
        if Defaults[PDUserDefaults.AgeMax] == "" {
            Defaults[PDUserDefaults.AgeMax] = "65"
        }
        if Defaults[PDUserDefaults.Gender] == "" {
            Defaults[PDUserDefaults.Gender] = "all"
        }
        if Defaults[PDUserDefaults.Distance] == "" {
            Defaults[PDUserDefaults.Distance] = "10000"
        }
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.userNearByMeURL()
        
        let parameters: [String: String] =
        ["fb_id" : "\(Defaults[PDUserDefaults.UserID])" ,
         "lat_long" : "\(Defaults[PDUserDefaults.UserLat]), \(Defaults[PDUserDefaults.UserLng])",
         "gender" :  Defaults[PDUserDefaults.Gender] ?? "all",
         "distance" : "\(Defaults[PDUserDefaults.Distance] ?? "10000" )" ,
         "device_token" : "\(Defaults[PDUserDefaults.FCMToken]) " ,
         "device" : "ios" ,
         "age_min" : "\(Defaults[PDUserDefaults.AgeMin])",
         "age_max" : "\(Defaults[PDUserDefaults.AgeMax])"  ,
         "version" : "1.0" ,
         "purchased" : "1" ,
         "height" : "\(Defaults[PDUserDefaults.Height])",
         "weight" : "\(Defaults[PDUserDefaults.Weight])" ,
         "blood_group" : "\(Defaults[PDUserDefaults.BloodGroup])" ,
         "skin_type" : "\(Defaults[PDUserDefaults.SkinType])" ,
         "language" : "\(Defaults[PDUserDefaults.Language])" ,
         "profession" : Defaults[PDUserDefaults.Profession] ,
         "religion" : "\(Defaults[PDUserDefaults.Religion])" ,
         "education" : "\(Defaults[PDUserDefaults.Education])" ,
         "body_type" : "\(Defaults[PDUserDefaults.BodyType])" ,
         "hair_color" : "\(Defaults[PDUserDefaults.HairColor])" ,
         "eye_color" : "\(Defaults[PDUserDefaults.EyeColor])"
        ]
        print("Url_userNearByMeServices_is_here:-" , url)
        print("Param_userNearByMeServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_userNearByMeServices",responseJson)
                
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(userNearByMeData.self, from: responseData)
                            self.arrDicNearbyUser = dicData.msg!
                            print("dic_NearbyUser_Data",self.arrDicNearbyUser)
                            
                            //dont remove this
                            if self.arrDicNearbyUser.count >= 1{
                                self.numberView = 0
                            }
                            print("self_numberView",self.numberView)
                            
                            if self.arrDicNearbyUser.count >= 1{
                                for i in 0...self.arrDicNearbyUser.count-1{
                                    let dicNearbyUser = self.arrDicNearbyUser[i]
                                    let strUserName = dicNearbyUser.firstName!
                                    let strUserNumber = dicNearbyUser.fbID!
                                    print("position_is ",i ," User_name_is ",strUserName,"UserNumber ",strUserNumber)
                                }
                                self.viewCard.superview?.bringSubviewToFront(self.viewCard)
                            } else if self.arrDicNearbyUser.count < 1 {
                                self.viewUserRadioWave.superview?.bringSubviewToFront(self.viewUserRadioWave)
                            }
                            
                            self.reloadButtonAction()
                            self.viewDidLayoutSubviewsa()
                        } catch {
                            print("Something went wrong in json.")
                        }
                    }
                } else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                } else {
                    print("Something went wrong in json")
                }
            }
        }
    }
    func deleteUser(){
        
        let url = AppUrl.is_user_existURL()
        
        let parameters: [String: String] =
        ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
         "device" : "ios"]
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code is",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                print("user exist")
                }else if responseJson["code"] == "201" {
                    
                    self.signOut()
//
                }else{
                    print("Something went wrong")
                }
            }
            
        }
    }
    func signOut(){
        
        let temStrFCM = "\(Defaults[PDUserDefaults.FCMToken])"
        Utils.RemovePersistentData() // to remove all default data in application
        Defaults[PDUserDefaults.FCMToken] = temStrFCM
        
        let VC = self.storyboard!.instantiateViewController(withIdentifier: "SpleshVC") as! SpleshVC
        self.navigationController!.pushViewController(VC, animated: true)
    }
}

extension HomeVC {
    func updateFCMToken() {
        let ref = Database.database().reference()
        ref.child("Users/\(Defaults[PDUserDefaults.UserID])/token").setValue(Defaults[PDUserDefaults.FCMToken])
    }
}

//Extension for get user info
extension HomeVC {
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
                            if (dicData.msg?.count)! > 0 {
                                let objProfileRes = (dicData.msg!.first)!
                                Defaults[PDUserDefaults.UserID] = "\(objProfileRes.fbID!)"
                                print("Defaults_PDUser_Defaults_UserID",objProfileRes.fbID!)
                                do {
                                    let encoder = JSONEncoder()
                                    let data = try encoder.encode(objProfileRes)
                                    UserDefaults.standard.set(data, forKey: "encodeUserData")
                                    self.userDefaultData()
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
    
    // for current Lat long
    func getCurrentLocation(){
        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        let PaymentSuccessed = UserDefaults.standard.bool(forKey: "Payment")
        let currentLogin = UserDefaults.standard.bool(forKey: "current")
        let ThreeDays = UserDefaults.standard.bool(forKey: "threedays")
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
                if PaymentSuccessed == true{
                    self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
                }
                if ThreeDays == true{
                    
                    displayMyAlertMessage()
                }
                if currentLogin == true{
                    self.getUserInfoService(phone: "\(Defaults[PDUserDefaults.UserID])")
                }
                
            } else {
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                self.view.makeToast("Enable Location Access")
            }
            
        }
    }
}
