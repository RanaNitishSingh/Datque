//
//  filterVC.swift
//  SocialApp
//
//  Created by mac on 15/12/21.
//

import UIKit
import GooglePlaces
import PKHUD

class filterVC: UIViewController, GMSAutocompleteViewControllerDelegate {
    
    //for location filter only
    @IBOutlet weak var txtLocation: UITextField!
    private let mylocationManager = LocationManager()
    var strAddress = ""
    var strLat = ""
    var strLon = ""
    var strZipCode = ""
    var strRestaurantId = ""
    var strStreet = ""
    var strCity = ""
    var strApartment = ""
    var strState = ""
    var strCountry = ""
    
    @IBOutlet weak var lbltitle: UILabel!
    //outlets for sclider and buttons
    @IBOutlet weak var sliderDistance: UISliderX!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet var CustomTblView: UIView!
    @IBOutlet weak var tvDatalist: UITableView!
    @IBOutlet weak var HgtConsV: NSLayoutConstraint!
    @IBOutlet weak var HghtVCons: NSLayoutConstraint!
    @IBOutlet weak var btnMale: UIButtonX!
    @IBOutlet weak var btnFemale: UIButtonX!
    @IBOutlet weak var btnBoth: UIButtonX!
    @IBOutlet weak var btnAll: UIButtonX!
    @IBOutlet weak var btnOnline: UIButtonX!
    @IBOutlet weak var btnNew: UIButtonX!
    
    @IBOutlet weak var AllMarriedStatus: UIButtonX!
    @IBOutlet weak var UnMarried: UIButtonX!
    @IBOutlet weak var Married: UIButtonX!
    @IBOutlet weak var Divorce: UIButtonX!
    
    @IBOutlet weak var ageRangeSlider: RangeSlider!
    @IBOutlet weak var lblAgeRange: UILabel!
    
    @IBOutlet weak var sliderHeight: UISliderX!
    @IBOutlet weak var lblHeight: UILabel!
    
    @IBOutlet weak var sliderWeight: UISliderX!
    @IBOutlet weak var lblWeight: UILabel!
    
    @IBOutlet weak var viewAPls: UIViewX!
    @IBOutlet weak var btnAPls: UIButton!
    @IBOutlet weak var viewBPls: UIViewX!
    @IBOutlet weak var btnBPls: UIButton!
    @IBOutlet weak var viewOPls: UIViewX!
    @IBOutlet weak var btnOPls: UIButton!
    @IBOutlet weak var viewABPls: UIViewX!
    @IBOutlet weak var btnABPls: UIButton!
    @IBOutlet weak var viewAMns: UIViewX!
    @IBOutlet weak var btnAMns: UIButton!
    @IBOutlet weak var viewOMns: UIViewX!
    @IBOutlet weak var btnOMns: UIButton!
    @IBOutlet weak var viewBMns: UIViewX!
    @IBOutlet weak var btnBMns: UIButton!
    @IBOutlet weak var viewABMns: UIViewX!
    @IBOutlet weak var btnABMns: UIButton!
    
    @IBOutlet weak var ImgTik: UIImageView!
    @IBOutlet weak var btnTick: UIButtonX!
    
    //outlets for colletion view
    @IBOutlet weak var txtProfession: UITextField!
    @IBOutlet weak var txtEyeColor: UITextField!
    @IBOutlet weak var txtEducation: UITextField!
    @IBOutlet weak var txtBodyType: UITextField!
    @IBOutlet weak var txtHairColor: UITextField!
    @IBOutlet weak var txtSkinType: UITextField!
    @IBOutlet weak var txtLanguage: UITextField!
    @IBOutlet weak var txtReligion: UITextField!
    @IBOutlet weak var CollectionViewSkinType: UICollectionView!
    @IBOutlet weak var CollectionViewLanguage: UICollectionView!
    @IBOutlet weak var CollectionViewProfession: UICollectionView!
    @IBOutlet weak var CollectionViewReligion: UICollectionView!
    @IBOutlet weak var CollectionViewEducation: UICollectionView!
    @IBOutlet weak var CollectionViewBodyType: UICollectionView!
    @IBOutlet weak var CollectionViewHairColor: UICollectionView!
    @IBOutlet weak var CollectionViewEyeColor: UICollectionView!
    //width of collection views
    @IBOutlet weak var widthCollectionViewSkinType: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewLanguage: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewProfession: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewReligion: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewEducation: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewBodyType: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewHairColor: NSLayoutConstraint!
    @IBOutlet weak var widthCollectionViewEyeColor: NSLayoutConstraint!
    
