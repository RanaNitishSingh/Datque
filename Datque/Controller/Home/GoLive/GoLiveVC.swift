//
//  GoLiveVC.swift
//  SocialApp
//
//  Created by mac on 10/6/22.
//

import UIKit
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON
import FirebaseDatabase


class GoLiveVC: UIViewController {
    
    @IBOutlet weak var CollectionViewLiveUser: UICollectionView!
    @IBOutlet weak var lblNoMatchYet: UILabel!
    var arrDicLiveUser = [LiveUserInfo]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WSliveuser()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        WSliveuser()
        self.tabBarController?.tabBar.unselectedItemTintColor = .black
        self.tabBarController?.tabBar.tintColor = .black
    }
    
    //MARK: ------Action Methods------------
    @IBAction func OnClickGolive(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController" ) as! MainViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
// MARK: - Extenction For collectionView
extension GoLiveVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrDicLiveUser.count >= 1 {
            self.lblNoMatchYet.isHidden = true
        }else{
            self.lblNoMatchYet.isHidden = false
            self.lblNoMatchYet.text = "No other user is live at that time.\n click on \'Go Live\' for live video streaming."
        }
        
        return self.arrDicLiveUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.CollectionViewLiveUser.dequeueReusableCell(withReuseIdentifier: "CellLive", for: indexPath) as! CellLive
        let liveUser = self.arrDicLiveUser[indexPath.row]
        print("rtc_token",self.arrDicLiveUser[indexPath.row].rtc_token!)
        //For image
        let strUserImg = liveUser.user_picture!
        if strUserImg != "0" && strUserImg != "" {
            cell.imguser.sd_setImage(with: URL(string: strUserImg), placeholderImage: nil)
        }else {
            cell.imguser.image = #imageLiteral(resourceName: "ic_avatar")
        }
        
        cell.lblName.text = liveUser.user_name!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController" ) as! MainViewController
        VC.strComesFrom = "audience"
        VC.audi_Pic = self.arrDicLiveUser[indexPath.row].user_picture!
        VC.audi_name = self.arrDicLiveUser[indexPath.row].user_name!
        VC.audi_Id = self.arrDicLiveUser[indexPath.row].user_id!
        VC.rtc_token = self.arrDicLiveUser[indexPath.row].rtc_token!
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: CollectionViewLiveUser.frame.width/2, height: 200)
    }
}

//extension for
extension GoLiveVC{
    
    func WSliveuser(){
        let ref = Database.database().reference()
        ref.child("LiveUsers").queryOrdered(byChild: "timestamp").observe(.value, with:{ snapshot in
            // Get user value
            let dicValue = snapshot.value as? NSDictionary
            print("dicValue_is",dicValue)
            // list all values
            self.arrDicLiveUser = []
            if dicValue != nil{
                for (key, valueq) in dicValue! {
                    self.arrDicLiveUser.append(LiveUserInfo(json: valueq as! [String : Any]))
                }
            }
            print(self.arrDicLiveUser)
            self.CollectionViewLiveUser.reloadData()
        }) { error in
            print(error.localizedDescription)
        }
    }
    
}
//MARK: UICollectionViewCell
import UIKit
class CellLive: UICollectionViewCell {
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imguser: UIImageView!
}
