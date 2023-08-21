//
//  LikesVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
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
import MobileCoreServices

/*if self.arrBlockUserDic.count >= 1 {
 //show no recoed found
 self.lblNoRecoedFound.isHidden = true
}else{
 //show no recoed found
 self.lblNoRecoedFound.isHidden = false
}*/
class LikesVC: UIViewController {
    
    @IBOutlet weak var txtSearchChat: UITextField!
    @IBOutlet weak var heightTblViewChat: NSLayoutConstraint!
    @IBOutlet weak var tblViewChat: UITableView!
    @IBOutlet weak var CollectionViewLiveUser: UICollectionView!
    @IBOutlet weak var NsHeightCollectionViewLiveUser: NSLayoutConstraint!
    @IBOutlet weak var stkAllType: UIStackView!
    @IBOutlet weak var DropDownFilter: DropDown!
    @IBOutlet weak var lblAll: UILabel!
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var btnVisit: UIButton!
    @IBOutlet weak var btndate: UIButton!
    @IBOutlet weak var btnFav: UIButton!

    var strConnection = ""
    var arrDicLiveUser = [MsgMyMatchData]() //this is array of dictionary type LiveUser
    
    var arrFilter = ["Online","All Connections","Visits","Date","Favorites"]
    
    var filter_Type = "All Connections"
    var ref1: DatabaseReference! //for real time check data base firebase
    var arrChatDic = [ChatUserInfo]() //this is array of dictionary type ChatUserInfo
    var arrMainShowDic = [ChatUserInfo]()
    var arrTempList = [ChatUserInfo]()
    
    @IBOutlet weak var lblNoMatchYet: UILabel!
    @IBOutlet weak var lblNoInboxYet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoMatchYet.isHidden = false
        self.lblNoInboxYet.isHidden = false
        
        self.myMatchServices()
        self.myInboxChat()
        self.myInboxChat1()
        self.dropDown()
        self.txtSearchChat.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        print("LikesVC")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.myMatchServices()
        self.myInboxChat()
        self.tabBarController?.tabBar.unselectedItemTintColor = .black
        self.tabBarController?.tabBar.tintColor = .black
    }
    
    
      @IBAction func listButtonAction(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BlockedUsersVC" ) as! BlockedUsersVC
        VC.isfromLikeVc = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func ActionFilter(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "filterVC" ) as! filterVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    @IBAction func OnClickAll(_ sender: UIButton){
        
        if sender.tag == 0{
            sender.tag = 1
            stkAllType.isHidden = false
        }else{
            sender.tag = 0
            stkAllType.isHidden = true
        }
    }
    @IBAction func OnclickSections(sender: UIButton) {
        if sender == btnOnline {
            strConnection = (sender.titleLabel?.text)!
           // btnOnline.setTitle("All Coneection", for: .normal)
         //   arrChatDic.sort($0.timestamp < $1.timestamp)
          //  tblViewChat.reloadData()
        } else if sender == btnVisit {
            strConnection = (sender.titleLabel?.text)!
            //btnVisit.setTitle("All Coneection", for: .normal)
           // arrChatDic.sort($0.timestamp < $1.timestamp)
           // tblViewChat.reloadData()
        } else if sender == btndate {
            strConnection = (sender.titleLabel?.text)!
            //btndate.setTitle("All Coneection", for: .normal)
           // arrChatDic.sort{$0.timestamp ?? "" < $1.timestamp ?? ""}
           // tblViewChat.reloadData()
        }
        else if sender == btnFav {
            strConnection = (sender.titleLabel?.text)!
           // btnFav.setTitle("All Coneection", for: .normal)
           // arrChatDic.sort{$0.date ?? "" > $1.date ?? ""}
          //  tblViewChat.reloadData()
        }else{}
        lblAll.text = strConnection
        stkAllType.isHidden = true
    }
}

// MARK: - Extenction For collectionView
extension LikesVC: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.NsHeightCollectionViewLiveUser.constant = CGFloat((self.arrDicLiveUser.count * 75) + 25)
        
        if self.arrDicLiveUser.count >= 1 {
         //show no recoed found
         self.lblNoMatchYet.isHidden = true
        }else{
         //show no recoed found
         self.lblNoMatchYet.isHidden = false
        }
        
        return self.arrDicLiveUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.CollectionViewLiveUser.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let liveUser = self.arrDicLiveUser[indexPath.row]
        let dicEffectProfileName = liveUser.effectProfileName
        
        //For image
        let strUserImg = dicEffectProfileName?.image1!
        if strUserImg != "0" && strUserImg != "" {
            var image = (dicEffectProfileName?.image1)!
            print("image_user_not_Nil :-\(image)")
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgCollectionViewLiveUser.sd_setImage(with: URL(string: image), placeholderImage: nil)
           // cell.imgCollectionViewLiveUser.image = #imageLiteral(resourceName: "profile")

        }else {
            print("image_user_Nil")
            cell.imgCollectionViewLiveUser.image = #imageLiteral(resourceName: "profile")
        }
        
        //for name
        let name = dicEffectProfileName?.firstName!
        cell.lblNameCollectionViewLiveUser.text = name!

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected_Collection_View",indexPath.row)
        let liveSelectUserData = self.arrDicLiveUser[indexPath.row]
        let dicEffectProfileName = liveSelectUserData.effectProfileName
        
