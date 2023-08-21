//
//  AppearanceVC.swift
//  SocialApp
//
//  Created by mac on 17/12/21.
//

import UIKit
import iOSDropDown

protocol GoToBackAppearanceDelegate {
    func BackAppearance(finalAppearance: [String])
}

class AppearanceVC: UIViewController {
    
    var delegate: GoToBackAppearanceDelegate? = nil
    
    var arrNameApperances: [String] = []
    
    @IBOutlet weak var DropDownHeight: DropDown!
    var arrHeight = ["No answer", "4 to  4.11 inch", "5 to  5.11 inch", "6 to  6.11 inch", "7 to  7.11 inch"]
    
    @IBOutlet weak var DropDownWeight: DropDown!
    var arrWeight = ["No answer", "40 to 50 kg", "51 to 60 kg", "61 to 70 kg", "71 to 80 kg", "81 to 90 kg", "91 to 100 kg"]
    
    @IBOutlet weak var DropDownBodyType: DropDown!
    var arrBodyType = ["No answer", "Athletic", "Average", "A few extra pounds", "Muscular", "Big and bold", "slim"]
    
    @IBOutlet weak var DropDownEyeColour: DropDown!
    var arrEyeColour = ["No answer", "Black", "Blue", "Brown", "Muscular", "Green", "Grey", "Hazel", "Other"]
    
    @IBOutlet weak var DropDownHairColour: DropDown!
    var arrHairColour = ["No answer", "Black", "Blond", "Brown", "Dyed", "Grey", "Red", "Shaved", "White"]
    
    @IBOutlet weak var  selectHeightLbl: UILabel!
    
    @IBOutlet weak var selectWeightLbl: UILabel!
    
    @IBOutlet weak var selectBodyLbl: UILabel!
    
    @IBOutlet weak var selectEyeLbl: UILabel!
    
    @IBOutlet weak var selectHairLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set data of user
        
        self.DropDownHeight.text = self.arrNameApperances[0]
        self.DropDownWeight.text = self.arrNameApperances[1]
        self.DropDownBodyType.text = self.arrNameApperances[2]
        self.DropDownEyeColour.text = self.arrNameApperances[3]
        self.DropDownHairColour.text = self.arrNameApperances[4]
        
        self.dropDown()
        // Do any additional setup after loading the view.
        print("AppearanceVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        self.delegate?.BackAppearance(finalAppearance: self.arrNameApperances)
        self.navigationController!.popViewController(animated: true)
    }
}

//MARK:- Extenction For Drop Down
extension AppearanceVC{
    func dropDown(){
        
        DropDownHeight.optionArray = arrHeight
        DropDownWeight.optionArray = arrWeight
        DropDownBodyType.optionArray = arrBodyType
        DropDownEyeColour.optionArray = arrEyeColour
        DropDownHairColour.optionArray = arrHairColour
        
        //Did Select DropDown
        DropDownHeight.didSelect{(selectedText , index ,id) in
        print("selected DropDownHeight is..",selectedText)
            self.arrNameApperances[0] = selectedText
            self.selectHeightLbl.isHidden = true
        }
        
        DropDownWeight.didSelect{(selectedText , index ,id) in
        print("selected DropDownWeight is..",selectedText)
            self.arrNameApperances[1] = selectedText
            self.selectWeightLbl.isHidden = true
        }
        
        DropDownBodyType.didSelect{(selectedText , index ,id) in
        print("selected DropDownBodyType is..",selectedText)
            self.arrNameApperances[2] = selectedText
            self.selectBodyLbl.isHidden = true
        }
        
        DropDownEyeColour.didSelect{(selectedText , index ,id) in
        print("selected DropDownEyeColour is..",selectedText)
            self.arrNameApperances[3] = selectedText
            self.selectEyeLbl.isHidden = true
        }
        
        DropDownHairColour.didSelect{(selectedText , index ,id) in
        print("selected DropDownHairColour is..",selectedText)
            self.arrNameApperances[4] = selectedText
            self.selectHairLbl.isHidden = true
        }
        
    }
}