    //array data for colletion view
    let arrSkinType = ["All","White","Fair","Brown","Dark Brown","Olive","Moderate Brown"]
    let arrLanguage = ["Hindi","English","French","Mandarin Chinese","Spanish","ARABIC","PORTUGUESE","BENGALI","RUSSIAN"]
    var arrProfession:[String] = []
    let arrReligion = ["Christianity","Islam","Irreligion","Hinduism","Buddhism","Folk religions","Sikhism","Judaism"]
    let arrEducation = ["Graduate","Post graduate","Philosopher","Doctorate"]
    let arrBodyType = ["No answer","Athletic","Average","A few extra pounds","Muscular","Big and bold","slim"]
    let arrHairColor = ["No answer","Black","Blond","Brown","Dyed","Grey","Red","Shaved","White"]
    let arrEyeColor:Array<String> = ["No answer","Black","Blue","Brown","Muscular","Green","Grey","Hazel","Other"]
    var selectedRows = [IndexPath]()
    @objc var selectedAr: NSMutableArray = NSMutableArray()
    //selected filtered data (for search user nearby oly)
    var sletFilterBy = ""
    var sletGender = ""
    var sletDistance = ""
    var sletAgeMin = ""
    var sletAgeMax = ""
    var sletMarriedStatus = ""
    var sletHeight = ""
    var sletWeight = ""
    var sletArrBloodgroup = [String]()
    var sletBloodgroup = ""
    var sletSkinType = ""
    var sletLanguage = ""
    var sletProfession = ""
    var sletReligion = ""
    var sletEducation = ""
    var sletBodyType = ""
    var sletHairColor = ""
    var sletEyeColor = ""
    var StrsletType = ""
    var StrConfirmInfo = "no"
    override func viewDidLoad() {
        super.viewDidLoad()
        //  self.CollectionViewSkinType.reloadData()
        // Do any additional setup after loading the view.
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
        self.showDefaultSaveFilterValue()
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 50)
        CustomTblView.isHidden = true
        CustomTblView.frame = view.bounds
        view.addSubview(CustomTblView)
    }
    
    
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @objc func displayMyAlertMessage(){
        
        let dialogMessage = UIAlertController(title: "Your Free Trial Expired ", message: "", preferredStyle: .alert)
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Renew", style: .default, handler: { (action) -> Void in
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "SelectPlaneVC") as! SelectPlaneVC
            self.navigationController?.pushViewController(vc, animated: false)
            NavigationBool = true
        })
        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(ok)
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
    @IBAction func ActionSave(_ sender: Any) {
        let PaymentSuccessed = UserDefaults.standard.bool(forKey: "Payment")
        let currentLogin = UserDefaults.standard.bool(forKey: "current")
        let ThreeDays = UserDefaults.standard.bool(forKey: "threedays")
        
        if currentLogin ==  true{
            
        
        if  self.StrConfirmInfo == "no"  {
            self.showAlert(title: "", message: "Please check the information first ", handler: nil)
        }else {
            Defaults[PDUserDefaults.ResetFilter] = "ResetFilter"
            //save default latitude
            if  self.strLat != ""{
                Defaults[PDUserDefaults.UserLat] = self.strLat
                Defaults[PDUserDefaults.SelectedLocation] = self.txtLocation.text!
            }
            //save default longitude
            if  self.strLon != ""{
                Defaults[PDUserDefaults.UserLng] = self.strLon
               // Defaults[PDUserDefaults.SelectedLocation] = self.txtLocation.text!
            }
            Defaults[PDUserDefaults.Distance] = self.sletDistance
            Defaults[PDUserDefaults.Gender] = self.sletGender
            Defaults[PDUserDefaults.AgeMin] = self.sletAgeMin
            Defaults[PDUserDefaults.AgeMax] = self.sletAgeMax
            // Defaults[PDUserDefaults.MarriedStatus] = self.sletMarriedStatus
            Defaults[PDUserDefaults.Height] = self.sletHeight
            Defaults[PDUserDefaults.Weight] = self.sletWeight
            Defaults[PDUserDefaults.BloodGroup] = sletBloodgroup
            Defaults[PDUserDefaults.SkinType] = sletSkinType
            Defaults[PDUserDefaults.Language] = sletLanguage
            Defaults[PDUserDefaults.Profession] = sletProfession
            Defaults[PDUserDefaults.Religion] = sletReligion
            Defaults[PDUserDefaults.Education] = sletEducation
            Defaults[PDUserDefaults.HairColor] = sletHairColor
            Defaults[PDUserDefaults.EyeColor] = sletEyeColor
            Defaults[PDUserDefaults.BodyType] = sletBodyType
            self.navigationController?.popViewController(animated: true)
        }
        }
        if ThreeDays ==  true{
            
        displayMyAlertMessage()
        
        }
        if PaymentSuccessed ==  true{
            
        
        if  self.StrConfirmInfo == "no"  {
            self.showAlert(title: "", message: "Please check the information first ", handler: nil)
        }else {
            Defaults[PDUserDefaults.ResetFilter] = "ResetFilter"
            //save default latitude
            if self.strLat != nil && self.strLat != ""{
                Defaults[PDUserDefaults.UserLat] = self.strLat
               // Defaults[PDUserDefaults.SelectedLocation] = self.txtLocation.text!
            }
            //save default longitude
            if self.strLon != nil && self.strLon != ""{
                Defaults[PDUserDefaults.UserLng] = self.strLon
                Defaults[PDUserDefaults.SelectedLocation] = self.txtLocation.text!
            }
            Defaults[PDUserDefaults.Distance] = self.sletDistance
            Defaults[PDUserDefaults.Gender] = self.sletGender
            Defaults[PDUserDefaults.AgeMin] = self.sletAgeMin
            Defaults[PDUserDefaults.AgeMax] = self.sletAgeMax
            // Defaults[PDUserDefaults.MarriedStatus] = self.sletMarriedStatus
            Defaults[PDUserDefaults.Height] = self.sletHeight
            Defaults[PDUserDefaults.Weight] = self.sletWeight
            Defaults[PDUserDefaults.BloodGroup] = sletBloodgroup
            Defaults[PDUserDefaults.SkinType] = sletSkinType
            Defaults[PDUserDefaults.Language] = sletLanguage
            Defaults[PDUserDefaults.Profession] = sletProfession
            Defaults[PDUserDefaults.Religion] = sletReligion
            Defaults[PDUserDefaults.Education] = sletEducation
            Defaults[PDUserDefaults.HairColor] = sletHairColor
            Defaults[PDUserDefaults.EyeColor] = sletEyeColor
            Defaults[PDUserDefaults.BodyType] = sletBodyType
            self.navigationController?.popViewController(animated: true)
        }
        }
    }
    
    //MARK: ActionType
    @IBAction func OnClickCancelBtn(_ sender: Any) {
        CustomTblView.isHidden = true
    }
    @IBAction func OnClickOkBtn(_ sender: Any) {
        CustomTblView.isHidden = true
    }
    @IBAction func OnClickProfession(_ sender: Any) {
        StrsletType = "Profession"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession = ["Accountant","Actor","Actress","Air traffic controller","Architect","Artist","Attorney","Banker","Bartender","Barber","Bookkeeper","Builder","Businessman","Businesswoman", "Businessperson","Carpenter","Cashier","Chef","Coach","Dentist","Hygienist","Designer","Developer","Dietician","Doctor", "Economist","Editor","Electrician","Engineer"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 20)
    }
    @IBAction func OnClickBodyType(_ sender: Any) {
        StrsletType = "Body Type"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =   ["No answer","Athletic","Average","A few extra pounds","Muscular","Big and bold","slim"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func OnClickHairColor(_ sender: Any) {
        StrsletType = "Hair Color"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =  ["No answer","Black","Blond","Brown","Dyed","Grey","Red","Shaved","White"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func OnClickSkinType(_ sender: Any) {
        StrsletType = "Skin Type"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =  ["All","White","Fair","Brown","Dark Brown","Olive","Moderate Brown"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func OnClickLanguage(_ sender: Any) {
        StrsletType = "Language"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =  ["Hindi","English","French","Mandarin Chinese","Spanish","ARABIC","PORTUGUESE","BENGALI","RUSSIAN"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func OnClickReligion(_ sender: Any) {
        StrsletType = "Religion"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =  ["Christianity","Islam","Irreligion","Hinduism","Buddhism","Folk religions","Sikhism","Judaism"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func OnClickEducation(_ sender: Any) {
        StrsletType = "Education"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =  ["Graduate","Post graduate","Philosopher","Doctorate"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func OnClickEyeClr(_ sender: Any) {
        StrsletType = "Eye Color"
        lbltitle.text = StrsletType
        arrProfession = []
        selectedRows = []
        selectedAr = []
        arrProfession =   ["No answer","Black","Blue","Brown","Muscular","Green","Grey","Hazel","Other"]
        CustomTblView.isHidden = false
        tvDatalist.reloadData()
        self.HghtVCons.constant = 60 + CGFloat(self.arrProfession.count * 60)
    }
    @IBAction func PickLocationMethod(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func ActionSliderDistance(_ sender: Any) {
        self.lblDistance.text = String(Int(self.sliderDistance.value)) + " km"
        self.sletDistance = String(Int(self.sliderDistance.value))
    }
    
    @IBAction func ActionShowMe(_ sender: UIButton) {
        let tag = sender.tag
        // print("btn tag is ",tag)
        self.selectShowMe(tag: tag)
    }
    @IBAction func OnClickFilterBy(_ sender: UIButton) {
        let tag = sender.tag
        // print("btn tag is ",tag)
        self.selectShowMe(tag: tag)
    }
    
    @IBAction func ActionMarriedStatus(_ sender: UIButton) {
        let tag = sender.tag
        // print("btn tag is ",tag)
        self.selectMarriedStatus(tag: tag)
    }
    
    @IBAction func ActionAgeRangeSlider(_ sender: Any) {
        print("Lower_Age",Int(self.ageRangeSlider.lowerValue))
        print("upper_Age",Int(self.ageRangeSlider.upperValue))
        self.lblAgeRange.text = "\(Int(self.ageRangeSlider.lowerValue)) - \(Int(self.ageRangeSlider.upperValue)) years"
        self.sletAgeMin = "\(Int(self.ageRangeSlider.lowerValue))"
        self.sletAgeMax = "\(Int(self.ageRangeSlider.upperValue))"
    }
    
    @IBAction func ActionSliderHeight(_ sender: Any) {
        self.lblHeight.text = String(Int(self.sliderHeight.value)) + " Cm"
        self.sletHeight = String(Int(self.sliderHeight.value))
    }
    
    @IBAction func ActionSliderWeight(_ sender: Any) {
        self.lblWeight.text = String(Int(self.sliderWeight.value)) + " Kg"
        self.sletWeight = String(Int(self.sliderWeight.value))
    }
    
    @IBAction func ActionBloodGroupAplus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnAPls, viwName: viewAPls, BloodGroupName: "A+")
    }
    @IBAction func ActionBloodGroupBplus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnBPls, viwName: viewBPls, BloodGroupName: "B+")
    }
    @IBAction func ActionBloodGroupOplus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnOPls, viwName: viewOPls, BloodGroupName: "O+")
    }
    @IBAction func ActionBloodGroupABplus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnABPls, viwName: viewABPls, BloodGroupName: "AB+")
    }
    @IBAction func ActionBloodGroupAminus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnAMns, viwName: viewAMns, BloodGroupName: "A-")
    }
    @IBAction func ActionBloodGroupOminus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnOMns, viwName: viewOMns, BloodGroupName: "O-")
    }
    @IBAction func ActionBloodGroupBminus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnBMns, viwName: viewBMns, BloodGroupName: "B-")
    }
    @IBAction func ActionBloodGroupABminus(_ sender: UIButton) {
        self.bGroupAddDelete(tag: sender.tag, btnName: btnABMns, viwName: viewABMns, BloodGroupName: "AB-")
    }
    
    func bGroupAddDelete(tag: Int,btnName: UIButton,viwName: UIView,BloodGroupName: String){
        let tag = tag
        if tag == 0{//select
            btnName.tag = 1
            viwName.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            let BloodGroup = "'\(BloodGroupName)'"
            self.sletArrBloodgroup.append("\(BloodGroup)")
            
            sletBloodgroup = (sletArrBloodgroup.map{($0)}).joined(separator: ",")
            print(sletBloodgroup)
        }else if tag == 1{//unselect
            btnName.tag = 0
            viwName.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletArrBloodgroup.removeAll { $0 == "\(BloodGroupName)" }
        }
        print("Selected_sletArrBloodgroup",self.sletArrBloodgroup)
    }
    
}