//        let Rid = (liveSelectUserData.effectProfile!)
//        let Name = (dicEffectProfileName?.firstName)!
//        let image = (dicEffectProfileName?.image1)!
//        print("Rid:- \(Rid), Name:- \(Name), image:- \(image)")
        
        //Instanciate to chate screen
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        VC.ReceiverID = (liveSelectUserData.effectProfile!)
        VC.ReceiverName = (dicEffectProfileName?.firstName)!
        VC.ReceiverImg = (dicEffectProfileName?.image1)!
        VC.match_api_run = "1" //for create new chat it will be 1 otherwise 0
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
}

// MARK: - Extenction For tableView
extension LikesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  self.heightTblViewChat.constant = CGFloat((self.arrChatDic.count * 80) + 10)
        
        if self.arrChatDic.count >= 1 {
         //show no recoed found
         self.lblNoInboxYet.isHidden = true
        }else{
         //show no recoed found
         self.lblNoInboxYet.isHidden = false
        }
        
        return self.arrChatDic.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewChat.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let userDic = self.arrChatDic[indexPath.row]
        //for Name
        cell.lblNameTblViewChat.text = userDic.name!
        //for image
        let strUserImg1 = userDic.pic!
        if strUserImg1 != nil && strUserImg1 != "" {
            var image = userDic.pic!
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgTblViewChat.sd_setImage(with: URL(string: image), placeholderImage: nil)
        }else {
           // print("image_user_Nil")
            cell.imgTblViewChat.image = #imageLiteral(resourceName: "ic_avatar")
        }
        //msg red or not
        if userDic.status == nil || userDic.status == "0" {//for msg
            cell.lblMsgTblViewChat.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblMsgTblViewChat.font = UIFont.boldSystemFont(ofSize: 13.0)
            cell.lblMsgTblViewChat.text = userDic.msg!
        } else {//for msg
            cell.lblMsgTblViewChat.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.lblMsgTblViewChat.font = UIFont.systemFont(ofSize: 13.0)
            cell.lblMsgTblViewChat.text = userDic.msg!
        }
        //for likes
        if userDic.like == "0" {//for dislike
            cell.imgStarTblViewChat.image = #imageLiteral(resourceName: "star (1) 1")
        } else { //for like
            cell.imgStarTblViewChat.image = #imageLiteral(resourceName: "star (1) 2")
        }
        //for date
        //print("Date_is",userDic.date!)
        let StrDate = userDic.date!
        if StrDate != "" {
        let conDate = Utils.stringTOdate(strDate: userDic.date!)
       print("conDate_is_like",conDate)
        cell.lblTimeTblViewChat.text = Utils.timeAgoSinceDate(date: conDate, numericDates: true)
        }
        //for like dislike button
        cell.btnLikeTblViewChat.tag = indexPath.row
        cell.btnLikeTblViewChat.addTarget(self, action: #selector(ActionLikeDislike(_:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func ActionLikeDislike(_ sender: UIButton){
        print("btn_tag_is indexpath in arr of dic",sender.tag)
        
        let userDic = self.arrChatDic[sender.tag]
        let rid = userDic.rid!
        var likes = ""
        if userDic.like == "0" { //for dislike
            likes = "1"
        } else { //for like
            likes = "0"
        }
        
        let ref = Database.database().reference()
        let childUpdates = ref.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").child("\(rid)")
        
        let values = ["like" : "\(likes)"]
        childUpdates.updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            
            if err == nil {
                //reload chat
                self.myInboxChat1()
            }
            
        }
        
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let userDic = self.arrChatDic[selectedIndex]
        //instanciate to next screen
        print("userDic_is_here",userDic)
        
        //Instanciate to chate screen
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        VC.ReceiverID = userDic.rid!
        VC.ReceiverName = userDic.name!
        VC.ReceiverImg = userDic.pic!
        VC.match_api_run = "0" //for create new chat it will be 1 otherwise 0
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

//MARK: - Fatch real time data function run
extension LikesVC{
    func myInboxChat(){
        let ref1 = Database.database().reference()
        ref1.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").keepSynced(true)
        ref1.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").observe(.childChanged) { (snapshot) in
            
            print("Ayush_run_childChanged_observe")
            self.myInboxChat1()
            self.myMatchServices()
         }
        
        ref1.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").observe(.childAdded) { (snapshot) in
            
            print("Ayush_run_childChanged_Added")
            self.myInboxChat1()
            self.myMatchServices()
         }
    }
}

