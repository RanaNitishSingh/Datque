//
//  NewHomeVC.swift
//  SocialApp
//
//  Created by mac on 27/12/21.
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

class NewHomeVC: UIViewController {
    
    var swipeableView: ZLSwipeableView!
    //@IBOutlet weak var swipeableView: ZLSwipeableView!
    
    var arrDicNearbyUser = [MsguserNearByMe]() //this is array of dictionary type MsguserNearByMe
    var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    var colorIndex = 0
    var loadCardsFromXib = false
    
    var reloadBarButtonItem: UIBarButtonItem!
    // var reloadBarButtonItem = UIBarButtonItem(barButtonSystemItem: "Reload", target: .Plain) { item in }
    var leftBarButtonItem: UIBarButtonItem!
    // var leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: "←", target: .Plain) { item in }
    var upBarButtonItem: UIBarButtonItem!
    // var upBarButtonItem = UIBarButtonItem(barButtonSystemItem: "↑", target: .Plain) { item in }
    var rightBarButtonItem: UIBarButtonItem!
    // var rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: "→", target: .Plain) { item in }
    var downBarButtonItem:UIBarButtonItem!
    // var downBarButtonItem = UIBarButtonItem(barButtonSystemItem: "↓", target: .Plain) { item in }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        swipeableView.nextView = {
            return self.nextCardView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get user delault id and call get nearby user services
        self.userDefaultData()
        
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
        view.addSubview(swipeableView)
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        swipeableView.didTap = {view, location in
            print("Did tap at location \(location)")
        }
        swipeableView.didDisappear = { view in
            print("Did disappear swiping view")
        }

        constrain(swipeableView, view) { view1, view2 in
            view1.left == view2.left+50
            view1.right == view2.right-50
            view1.top == view2.top + 120
            view1.bottom == view2.bottom - 100
        }
        
