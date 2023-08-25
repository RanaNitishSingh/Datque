//
//  ProfileStepVC.swift
//  SocialApp
//
//  Created by mac on 23/6/22.
//

import UIKit
import PKHUD
import Alamofire
import SwiftyJSON

class ProfileStepVC: UIViewController {
    @IBOutlet weak var lblPCount: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var CVStpes: UICollectionView!
    var arrImg = [ #imageLiteral(resourceName: "ic_describe") , #imageLiteral(resourceName: "ic_describe2") , #imageLiteral(resourceName: "ic_house") , #imageLiteral(resourceName: "ic_kids") , #imageLiteral(resourceName: "ic_smoke") , #imageLiteral(resourceName: "ic_drink") ]
    var arrtitle = [ "How do you describe yourself.." , "How do you describe yourself..." ,"Who do you live with.." ,"Your thought on having kids.." ,"Your felling about smoking are.." ,"Your felling about booze.." , ]
    var indexRow = 1
    var arr_list_living = ["No answer","By myself","Student residence","With parents","With partner","With housemate(s)"];
    var arr_list_relationship = ["No answer"," im in a complicated relationship", "Single"," Taken "];
    var arr_list_children = ["No answer"," Grown up", "Already have"," No never ", "Someday"];
    var arr_list_smoke = ["No answer","Im a heavy smoker","I hate smoking","i dont like it","im a social smoker","I smoke occasionally"];
    var arr_list_drink = ["No answer"," I drink socially", "I dont drink"," Im against drinking ", "I drink a lot"];
    var arr_list_sexuality = ["No answer"," Bisexual", "Gay"," Ask me ", "Straight"];
    var lblPCountValue: Int = 0 {
           didSet {
               lblPCount.text = "\(lblPCountValue)/6"
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPCountValue = 1
        setCollectionView()
        if Defaults[PDUserDefaults.descYourself] != "" {
            arrImg.removeAll { $0 ==  #imageLiteral(resourceName: "ic_describe")  }
            arrtitle.removeAll { $0 == "How do you describe yourself.." }
        }
        if  Defaults[PDUserDefaults.relationship] != "" {
            arrImg.removeAll { $0 ==  #imageLiteral(resourceName: "ic_describe2")  }
            arrtitle.removeAll { $0 == "How do you describe yourself..." }
        }
        if  Defaults[PDUserDefaults.living] != "" {
            arrImg.removeAll { $0 == #imageLiteral(resourceName: "ic_house") }
            arrtitle.removeAll { $0 == "Who do you live with.." }
        }
        if  Defaults[PDUserDefaults.children] != "" {
            arrImg.removeAll { $0 == #imageLiteral(resourceName: "ic_kids")}
            arrtitle.removeAll { $0 == "Your thought on having kids.." }
        }
        if  Defaults[PDUserDefaults.smoking] != "" {
            arrImg.removeAll { $0 == #imageLiteral(resourceName: "ic_smoke") }
            arrtitle.removeAll { $0 == "Your felling about smoking are.." }
        }
        if  Defaults[PDUserDefaults.drinking] != "" {
            arrImg.removeAll { $0 == #imageLiteral(resourceName: "ic_drink")}
            arrtitle.removeAll { $0 == "Your felling about booze.." }
        }
        CVStpes.reloadData()
        print("arrImgsave",arrImg.count)
        print("arrtitlesave",arrtitle.count)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showTabledata(_:)), name: NSNotification.Name(rawValue: "Updateview"), object: nil)
    }
    @objc func showTabledata(_ notification: NSNotification) {
        let dict = notification.userInfo as? [String:Any]
        let SelectTag = dict!["SelectTag"] as! String
        print(SelectTag)
        if SelectTag == "drink"{
            editProfileUser()
            
        }else{
            let collectionBounds = self.CVStpes.bounds
            let contentOffset = CGFloat(floor(self.CVStpes.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
        }
        
    }
    @IBAction func OnclickBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnLeftArrowAction(_ sender: Any) {
        CVStpes.scrollToTop()
        let collectionBounds = self.CVStpes.bounds
        let contentOffset = CGFloat(floor(self.CVStpes.contentOffset.x - collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        
        if lblPCountValue == 1 {
            lblPCountValue = 1
        }else{
           lblPCountValue -= 1
        }
            
    }
    
    @IBAction func btnRightArrowAction(_ sender: Any) {
        let collectionBounds = self.CVStpes.bounds
        let contentOffset = CGFloat(floor(self.CVStpes.contentOffset.x + collectionBounds.size.width))
        self.moveCollectionToFrame(contentOffset: contentOffset)
        if lblPCountValue == 6 {
            lblPCountValue = 6
        }else{
           lblPCountValue += 1
        }
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.CVStpes.contentOffset.y ,width : self.CVStpes.frame.width,height : self.CVStpes.frame.height)
        self.CVStpes.scrollRectToVisible(frame, animated: true)
    }
    
}
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
//MARK: - Extension for collection view
extension ProfileStepVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setCollectionView(){
        let nibName = UINib(nibName: "CustomPassCell", bundle:nil)
        CVStpes.register(nibName, forCellWithReuseIdentifier: "cell")
        CVStpes.dataSource = self
        CVStpes.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.CVStpes.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomPassCell
        let index_row = indexPath.row
        btnNext.isHidden = false
        self.btnNext.isUserInteractionEnabled = true
        cell.tblItem.tag = indexPath.row
        cell.imgView.image = arrImg[index_row]
        cell.lblTitle.text = arrtitle[index_row]
        if cell.imgView.image ==  UIImage(named: "ic_describe"){
            cell.ViewSetText.isHidden = false
            cell.tblItem.isHidden = true
            cell.titleCardView.backgroundColor = UIColor(red: 141/255, green: 42/255, blue: 221/255, alpha: 1)
        }else if cell.imgView.image ==  UIImage(named: "ic_describe2"){
            cell.strFromType = "relationship"
            cell.ViewSetText.isHidden = true
            cell.tblItem.isHidden = false
            cell.arritem = arr_list_relationship
            cell.titleCardView.backgroundColor = UIColor(red: 141/255, green: 42/255, blue: 221/255, alpha: 1)
        }else if cell.imgView.image ==  UIImage(named: "ic_house"){
            cell.ViewSetText.isHidden = true
            cell.tblItem.isHidden = false
            cell.strFromType = "living"
            cell.arritem = arr_list_living
            cell.titleCardView.backgroundColor = UIColor(red: 141/255, green: 42/255, blue: 221/255, alpha: 1)
        }else if cell.imgView.image ==  UIImage(named: "ic_kids"){
            cell.ViewSetText.isHidden = true
            cell.tblItem.isHidden = false
            cell.strFromType = "children"
            cell.arritem = arr_list_children
            cell.titleCardView.backgroundColor = UIColor(red: 141/255, green: 42/255, blue: 221/255, alpha: 1)
        }else if cell.imgView.image ==  UIImage(named: "ic_smoke"){
            cell.ViewSetText.isHidden = true
            cell.tblItem.isHidden = false
            cell.strFromType = "smoke"
            cell.arritem = arr_list_smoke
            cell.titleCardView.backgroundColor = UIColor(red: 141/255, green: 42/255, blue: 221/255, alpha: 1)
        }else if cell.imgView.image ==  UIImage(named: "ic_drink"){
            cell.ViewSetText.isHidden = true
            cell.tblItem.isHidden = false
            cell.strFromType = "drink"
            cell.arritem = arr_list_drink
            cell.tblItem.reloadData()
            cell.titleCardView.backgroundColor = UIColor(red: 141/255, green: 42/255, blue: 221/255, alpha: 1)
            self.btnNext.isUserInteractionEnabled = false
        }
        
        cell.tblItem.reloadData()
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        print(CVStpes.frame.width)
        return CGSize(width: CVStpes.frame.width, height: CVStpes.frame.height)
    }
    
}
extension ProfileStepVC{
    func editProfileUser(){
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        let url = AppUrl.editProfileInfoURL()
        
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "birthday" : "" ,
                                         "about_me" : Defaults[PDUserDefaults.descYourself] ,
                                         "gender" : "",
                                         "status" : "",
                                         "height" : "" ,
                                         "weight" : "",
                                         "body_type" : "",
                                         "eye_color" :"",
                                         "hair_color" : "",
                                         "blood_group" : "",
                                         "skin_type" : "",
                                         "language" :"",
                                         "profession" : "",
                                         "religion" : "",
                                         "education" : "",
                                         "first_name" : "",
                                         "last_name" : "",
                                         "image1" : "",
                                         "image2" : "",
                                         "image3" : "",
                                         "image4" : "",
                                         "image5" : "",
                                         "job_title": "",
                                         "company": "",
                                         "school": "",
                                         "device" : "ios",
                                         "living" :  Defaults[PDUserDefaults.living],
                                         "children" :  Defaults[PDUserDefaults.children],
                                         "smoking" :  Defaults[PDUserDefaults.smoking],
                                         "drinking" : Defaults[PDUserDefaults.drinking],
                                         "relationship" : Defaults[PDUserDefaults.relationship] ,
                                         "sexuality": ""]
        
        
        print("Url_editUserInfoServices_is_here:-" , url)
        print("Param_editUserInfoServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            PKHUD.sharedHUD.hide()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_editUserInfoServices",responseJson["code"])
                
                if responseJson["code"] == "200" {
                    print("editUserInfoServices successfully")
                    self.navigationController?.popViewController(animated: true)
                    
                    
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code 201")
                }else{
                    print("Something went wrong in json")
                }
            }
        }
    }
    
}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
    }
    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}