// MARK: - Extenction For Inbox chat firbase
extension LikesVC {
    
    func myInboxChat1() {
        let ref1 = Database.database().reference()
        
        ref1.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            print("dicValue_isChat",dicValue)
            // list all values
            self.arrChatDic = []
            self.arrMainShowDic = []
            if dicValue != nil{
                for (key, valueq) in dicValue! {
                    self.arrChatDic.append(ChatUserInfo(json: valueq as! [String : Any]))
                    self.arrMainShowDic.append(ChatUserInfo(json: valueq as! [String : Any]))
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
                    return dateA.compare(dateB) == .orderedDescending
                }
                return false
            }
           print("After Sort",self.arrChatDic)
            
            //short an array for filter
            self.arrMainShowDic = self.arrMainShowDic.sorted { (firstItem, secondItem) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

                if let dateAString = firstItem.timestamp,
                   let dateBString = secondItem.timestamp,
                    let dateA = dateFormatter.date(from: dateAString),
                    let dateB = dateFormatter.date(from: dateBString) {
                    return dateA.compare(dateB) == .orderedDescending
                }
                return false
            }
           //print("After Sort",self.arrMainShowDic)
           
            //Reload Chat TableView
            self.tblViewChat.reloadData()
        }) { error in
          print(error.localizedDescription)
        }
    }
        
}


// MARK: - Extenction For Drop Down
extension LikesVC {
    
    func dropDown() {
        // dropDownCareGiver list of array to display. Can be changed dynamically
        DropDownFilter.optionArray = arrFilter
        DropDownFilter.didSelect{(selectedText , index ,id) in
        print("selected Filter is..",selectedText)
            if selectedText == "Favorites" {
                self.arrChatDic.sort{$0.like ?? "" > $1.like ?? ""}
                self.tblViewChat.reloadData()
            }else if selectedText == "Date" {
                self.arrChatDic.sort{$0.timestamp ?? "" > $1.timestamp ?? ""}
                self.tblViewChat.reloadData()
            }else if selectedText == "All Connections" {
              //  self.arrChatDic.sort{$0.timestamp ?? "" < $1.timestamp ?? ""}
                self.tblViewChat.reloadData()
            }else if selectedText == "Online" {
                  self.arrChatDic.sort{$0.status ?? "" < $1.status ?? ""}
                  self.tblViewChat.reloadData()
            }else if selectedText == "Visits" {
                self.arrChatDic.sort{$0.status ?? "" > $1.status ?? ""}
                self.tblViewChat.reloadData()
            }
        }
    }
    
}

// MARK: - Extenction For myMatchServices
extension LikesVC {
    
    func myMatchServices() {
       // PKHUD.sharedHUD.contentView = PKHUDProgressView()
       // PKHUD.sharedHUD.show()
        
        let url = AppUrl.myMatchURL()
        
        let parameters: [String: Any] = ["fb_id" : Defaults[PDUserDefaults.UserID],
                                         "device" : "ios"] 
        
        print("Url_myMatchURL_is_here:-" , url)
        print("Param_myMatchURL_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
           // PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_myMatchURL",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(MyMatchData.self, from: responseData)
                            
                            
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                self.arrDicLiveUser = dicData.msg!
                                print("myMatchURL_arrDicLiveUser",self.arrDicLiveUser)
                                self.CollectionViewLiveUser.reloadData()
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

//MARK: - extension for chat search
extension LikesVC {
    
    @objc func textFieldDidChange(textField: UITextField) {
        print("Text changed")
        self.arrTempList = self.arrChatDic
        self.arrChatDic = []
        self.searchText()
    }
    
    func searchText() {
        
        if self.txtSearchChat.text!.count > 0 {
            let attributeValue = self.txtSearchChat.text!
            let arrNames:Array = self.arrTempList
            
            //print("SearchText arrNames = \(arrNames)")
            //this search for simpleArray search by name
            //let namePredicate = NSPredicate(format: "name contains[c] %@",attributeValue);
            //let filteredArray = arrNames.filter { namePredicate.evaluate(with: $0) };
            
            //this search for modelArray search by name
            let filteredArray:[ChatUserInfo] = arrNames.filter {
                ($0.name!.localizedCaseInsensitiveContains(attributeValue))
            }
            
            if filteredArray.count > 0 {
                self.arrChatDic = filteredArray
                self.heightTblViewChat.constant = CGFloat((self.arrChatDic.count * 80 ) + 10 )
                self.tblViewChat.reloadData()
            }else{
                self.arrChatDic = []
                self.heightTblViewChat.constant = CGFloat((self.arrChatDic.count * 80 ) + 10 )
                self.tblViewChat.reloadData()
            }
        }else{
            self.arrChatDic = self.arrMainShowDic
            self.heightTblViewChat.constant = CGFloat((self.arrChatDic.count * 80 ) + 10 )
            self.tblViewChat.reloadData()
        }
    }
    
}
