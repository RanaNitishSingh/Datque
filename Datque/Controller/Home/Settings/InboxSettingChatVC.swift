//
//  InboxSettingChatVC.swift
//  SocialApp
//
//  Created by mac on 30/12/21.
//

import UIKit
import iOSDropDown
import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON

class InboxSettingChatVC: UIViewController {

    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet weak var heightTblViewSettingIndex: NSLayoutConstraint!
    @IBOutlet weak var tblViewSettingInbox: UITableView!
    
    var arrChatDic  = [ChatUserInfo]() //this is array of dictionary type ChatUserInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblNoRecordFound.isHidden = false
        self.myInboxChat()
        // Do any additional setup after loading the view.
        print("InboxSettingChatVC")
    }

    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

//extenction for tableView
extension InboxSettingChatVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.heightTblViewSettingIndex.constant = CGFloat((self.arrChatDic.count * 80 ) + 10)
        
        if self.arrChatDic.count >= 1 {
            self.lblNoRecordFound.isHidden = true
        }else{
            self.lblNoRecordFound.isHidden = false
        }
        
        return self.arrChatDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewSettingInbox.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let userDic = self.arrChatDic[indexPath.row]
        //for Name
        cell.lblNameTblViewSettingInbox.text = userDic.name!
        
        //for image
        let strUserImg1 = userDic.pic!
        if strUserImg1 != nil && strUserImg1 != "" {
            var image = userDic.pic!
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgTblViewSettingInbox.sd_setImage(with: URL(string: image), placeholderImage: nil)
        }else {
           // print("image_user_Nil")
            cell.imgTblViewSettingInbox.image = #imageLiteral(resourceName: "ic_avatar")
        }
        
        //msg red or not
        if userDic.status != nil && userDic.status == "0" {
            //for msg
            cell.lblMsgTblViewSettingInbox.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lblMsgTblViewSettingInbox.text = userDic.msg!
        } else {
            //for msg
            cell.lblMsgTblViewSettingInbox.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.lblMsgTblViewSettingInbox.text = userDic.msg!
        }
        
        //for likes
        if userDic.like == "0" { //for dislike
            cell.imgStarTblViewSettingInbox.image = #imageLiteral(resourceName: "star (1) 1")
        } else { //for like
            cell.imgStarTblViewSettingInbox.image = #imageLiteral(resourceName: "star (1) 2")
        }
        
        //for date
        print("Date_is",userDic.date!)
        let StrDate = userDic.date!
        if StrDate != "" {
        let conDate = Utils.stringTOdate(strDate: StrDate)
        print("conDate_is",conDate)
        cell.lblTimeTblViewSettingInbox.text = Utils.timeAgoSinceDate(date: conDate, numericDates: true)
        }
        
        //for like dislike button
        cell.btnLikeTblViewSettingInbox.tag = indexPath.row
        cell.btnLikeTblViewSettingInbox.addTarget(self, action: #selector(ActionLikeDislike(_:)), for: .touchUpInside)
        
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
                    self.myInboxChat()
                }
            }
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = indexPath.row
        let userDic = self.arrChatDic[selectedIndex]
      
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC" ) as! ChatVC
        VC.ReceiverID = userDic.rid!
        VC.ReceiverName = userDic.name!
        VC.ReceiverImg = userDic.pic!
        VC.match_api_run = "0" //for create new chat it will be 1 otherwise 0
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
}

//extension for
extension InboxSettingChatVC{
    
    func myInboxChat(){
        let ref = Database.database().reference()
        ref.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            print("dicValue_is",dicValue)
            // list all values
            self.arrChatDic = []
            if dicValue != nil{
                for (key, valueq) in dicValue! {
                    self.arrChatDic.append(ChatUserInfo(json: valueq as! [String : Any]))
                }
            }
            
            //Reload Chat TableView
            self.tblViewSettingInbox.reloadData()
        }) { error in
          print(error.localizedDescription)
        }
    }
    
}