//MARK: -extenshion for show show default save value
extension filterVC {
    func showDefaultSaveFilterValue(){
        self.txtLocation.text = "People nearby"
        self.sliderDistance.value = 10000
        self.lblDistance.text = "10000" + "km"
        Defaults[PDUserDefaults.Distance] = "10000"
        self.sletDistance = "10000"
        self.btnBoth.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.sletGender = "all"
        self.ageRangeSlider.lowerValue = 18
        self.ageRangeSlider.upperValue = 65
        self.lblAgeRange.text = "18 - 65 years"
        self.sletAgeMin = "18"
        Defaults[PDUserDefaults.AgeMin] = "18"
        self.sletAgeMax = "65"
        Defaults[PDUserDefaults.AgeMax] = "65"
        self.sliderHeight.value = 400
        self.lblHeight.text = "400" + " Cm"
        Defaults[PDUserDefaults.Height] = "400"
        self.sletHeight = "400"
        self.sliderWeight.value = 150
        self.lblWeight.text = "150" + " Kg"
        Defaults[PDUserDefaults.Weight] = "150"
        self.sletWeight = "150"
        
    }
}

//MARK: extension for live location
extension filterVC {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let strAddress = place.formattedAddress
        self.strLat = "\(place.coordinate.latitude)"
        self.strLon = "\(place.coordinate.longitude)"
        
