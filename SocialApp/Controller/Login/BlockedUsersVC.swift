//
//  BlockedUsersVC.swift
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

class BlockedUsersVC: UIViewController {

    @IBOutlet weak var lblNoRecoedFound: UILabel!
    @IBOutlet weak var tblBlockedUser: UITableView!
    @IBOutlet weak var heightTblBlockdUser: NSLayoutConstraint!
    
    var arrChatDic  = [ChatUserInfo]() //this is array of dictionary type ChatUserInfo
    var arrBlockUserDic = [ChatUserInfo]() //this is array of dictionary type chatUserInfo
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show no recoed found
        self.lblNoRecoedFound.isHidden = false
        self.myInboxChat()
        // Do any additional setup after loading the view.
        print("BlockedUsersVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
}

//Extension for table view
extension BlockedUsersVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.heightTblBlockdUser.constant = CGFloat((self.arrBlockUserDic.count * 60 ) + 10 )
        
        if self.arrBlockUserDic.count >= 1 {
            //show no recoed found
            self.lblNoRecoedFound.isHidden = true
        }else{
            //show no recoed found
            self.lblNoRecoedFound.isHidden = false
        }
        
        return self.arrBlockUserDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblBlockedUser.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let userDic = self.arrBlockUserDic[indexPath.row]
        //for Name
        cell.lblNameTblBlockedUser.text = userDic.name!
        
        //for image
        let strUserImg1 = userDic.pic!
        if strUserImg1 != nil && strUserImg1 != "" {
            var image = userDic.pic!
            image = image.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgProfileTblBlockedUser.sd_setImage(with: URL(string: image), placeholderImage: nil)
        }else {
           // print("image_user_Nil")
            cell.imgProfileTblBlockedUser.image = #imageLiteral(resourceName: "ic_avatar")
        }
        
        //Add LongPress Gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(BlockedUsersVC.handleLongPress))
        cell.addGestureRecognizer(longPress)
        longPress.cancelsTouchesInView = true
        
        return cell
    }
    
    //Action of Long press gesture
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tblBlockedUser)
            if let indexPath = tblBlockedUser.indexPathForRow(at: touchPoint) {
                // your code here, get the row for the indexPath or do whatever you want
                print("Long press Pressed:)",indexPath.row)
                
                let blockUserDic = self.arrBlockUserDic[indexPath.row]
                let blockUserName = blockUserDic.name!
                let blockUserRid = blockUserDic.rid!
                
                //Create alert of selection
                let alert = UIAlertController(title: "UnBlock:- \(blockUserName)" , message: nil, preferredStyle: UIAlertController.Style.alert)
                 
                 let action1  = UIAlertAction(title: "Un Block", style: UIAlertAction.Style.default) { (action) in
                     self.UnblockServices(rid: "\(blockUserRid)")
                 }
                  let action2 = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                     self.dismiss(animated: true, completion: nil)
                  }
                 alert.addAction(action1)
                 alert.addAction(action2)
                 self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
}

//MARK: - Extenction for unnblock user firebase api call
extension BlockedUsersVC {
    func UnblockServices(rid: String){
       // print("UNBlock API call_is -here",rid)
        let ref = Database.database().reference()
        ref.keepSynced(true)
        let childUpdates = ref.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").child("\(rid)")
        childUpdates.keepSynced(true)
        let values = ["block" : "0"]
        childUpdates.updateChildValues(values) { (err, reference) in
            // handle errors or anything related to completion block
            print("Error_is_here",err)
            if err == nil{ //delete success fully
                //reload chat
                self.myInboxChat()
            }
            print("reference_is_here",reference)
        }

    }
}

// MARK: - Extenction For Inbox chat firbase
extension BlockedUsersVC{
    
    func myInboxChat(){
        let ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("Inbox").child("\(Defaults[PDUserDefaults.UserID])").queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value, with: { snapshot in
            ref.keepSynced(true)
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            print("dicValue_is",dicValue)
            // list all values
            self.arrChatDic = []
            if dicValue != nil{
                for (key, valueq) in dicValue! {
                    self.arrChatDic.append(ChatUserInfo(json: valueq as! [String : Any]))
                }
                self.self.arrBlockUserDic = []
                if self.arrChatDic.count != nil && self.arrChatDic.count >= 1 {
                    for i in 0...self.arrChatDic.count-1 {
                        let userDic = self.arrChatDic[i]
                        if userDic.block! == "1" {
                            self.arrBlockUserDic.append(userDic)
                        }
                    }
                }
            }
            //Reload Chat TableView
            self.tblBlockedUser.reloadData()
            //print("array_of_BlckedUser",self.arrBlockUserDic)
        }) { error in
          print(error.localizedDescription)
        }
    }
    
    
    
}
