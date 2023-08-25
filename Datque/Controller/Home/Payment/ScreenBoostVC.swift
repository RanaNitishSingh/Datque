//
//  ScreenBoostVC.swift
//  SocialApp
//
//  Created by mac on 19/01/22.
//

import UIKit
import StoreKit
import Toast_Swift
import Alamofire
import PKHUD
import SDWebImage
import SwiftUI
import Firebase
import FirebaseStorage
import SwiftyJSON


class ScreenBoostVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
//MARK: Variables
    let product_id: NSString = "DatqueBoosting"
    
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var skipLineLbl: UILabel!     
    @IBOutlet weak var elevateBtn: UIButtonX!
    var timer: Timer?
    var totalTime = 0
    var currentTS = 0
    var savedTS = 0
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async { [self] in
            self.savedTS = UserDefaults.standard.integer(forKey: "TimeLeftdate")
            self.currentTS = Int(Date.currentTimeStamp)
            if savedTS > currentTS {
                let timeLefts = savedTS - currentTS
                self.totalTime = timeLefts
                skipLineLbl.isHidden = true
                startOtpTimer()
            } else {
                UserDefaults.standard.removeObject(forKey: "TimeLeftdate")
                skipLineLbl.isHidden = false
                self.timerLbl.text = "Be the Profile in your area for 30 minutes and get more watchs"
                self.elevateBtn.setTitle("ELEVATE ME", for: .normal)
                self.totalTime = 0
            }
        }
        SKPaymentQueue.default().add(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        getDate()
    }
    
//MARK: Actions
    @IBAction func ActionBack(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func ActionBoost(_ sender: Any) {
        if (SKPaymentQueue.canMakePayments()) {
               let productID:NSSet = NSSet(array: [self.product_id as NSString]);
               let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
               productsRequest.delegate = self;
               productsRequest.start();
               print("Fetching Products");
            if (sender as AnyObject).title(for: .normal) == "ELEVATE ME" {
                UserDefaults.standard.set(Int(Date.currentTimeStamp + 1800), forKey: "TimeLeftdate")
                self.totalTime = 1800
                startOtpTimer()
                self.navigationController!.popViewController(animated: true)        
                self.elevateBtn.setTitle("OKEY", for: .normal)
                self.skipLineLbl.isHidden = true
            }else{
                self.navigationController!.popViewController(animated: true)
            }
           } else {
               print("can't make purchases");
           }
    }
    
    private func startOtpTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.timerLbl.text = self.timeFormatted(self.totalTime) + "\n" + "You're being seen by more people.Keep swiping for the best results!"
        if totalTime != 0 {
            totalTime -= 1
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                self.timerLbl.text = "Be the Profile in your area for 30 minutes and get more watchs"
                self.elevateBtn.setTitle("ELEVATE ME", for: .normal)
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d min:%02d sec Remaining", minutes, seconds)
    }
    
    
//MARK: Functions
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {

        print(response.products)
        let count : Int = response.products.count
        if (count>0) {
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id as String) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                self.buyProduct(product: validProduct)
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    func buyProduct(product: SKProduct) {
            let arr = UserDefaults.standard.stringArray(forKey: "SavedStringArray") ?? [String]()
            print("Sending the Payment Request to Apple");
            if arr.count <= 2 {
                let payment = SKPayment(product: product)
                SKPaymentQueue.default().add(payment);
            }else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert!!!", message: "You can elevate your profile 3 times a day.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased")
                    var arr = UserDefaults.standard.stringArray(forKey: "SavedStringArray") ?? [String]()
                    arr.append("purchased")
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d, MMMM, yyyy"
                    let dateString = dateFormatter.string(from: currentDate)
                    UserDefaults.standard.set(dateString, forKey:"creationTime")
                    UserDefaults.standard.set(arr, forKey: "SavedStringArray")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .failed:
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                case .restored:
                    print("Already Purchased")
                    //Do unlocking etc stuff here in case of restor
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default:
                    break;
                }
            }
        }
    }

    //If an error occurs, the code will go to this function
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
            // Show some alert
        }
    func getDate() {
        let dateString = UserDefaults.standard.string(forKey: "creationTime") ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d, MMMM, yyyy"
        guard let date = dateFormatter.date(from: dateString) else { return }
        let calendar = Calendar.current
        guard let nextDayDate = calendar.date(byAdding: .day, value: 1, to: date) else { return }
        let nextDayDateString = dateFormatter.string(from: nextDayDate)
        let curr = Date()
        let curDate = dateFormatter.string(from: curr)
        guard let pres = dateFormatter.date(from: curDate) else { return }
        guard let purc = dateFormatter.date(from: nextDayDateString) else { return }
        let comparisonResult = pres.compare(purc)
           if comparisonResult == .orderedAscending {
               print("\(pres) is earlier than \(purc)")
           } else if comparisonResult == .orderedDescending {
               print("\(pres) is later than \(purc)")
               UserDefaults.standard.removeObject(forKey: "SavedStringArray")
           } else {
               print("\(pres) is the same as \(purc)")
               UserDefaults.standard.removeObject(forKey: "SavedStringArray")
           }
    }
    
    func BoostScreen() {
        let url = AppUrl.screenBoost()
        let parameters: [String: Any] = ["fb_id" : "\(Defaults[PDUserDefaults.UserID])",
                                         "mins" : "30",
                                         "promoted" : "1",
                                         "device" : "ios"]
        print("Url_ChangeProfilePictureServices_is_here:-" , url)
        print("Param_ChangeProfilePictureServices_is_here:-" , parameters)
        
        AF.request(url, method:.post, parameters: parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
            Utility.hideLoading()
            print("Response",response)
            if response.value != nil {
                let responseJson = JSON(response.value!)
                print("Code_is_ChangeProfilePictureServices",responseJson["code"])
                               
                if responseJson["code"] == "200" {
                   
                }else if responseJson["code"] == "201" {
                    print("Something went wrong error code_201")
                }else{
                    print("Something went wrong in_json")
                }
            }
        }
    }
    
    
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
}
