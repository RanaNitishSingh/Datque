//
//  ServiceTypeCollectionViewCell.swift
//  Ziofly
//
//  Created by Apple on 25/05/21.
//

import UIKit

class CustomPassCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtDescribe: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tblItem: UITableView!
    @IBOutlet weak var stkviewMsg: UIView!
    @IBOutlet weak var titleCardView: UIView!
    
    @IBOutlet weak var ViewSetText: UIView!
    var arritem = [String]()
    var strFromType = String()
    var selectedItemCell = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        setTableView()
        txtDescribe.delegate = self
        tblItem.delegate = self
        tblItem.dataSource = self
        tblItem.reloadData()
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtDescribe){
            let characterCountLimit = 250
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            lblCount.text =  "\(newLength)/"+"\(250)"
            if ((txtDescribe.text?.isEmpty) != nil) {
                Defaults[PDUserDefaults.descYourself] = txtDescribe.text!
                Defaults[PDUserDefaults.IndexRow] = 1
            }
            return newLength <= characterCountLimit
        }
        
        return true
    }
    //MARK:- ------Custom Methods------------
}
// MARK: - Extenction For tableView
extension CustomPassCell: UITableViewDelegate, UITableViewDataSource {
    func setTableView(){
        
        self.tblItem.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        tblItem.dataSource = self
        tblItem.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arritem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        cell.lblTypeName.text = arritem[indexPath.row]
        //cell.btnSelect.tag = indexPath.row
        //cell.btnSelect.addTarget(self, action: #selector(checkMarkButtonClicked(_:)), for: .touchUpInside)
        if self.selectedItemCell == indexPath.row{
            cell.imgSelect.image = #imageLiteral(resourceName: "deselect")
        }else{
            cell.imgSelect.image = #imageLiteral(resourceName: "dry-clean")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let didseleCell = indexPath.row
        self.selectedItemCell = didseleCell
        let select_item = arritem[indexPath.row]
        if strFromType == "relationship" {
            Defaults[PDUserDefaults.relationship] = select_item
            Defaults[PDUserDefaults.IndexRow] = 2
        }
        else if strFromType == "living" {
            Defaults[PDUserDefaults.living] = select_item
            Defaults[PDUserDefaults.IndexRow] = 3
        }
        else if strFromType == "children" {
            Defaults[PDUserDefaults.children] = select_item
            Defaults[PDUserDefaults.IndexRow] = 4
        }
        else if strFromType == "smoke" {
            Defaults[PDUserDefaults.smoking] = select_item
            Defaults[PDUserDefaults.IndexRow] = 5
        }
        else if strFromType == "drink" {
            Defaults[PDUserDefaults.drinking] = select_item
            Defaults[PDUserDefaults.IndexRow] = 6
        }else{}
        swithToNext()
        self.tblItem.reloadData()
    }
    func swithToNext(){
        if strFromType != "drink" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Updateview"), object: nil, userInfo: ["SelectTag": "fromview"])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Updateview"), object: nil, userInfo: ["SelectTag": "drink"])
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
