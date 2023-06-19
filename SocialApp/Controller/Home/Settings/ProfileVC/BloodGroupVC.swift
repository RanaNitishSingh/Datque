//
//  BloodGroupVC.swift
//  SocialApp
//
//  Created by mac on 16/12/21.
//

import UIKit

protocol GoToBackDelegate {
    func Back(strSelectName : String, strScrentype : String)
}

class BloodGroupVC: UIViewController {
    
    @IBOutlet weak var lblHaderName: UILabel!
    
    var delegate: GoToBackDelegate? = nil
   
    var Screntype = ""
    @IBOutlet weak var tblViewBloodGroup: UITableView!
    
    var selectedItemCell = -1
    var SelectItemName = ""
    
    var arrMain = [""]
    var arr_list_living = ["No answer","By myself","Student residence","With parents","With partner","With housemate(s)"];
    var arr_list_relationship = ["No answer","im in a complicated relationship", "Single","Taken"];
    var arr_list_children = ["No answer","Grown up", "Already have","No never ", "Someday"];
    var arr_list_smoke = ["No answer","Im a heavy smoker","I hate smoking","i dont like it","im a social smoker","I smoke occasionally"];
    var arr_list_drink = ["No answer","I drink socially", "I dont drink","Im against drinking ", "I drink a lot"];
    var arr_list_sexuality = ["No answer","Bisexual", "Gay","Ask me ", "Straight"];
  
    let arrStatus = ["Available","Busy","Outside","Traveling"]
    let arrGender = ["Male","Female","Not wish to disclose"]
    let arrBloodGroup = ["A+","O+","B+","AB+","A-","O-","B-","AB-"]
    let arrSkinType = ["White","Fair","Brown","Dark Brown","Olive","Moderate Brown"]
    let arrLanguage = ["Hindi","English","French","Madarin Chinese","Spanish","Arabic","Portuguese","Bengali","Russian"]
    let arrProfession = ["Accountant","Actor","Actress","Air traffic controller","Architect","Artist","Attorney","Banker","Barber","Bookkeeper","Builder","Businessman","Businesswoman","Businessperson","Carpenter","Cashier","Chef","Coach","Dentist","Hygienist","Designer","Developer","Dietician","Doctor","Economist","Editor","Electrician","Engineer"]
    let arrReligion = ["Christianity","Islam","Irreligion","Hinduism","Buddhism","Folk religions","Sikhism","Judaism"]
    let arrEducation = ["Graduate","Post graduate","Philosopher","Doctorate"]
    
    
   // ["Living","Status","Children","Smoking","Drinking","Relationship","Appearance","male","DOB","Blood Group","Skin Type","Language","Profession","Religion","Education"]
    override func viewDidLoad() {
        super.viewDidLoad()
      
        if Screntype == "0" {
            self.arrMain = arr_list_living
            self.lblHaderName.text = "Status"
        }
        if Screntype == "1" {
            self.arrMain = arrStatus
            self.lblHaderName.text = "Status"
        }else if Screntype == "2" {
            self.arrMain = arr_list_children
            self.lblHaderName.text = "Children"
        }else if Screntype == "3" {
            self.arrMain = arr_list_smoke
            self.lblHaderName.text = "Smoking"
        }else if Screntype == "4" {
            self.arrMain = arr_list_drink
            self.lblHaderName.text = "Drinking"
        }else if Screntype == "5" {
            self.arrMain = arr_list_relationship
            self.lblHaderName.text = "Relationship"
        }
        else if Screntype == "7" {
            self.arrMain = arrGender
            self.lblHaderName.text = "Gender"
        }else if Screntype == "9" {
            self.arrMain = arrBloodGroup
            self.lblHaderName.text = "Blood Group"
        }else if Screntype == "10" {
            self.arrMain = arrSkinType
            self.lblHaderName.text = "Skin Type"
        }else if Screntype == "11" {
            self.arrMain = arrLanguage
            self.lblHaderName.text = "Language"
        }else if Screntype == "12" {
            self.arrMain = arrProfession
            self.lblHaderName.text = "Profession"
        }else if Screntype == "13" {
            self.arrMain = arrReligion
            self.lblHaderName.text = "Religion"
        }else if Screntype == "14" {
            self.arrMain = arrEducation
            self.lblHaderName.text = "Education"
        }else if Screntype == "15" {
            self.arrMain = arr_list_sexuality
            self.lblHaderName.text = "Sexuality"
        }
        
        self.tblViewBloodGroup.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.Screntype = ""
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        //print("ActionBack")
        self.delegate?.Back(strSelectName: "\(self.SelectItemName)", strScrentype: "\(self.Screntype)")
        self.navigationController!.popViewController(animated: true)
    }
    
}

extension BloodGroupVC: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewBloodGroup.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        if self.selectedItemCell != -1 {
            if self.selectedItemCell == indexPath.row{
                cell.imgTblViewBloodGroup.image = #imageLiteral(resourceName: "deselect")
            }else{
                cell.imgTblViewBloodGroup.image = #imageLiteral(resourceName: "dry-clean")
            }
        }else{
            cell.imgTblViewBloodGroup.image = #imageLiteral(resourceName: "dry-clean")
        }
        
        if self.SelectItemName != ""{
            if self.SelectItemName == self.arrMain[indexPath.row] {
                cell.imgTblViewBloodGroup.image = #imageLiteral(resourceName: "deselect")
            }else{
                cell.imgTblViewBloodGroup.image = #imageLiteral(resourceName: "dry-clean")
            }
        }else{
            cell.imgTblViewBloodGroup.image = #imageLiteral(resourceName: "dry-clean")
        }
        
        cell.lbltblViewBloodGroup.text = self.arrMain[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let didseleCell = indexPath.row
        self.selectedItemCell = didseleCell
        self.SelectItemName = arrMain[didseleCell]
        self.tblViewBloodGroup.reloadData()
    }
    
}