        print("NewHomeVC")
        
    }
    
    @IBAction func ActionFilter(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    // MARK: - Actions
    
    @objc func reloadButtonAction() {
        let alertController = UIAlertController(title: nil, message: "Load Cards:", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        
        let ProgrammaticallyAction = UIAlertAction(title: "Programmatically", style: .default) { (action) in
            self.loadCardsFromXib = false
            self.colorIndex = 0
            self.swipeableView.discardViews()
            self.swipeableView.loadViews()
        }
        alertController.addAction(ProgrammaticallyAction)
        
        let XibAction = UIAlertAction(title: "From Xib", style: .default) { (action) in
            self.loadCardsFromXib = true
            self.colorIndex = 0
            self.swipeableView.discardViews()
            self.swipeableView.loadViews()
        }
        alertController.addAction(XibAction)
        
        self.present(alertController, animated: true, completion: nil)
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
    
    // MARK: ()
    func nextCardView() -> UIView? {
        if colorIndex >= colors.count {
            colorIndex = 0
        }

        let cardView = CardView(frame: swipeableView.bounds)
       // cardView.backgroundColor = colorForName(colors[colorIndex])
        cardView.backgroundColor = .white
        colorIndex += 1
        
        
        /*
        let dicNearbyUser = self.arrDicNearbyUser[index]
        let strUserImg = dicNearbyUser.image1!
        let UserImg = UIImageView()

        if strUserImg != "0" && strUserImg != "" {
            var image = dicNearbyUser.image1!
            print("image_user_not_Nil :-\(image)")
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            UserImg.sd_setImage(with: URL(string: image), placeholderImage: nil)
            
        }else {
            print("image_user_Nil")
            UserImg.image = #imageLiteral(resourceName: "avatar")
        }*/
        
        //Create a view here to show UIImage and button swipe
        //get Image
        let images = #imageLiteral(resourceName: "1639735778353")
        let imageView = UIImageView(image: images)
        imageView.frame = CGRect(x: 0, y: 0, width: cardView.frame.size.width, height: cardView.frame.size.height - 60 )
        imageView.layer.cornerRadius = 10.0;
        imageView.clipsToBounds = true
        cardView.addSubview(imageView)
        
        //get nameStatusView
        let nameStatusView = UIView(frame: CGRect(x: 0, y: imageView.frame.size.height - 40, width: cardView.frame.size.width, height: 40))
        nameStatusView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        nameStatusView.layer.cornerRadius = 10.0;
        imageView.addSubview(nameStatusView)
        
        //get namelabel
        let namelabel = UILabel(frame: CGRect(x: 5, y: 0, width: nameStatusView.frame.size.width, height: 20))
        namelabel.text = "I'm a test label"
        namelabel.textColor = .white
        namelabel.font = namelabel.font.withSize(15)
        nameStatusView.addSubview(namelabel)
        
        //get statuslabel
        let statuslabel = UILabel(frame: CGRect(x: 5, y: 20, width: nameStatusView.frame.size.width, height: 20))
        statuslabel.text = "Status"
        statuslabel.textColor = .white
        statuslabel.font = statuslabel.font.withSize(15)
        nameStatusView.addSubview(statuslabel)
        
        //get newBtnView
        let newBtnView = UIView(frame: CGRect(x: 0, y: imageView.frame.size.height, width: cardView.frame.size.width, height: 60))
        newBtnView.backgroundColor = UIColor.white
        cardView.addSubview(newBtnView)
        
//      get likeBtn on newBtnView
        let myFirstButton = UIButton()
        if let image = UIImage(named: "like-1") {
            myFirstButton.setImage(image, for: .normal)
        }
        myFirstButton.backgroundColor = .clear
        myFirstButton.layer.cornerRadius = 25
        myFirstButton.frame = CGRect(x: (cardView.frame.size.width / 2) + 20 , y: 10, width: 40, height: 40)
        myFirstButton.addTarget(self, action: #selector(btnlikepressed), for: .touchUpInside)
        newBtnView.addSubview(myFirstButton)
        
//      get DislikeBtn on newBtnView
        let mySecondButton = UIButton()
        if let image = UIImage(named: "close") {
            mySecondButton.setImage(image, for: .normal)
        }
        mySecondButton.backgroundColor = .clear
        mySecondButton.layer.cornerRadius = 25
        
//        mySecondButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        mySecondButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        mySecondButton.layer.shadowOpacity = 1.0
//        mySecondButton.layer.shadowRadius = 2.5
//        mySecondButton.layer.masksToBounds = false
//        mySecondButton.layer.cornerRadius = 25
        
        mySecondButton.frame = CGRect(x: (cardView.frame.size.width / 2) - 60 , y: 10, width: 40, height: 40)
        mySecondButton.addTarget(self, action: #selector(btnDislikepressed), for: .touchUpInside)
                newBtnView.addSubview(mySecondButton)
        

        if loadCardsFromXib {
            let contentView = Bundle.main.loadNibNamed("CardContentView", owner: self, options: nil)?.first! as! UIView
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.backgroundColor = cardView.backgroundColor
            cardView.addSubview(contentView)

            // This is important:
            // https://github.com/zhxnlai/ZLSwipeableView/issues/9
            /*// Alternative:
            let metrics = ["width":cardView.bounds.width, "height": cardView.bounds.height]
            let views = ["contentView": contentView, "cardView": cardView]
            cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(width)]", options: .AlignAllLeft, metrics: metrics, views: views))
            cardView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(height)]", options: .AlignAllLeft, metrics: metrics, views: views))
            */
            constrain(contentView, cardView) { view1, view2 in
                view1.left == view2.left
                view1.top == view2.top
                view1.width == cardView.bounds.width
                view1.height == cardView.bounds.height
            }
        }
        return cardView
    }
    
    @objc func btnlikepressed() {
        print("Presed like btn")
        self.rightButtonAction()
    }
    
    @objc func btnDislikepressed() {
        print("Presed Dislike btn")
        self.leftButtonAction()
    }

    func colorForName(_ name: String) -> UIColor {
        let sanitizedName = name.replacingOccurrences(of: " ", with: "")
        let selector = "flat\(sanitizedName)Color"
        return UIColor.perform(Selector(selector)).takeUnretainedValue() as! UIColor
    }

}

// MARK: get user default data
extension NewHomeVC{
    func userDefaultData() {
    // Read/Get Data/decode userDefault data *****
        if let data = UserDefaults.standard.data(forKey: "encodeUserData") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                // Decode Note
                let userSaveData = try decoder.decode(Msg.self, from: data)
                Defaults[PDUserDefaults.UserID] = "\(userSaveData.fbID!)"
                print("uaerID_Default_is",userSaveData.fbID! as Any)
                
                if Defaults[PDUserDefaults.UserID] != nil || Defaults[PDUserDefaults.UserID] != "" {
                    //call APi userNearByMe Services
                    self.userNearByMeServices()
                }

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
}

// MARK: call API for userNearByMeServices
extension NewHomeVC{ //this post raw API here for alamofire 5.5
    func userNearByMeServices() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        print("userNearByMeServices")
        
        let url = AppUrl.userNearByMeURL()
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])" ,
                                         "lat_long" : "\(Defaults[PDUserDefaults.UserLat]), \(Defaults[PDUserDefaults.UserLng])" as AnyObject,
                                         "gender" : "all" ,
                                         "distance" : "10000" ,
                                         "device_token" : "\(Defaults[PDUserDefaults.FCMToken] as AnyObject) " ,
                                         "device" : "ios" ,
                                         "age_min" : "18",
                                         "age_max" : "64"  ,
                                         "version" : "1.0" ,
                                         "purchased" : "0" ]
        
        print("Url_userNearByMeServices_is_here:-" , url)
        print("Param_userNearByMeServices_is_hereNewHomeVC:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_userNearByMeServices",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(userNearByMeData.self, from: responseData)
                            
                            //print("dicData_Count",dicData.msg!.count)
                            self.arrDicNearbyUser = dicData.msg!
                            print("arrDicNearbyUser_Count_-1")
//                            self.kolodaView.reloadData()
                           
                            
//                            if (dicData.msg?.count)! > 0 {
//                                let objProfileRes = (dicData.msg!.first)!
//                                let userid = objProfileRes.fbID
//                                //call api get User data
//                                self.getUserInfoService(phone: userid!)
//                            }
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