        print("latitude is ", place.coordinate.latitude)
        print("longitude is ", place.coordinate.longitude)
        
        print("strAddress = \(strAddress!)")
        self.strAddress = "\(strAddress!)"
        self.txtLocation.text = strAddress!
        self.strAddress = strAddress!
        
        let latitude: CLLocationDegrees = place.coordinate.latitude
        let longitude: CLLocationDegrees = place.coordinate.longitude
        
        self.strLat = "\(latitude)"
        self.strLon = "\(longitude)"
        
        let newlocation: CLLocation = CLLocation(latitude: latitude,
                                                 longitude: longitude)
        
        self.mylocationManager.getPlace(for: newlocation) { placemark in
            
            guard let placemark = placemark else { return }
            
            var output = ""
            
            if let subThoroughfare = placemark.subThoroughfare {
                output = output + " \(subThoroughfare),"
                
            }
            
            if let thoroughfare = placemark.thoroughfare {
                output = output + " \(thoroughfare),"
                self.strApartment = output
            }
            
            if let subLocality = placemark.subLocality {
                output = output + " \(subLocality),"
                self.strStreet = "\(subLocality)"
            }
            
            if let town = placemark.locality {
                output = output + " \(town),"
                self.strCity = "\(town)"
            }
            
            if let state = placemark.administrativeArea {
                output = output + " \(state),"
                self.strState = state
            }
            
            if let postalcode = placemark.postalCode {
                output = output + " \(postalcode),"
                self.strZipCode = "\(postalcode)"
            }
            
            if let country = placemark.country {
                output = output + " \(country)"
                self.strCountry = "\(country)"
            }
            
            print("output = \(output)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: \(error)")
        dismiss(animated: true, completion: nil)
    }
    
