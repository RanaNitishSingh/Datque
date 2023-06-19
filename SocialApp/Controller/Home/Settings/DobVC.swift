//
//  DobVC.swift
//  SocialApp
//
//  Created by mac on 17/12/21.
//

import UIKit

protocol GoToBackDOBDelegate {
    func BackDOB(finalDOB: String)
}

class DobVC: UIViewController {
    
    var delegate: GoToBackDOBDelegate? = nil

    var strDob = ""
    @IBOutlet weak var txtSelectDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set dob
        self.txtSelectDate.text = strDob
        //  Create action on text field
        self.txtSelectDate.addTarget(self, action: #selector(showDatePicker(sender:)), for: .editingDidBegin)

        // Do any additional setup after loading the view.
        print("DobVC")
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        if !txtSelectDate.text!.trimmingCharacters(in: .whitespaces).isEmpty {
            self.delegate?.BackDOB(finalDOB: "\(self.txtSelectDate.text!)")
            self.navigationController!.popViewController(animated: true)
        }else{
            self.view.makeToast("Select date of birth")
        }
        
    }
    
}

//MARK:- Extenction for (Date and time selector)
extension DobVC {
    
    @objc func showDatePicker(sender: UITextField) {
        /*let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        datePickerView.minimumDate = Date()
        sender.inputView = datePickerView*/
        
        /*let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        //datePickerView.minimumDate = Date()
        let currentDate = NSDate()
        datePickerView.maximumDate = currentDate as Date
        datePickerView.date = currentDate as Date*/
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        } else {
            //datePickerView.preferredDatePickerStyle = .wheels
        }
        let date = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePickerView.maximumDate = date
        datePickerView.date = date!
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
            let formatter = DateFormatter()
            //formatter.dateFormat = "yyyy-MM-dd"
            formatter.dateFormat = "dd-MM-yyyy"
        self.txtSelectDate.text  = formatter.string(from: sender.date)
           // print("Start date :- \(self.txtSelectDate.text ?? "NA")")
    }
    
}




