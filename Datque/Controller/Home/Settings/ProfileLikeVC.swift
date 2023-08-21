//
//  ProfileLikeVC.swift
//  SocialApp
//
//  Created by mac on 29/12/21.
//

import UIKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import Firebase
import FirebaseStorage
import SwiftyJSON

class ProfileLikeVC: UIViewController {

    @IBOutlet weak var lblSubscribeUS: UILabel!
    @IBOutlet weak var collectionViewLikes: UICollectionView!
    var arrDicProfileLikes = [MsgGetProfileLikesData]() //this is array of dictionary type MsgGetProfileLikesData
    var userID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscribeus label
        self.lblSubscribeUS.isHidden = false
        //Call API myLikiesService
        self.getProfilelikesService()
        // Do any additional setup after loading the view.
        print("ProfileLikeVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    

}

//MARK: - Extension for collection view
extension ProfileLikeVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.arrDicProfileLikes != nil && self.arrDicProfileLikes.count >= 1{
            self.lblSubscribeUS.isHidden = true
        }
        return self.arrDicProfileLikes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewLikes.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let dicUserData = self.arrDicProfileLikes[indexPath.row]
        
        let dicProfileInfo = dicUserData.profileInfo
        
        //for image
        let strUserImg = dicProfileInfo?.image1!
        if strUserImg != nil && strUserImg != "" {
            var image = dicProfileInfo?.image1
           // print("image_user_not_Nil :-\(image)")
            image = image!.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            cell.imgcollectionViewLikes.sd_setImage(with: URL(string: image!), placeholderImage: nil)
        }else {
           // print("image_user_Nil")
            cell.imgcollectionViewLikes.image = #imageLiteral(resourceName: "avatar")
        }
        
        //for name
        cell.lblcollectionViewLikes.text = "\(dicProfileInfo?.firstName!)"
        
        return cell
    }
    
    //did select row at index path
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectindex = indexPath.row
        let selectUserData = self.arrDicProfileLikes[selectindex]
        let dicProfileInfo = selectUserData.profileInfo
        let selectUserId = dicProfileInfo?.fbID!
        print("selectUserId_is_here",selectUserId)
        //instanciate to next screen LikeYourProfileVC
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "LikeYourProfileVC" ) as! LikeYourProfileVC
        VC.userID = selectUserId!
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARK: - extension foe api call MylikesURL
extension ProfileLikeVC{
    
    func getProfilelikesService() {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        
        let url = AppUrl.getProfilelikesURL()
        
        let parameters: [String: Any] = ["fb_id" : Defaults[PDUserDefaults.UserID],
                                         "status" : "like",
                                         "device" : "ios"]
        
        print("Url_getProfilelikesService_is_here:-" , url)
        print("Param_getProfilelikesService_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_getProfilelikesService",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                    if let responseData = response.data {
                        do {
                            let decodeJSON = JSONDecoder()
                            let dicData = try decodeJSON.decode(GetProfileLikesData.self, from: responseData)
                            //print("dicData = \(String(describing: dicData.msg?.first))")
                            if (dicData.msg?.count)! > 0 {
                                
                                self.arrDicProfileLikes = dicData.msg!
                                //collectionview reload
                                self.collectionViewLikes.reloadData()
                               
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