    // User cancelled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func ActionTick(_ sender: Any) {
        
        if (sender as AnyObject).tag == 0 {//for tick
            self.ImgTik.image = #imageLiteral(resourceName: "deselect")
            self.btnTick.tag = 1
            StrConfirmInfo = "yes"
            
        }else if (sender as AnyObject).tag == 1 {//for untick
            self.ImgTik.image = #imageLiteral(resourceName: "select")
            self.btnTick.tag = 0
            StrConfirmInfo = "no"
            
        }
        
    }
}
// MARK: - Extenction For tableView
extension filterVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrProfession.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvDatalist.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.lblName.text = arrProfession[indexPath.row]
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(checkMarkButtonClicked(sender:)), for: .touchUpInside)
        
        if selectedRows.contains(indexPath){
            cell.btnCheck.setImage(#imageLiteral(resourceName: "deselect"), for: .normal)
            cell.btnCheck.isSelected = true
        }else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            cell.btnCheck.isSelected = false
        }
        
        return cell
    }
    
    
    @objc func checkMarkButtonClicked ( sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            let buttonPosition:CGPoint = sender.convert(.zero, to: self.tvDatalist)
            let indexPath = self.tvDatalist?.indexPathForRow(at: buttonPosition)
            let aircraft = arrProfession[indexPath!.row]
            sender.setImage(#imageLiteral(resourceName: "select"), for: .normal)
            selectedAr.remove(aircraft)
        } else {
            // checkmark it
            sender.isSelected = true
            let buttonPosition:CGPoint = sender.convert(.zero, to: self.tvDatalist)
            let indexPath = self.tvDatalist?.indexPathForRow(at: buttonPosition)
            let aircraft = "'\(arrProfession[indexPath!.row])'"
            sender.setImage(#imageLiteral(resourceName: "deselect"), for: .normal)
            
            if selectedRows.contains(indexPath!) {
                selectedRows.remove(at: selectedRows.firstIndex(of: indexPath!)!)
            } else {
                selectedAr.add(aircraft)
                selectedRows.append(indexPath!)
            }
            tvDatalist.reloadRows(at: [indexPath!], with: .automatic)
        }
        
        let strMultiSelect = (selectedAr.map{($0) as! String}).joined(separator: ",")
        let  strSplitType = strMultiSelect.replacingOccurrences(of: "'", with: "")
        
        if StrsletType == "Profession" {
            sletProfession = strMultiSelect
            txtProfession.text = strSplitType
        }else if StrsletType == "Body Type"{
            sletBodyType = strMultiSelect
            txtBodyType.text = strSplitType
        }else if StrsletType == "Hair Color"{
            sletHairColor = strMultiSelect
            txtHairColor.text = strMultiSelect
        }else if StrsletType == "Skin Type"{
            sletSkinType = strMultiSelect
            txtSkinType.text = strMultiSelect
        }else if StrsletType == "Language"{
            sletLanguage = strMultiSelect
            txtLanguage.text = strMultiSelect
        }else if StrsletType == "Religion"{
            sletReligion = strMultiSelect
            txtReligion.text = strMultiSelect
        }else if StrsletType == "Education"{
            sletEducation = strMultiSelect
            txtEducation.text = strMultiSelect
        }else{
            sletEyeColor = strMultiSelect
            txtEyeColor.text = strMultiSelect
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
//MARK: -Extension for collection view
extension filterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == CollectionViewSkinType{
            self.widthCollectionViewSkinType.constant = CGFloat((self.arrSkinType.count * 110 ) + 20 )
            return self.arrSkinType.count
        }else if collectionView == CollectionViewLanguage{
            self.widthCollectionViewLanguage.constant = CGFloat((self.arrLanguage.count * 110 ) + 20 )
            return self.arrLanguage.count
        }else if collectionView == CollectionViewProfession{
            self.widthCollectionViewProfession.constant = CGFloat((self.arrProfession.count * 110 ) + 20 )
            return self.arrProfession.count
        }else if collectionView == CollectionViewReligion{
            self.widthCollectionViewReligion.constant = CGFloat((self.arrReligion.count * 110 ) + 20 )
            return self.arrReligion.count
        }else if collectionView == CollectionViewEducation{
            self.widthCollectionViewEducation.constant = CGFloat((self.arrEducation.count * 110 ) + 20 )
            return self.arrEducation.count
        }else if collectionView == CollectionViewBodyType{
            self.widthCollectionViewBodyType.constant = CGFloat((self.arrBodyType.count * 110 ) + 20 )
            return self.arrBodyType.count
        }else if collectionView == CollectionViewHairColor{
            self.widthCollectionViewHairColor.constant = CGFloat((self.arrHairColor.count * 110 ) + 20 )
            return self.arrHairColor.count
        }else{
            self.widthCollectionViewEyeColor.constant = CGFloat((self.arrEyeColor.count * 110 ) + 20 )
            return self.arrEyeColor.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == CollectionViewSkinType{
            let cell = self.CollectionViewSkinType.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblSkinType.text = self.arrSkinType[indexPath.row]
            
            if Defaults[PDUserDefaults.SkinType] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.SkinType] = "All"
                self.sletSkinType = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrSkinType[indexPath.row] == Defaults[PDUserDefaults.SkinType] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletSkinType = Defaults[PDUserDefaults.SkinType]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else if collectionView == CollectionViewLanguage{
            let cell = self.CollectionViewLanguage.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblLanguage.text = self.arrLanguage[indexPath.row]
            
            if Defaults[PDUserDefaults.Language] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.Language] = "All"
                self.sletLanguage = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrLanguage[indexPath.row] == Defaults[PDUserDefaults.Language] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletLanguage = Defaults[PDUserDefaults.Language]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else if collectionView == CollectionViewProfession{
            let cell = self.CollectionViewProfession.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblProfession.text = self.arrProfession[indexPath.row]
            
            if Defaults[PDUserDefaults.Profession] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.Profession] = "All"
                self.sletProfession = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrProfession[indexPath.row] == Defaults[PDUserDefaults.Profession] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletProfession = Defaults[PDUserDefaults.Profession]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else if collectionView == CollectionViewReligion{
            let cell = self.CollectionViewReligion.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblReligion.text = self.arrReligion[indexPath.row]
            
            if Defaults[PDUserDefaults.Religion] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.Religion] = "All"
                self.sletReligion = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrReligion[indexPath.row] == Defaults[PDUserDefaults.Religion] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletReligion = Defaults[PDUserDefaults.Religion]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else if collectionView == CollectionViewEducation{
            let cell = self.CollectionViewEducation.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblEducation.text = self.arrEducation[indexPath.row]
            
            if Defaults[PDUserDefaults.Education] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.Education] = "All"
                self.sletEducation = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrEducation[indexPath.row] == Defaults[PDUserDefaults.Education] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletEducation = Defaults[PDUserDefaults.Education]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else if collectionView == CollectionViewBodyType{
            let cell = self.CollectionViewBodyType.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblBodyType.text = self.arrBodyType[indexPath.row]
            
            if Defaults[PDUserDefaults.BodyType] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.BodyType] = "All"
                self.sletBodyType = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrBodyType[indexPath.row] == Defaults[PDUserDefaults.BodyType] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletBodyType = Defaults[PDUserDefaults.BodyType]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else if collectionView == CollectionViewHairColor{
            let cell = self.CollectionViewHairColor.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblHairColor.text = self.arrHairColor[indexPath.row]
            
            if Defaults[PDUserDefaults.HairColor] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.HairColor] = "All"
                self.sletHairColor = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrHairColor[indexPath.row] == Defaults[PDUserDefaults.HairColor] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletHairColor = Defaults[PDUserDefaults.HairColor]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }else{
            let cell = self.CollectionViewEyeColor.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.lblEyeColor.text = self.arrEyeColor[indexPath.row]
            
            if Defaults[PDUserDefaults.EyeColor] == "" && indexPath.row == 0{
                Defaults[PDUserDefaults.EyeColor] = "All"
                self.sletEyeColor = "All"
                cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                if self.arrEyeColor[indexPath.row] == Defaults[PDUserDefaults.EyeColor] {
                    cell.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
                    self.sletEyeColor = Defaults[PDUserDefaults.EyeColor]
                }else{
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectIndex = indexPath.row
        
        if collectionView == CollectionViewSkinType{
            self.sletSkinType = self.arrSkinType[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrSkinType, selectIndex: selectIndex, collectionView)
        }else if collectionView == CollectionViewLanguage{
            self.sletLanguage = self.arrLanguage[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrLanguage, selectIndex: selectIndex, collectionView)
        }else if collectionView == CollectionViewProfession{
            self.sletProfession = self.arrProfession[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrProfession, selectIndex: selectIndex, collectionView)
        }else if collectionView == CollectionViewReligion{
            self.sletReligion = self.arrReligion[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrReligion, selectIndex: selectIndex, collectionView)
        }else if collectionView == CollectionViewEducation{
            self.sletEducation = self.arrEducation[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrEducation, selectIndex: selectIndex, collectionView)
        }else if collectionView == CollectionViewBodyType{
            self.sletBodyType = self.arrBodyType[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrBodyType, selectIndex: selectIndex, collectionView)
        }else if collectionView == CollectionViewHairColor{
            self.sletHairColor = self.arrHairColor[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrHairColor, selectIndex: selectIndex, collectionView)
        }else{
            self.sletEyeColor = self.arrEyeColor[selectIndex]
            self.allCollectionViewBGShade(arrayName: self.arrEyeColor, selectIndex: selectIndex, collectionView)
        }
        
    }
    
}

//MARK: -extension for select of all collection view background colour
extension filterVC{
    func allCollectionViewBGShade(arrayName: Array<Any>, selectIndex: Int, _ collectionView: UICollectionView){
        
        for i in 0...arrayName.count-1 {
            let newindexPath = NSIndexPath(row: i, section: 0)
            if i == selectIndex {
                
                let cell = collectionView.cellForItem(at: newindexPath as IndexPath) as? CollectionViewCell
                cell?.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }else{
                let cell = collectionView.cellForItem(at: newindexPath as IndexPath) as? CollectionViewCell
                cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    
}

//MARK: -extension for select show me
extension filterVC{
    func selectShowMe(tag: Int){
        if tag == 0 {
            // print("tag is zeor")
            self.btnMale.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.btnFemale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnBoth.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletGender = "Male"
        }else if tag == 1 {
            // print("tag is one")
            self.btnMale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnFemale.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.btnBoth.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletGender = "Female"
        }else if tag == 2 {
            //  print("tag is two")
            self.btnMale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnFemale.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnBoth.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.sletGender = "all"
        }
    }
    func selectFilterby(tag: Int){
        if tag == 0 {
            // print("tag is zeor")
            self.btnAll.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.btnOnline.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnNew.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletFilterBy = "Male"
        }else if tag == 1 {
            // print("tag is one")
            self.btnAll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnOnline.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.btnNew.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletFilterBy = "Female"
        }else if tag == 2 {
            //  print("tag is two")
            self.btnAll.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnOnline.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnNew.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.sletFilterBy = "all"
        }
    }
}

//MARK: -extension for select MArried Status
extension filterVC{
    func selectMarriedStatus(tag: Int){
        if tag == 0 {
            // print("tag is zeor")
            self.UnMarried.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.Married.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.Divorce.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.AllMarriedStatus.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletMarriedStatus = "UnMarried"
        }else if tag == 1 {
            // print("tag is one")
            self.UnMarried.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.Married.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.Divorce.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.AllMarriedStatus.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletMarriedStatus = "Married"
        }else if tag == 2 {
            //  print("tag is two")
            self.UnMarried.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.Married.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.Divorce.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.AllMarriedStatus.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sletMarriedStatus = "Divorce"
        }else if tag == 3 {
            //  print("tag is three")
            self.UnMarried.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.Married.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.Divorce.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.AllMarriedStatus.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.sletMarriedStatus = "All"
        }
    }
}
import UIKit

class FilterCell: UITableViewCell {
    
    //MARK: - tblViewSettings Outlet
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnCheck: UIButton!
    
}
