//
//  SelectPlaneVC.swift
//  SocialApp
//
//  Created by mac on 19/01/22.
//

import UIKit
import StoreKit
import SwiftyStoreKit
var global = true
var globalindex =  false
class SelectPlaneVC: BaseViewController, UIScrollViewDelegate{
    
    var arrImage = [  #imageLiteral(resourceName: "logo round"), #imageLiteral(resourceName: "power_1New 1") ]
    var arrName = ["See Who Likes you?","Unlimited Elevate"]
    var arrPrice = ["10","20"]
    var arrValidity = ["Per Year","Per Month"]
    var selectPlane = ""
    var selectIndex = Int()
    var plantype = Int()
    var selectValidation = ""
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL = "KeykeyAnnual"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER = "KeyKeyhalfyearly"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY = "KeyKeyyMonth"
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblValidity: UILabel!
    @IBOutlet weak var ViewMonths: UIView!
    @IBOutlet weak var ViewYear: UIView!
    @IBOutlet weak var ViewQuarter: UIView!
    @IBOutlet weak var ContinueButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.InAppPurchaseCode()
    }
    override func viewWillAppear(_ animated: Bool) {
        ContinueButton.layer.cornerRadius =  25
        selectIndex = 1
        plantype = 6
    }

    @IBAction func ActionContinue(_ sender: Any) {
        if globalindex == false{
            displayMyAlertMessage()
        }
        if globalindex == true{
            global = false
            if self.selectPlane != ""  {
                IAPHandler.shared.purchaseMyProduct(index: selectIndex)
                self.purchase(strProductId: selectPlane)
            }
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CardDetailVC") as? CardDetailVC
            vc?.planType = self.plantype
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }

    @objc func displayMyAlertMessage(){
        let dialogMessage = UIAlertController(title: "Alert ", message: " Please Select Any Plan", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
            })
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
}
    
    @IBAction func OnClickTerms(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "SecondaryBoard", bundle: Bundle.main).instantiateViewController(withIdentifier: "webViewController") as? webViewController
        vc?.headerTxt = "Terms & Conditions"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func ActionBack(_ sender: Any) {
        if global == true{
        self.navigationController!.popViewController(animated: true)
        }
    }
}

extension SelectPlaneVC {
    
    //In app purchase code
    func InAppPurchaseCode () {
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = { [weak self] (type) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch type {
                case .purchased, .restored:
                    let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                        
                        strongSelf.dismiss(animated: true)
                    })
                    
                    alertView.addAction(action)
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        topController.present(alertView, animated: true, completion: nil)
                    }
                default:
                    let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    })
                    alertView.addAction(action)
                    if var topController = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = topController.presentedViewController {
                            topController = presentedViewController
                        }
                        topController.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        }
        
        IAPHandler.shared.purchaseProductsBlock = {[weak self] (products) in
            guard let strongSelf = self else{ return }
            if products.count > 0 {
                let product = products[0]
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                let text = String(format: "%@! per year.", price1Str!)
                
                // strongSelf.btnBuy.setTitle("\(text)", for: UIControlState.normal)
                print(text)
            } else {
                let alertView = UIAlertController(title: "", message: "Not product found", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    ///Action to perform restore purchase
    @IBAction func restorePurchasesPressed(_ sender: Any) {
        // IAPHandler.shared.restorePurchase()
    }
    
    ///Action for 1 month subscription
    @IBAction func MonthlyPurchasesPressed(_ sender: Any) {
        if global == true{
            selectPlane = NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY
            selectIndex = 1
            plantype = 1
            UserDefaults.standard.set(selectIndex, forKey: "Index")
            self.ViewMonths.backgroundColor = #colorLiteral(red: 0.6276120543, green: 0.1230646446, blue: 0.9404756427, alpha: 1)
            self.ViewYear.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.ViewQuarter.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            globalindex =  true
        }
    }
    
    ///Action for 6 month subscription
    @IBAction func SemiAnnualPurchasesPressed(_ sender: Any) {
        if global == true{
            selectPlane = NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER
            selectIndex = 0
            plantype = 6
            UserDefaults.standard.set(selectIndex, forKey: "Index")
            self.ViewQuarter.backgroundColor = #colorLiteral(red: 0.6276120543, green: 0.1230646446, blue: 0.9404756427, alpha: 1)
            self.ViewYear.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.ViewMonths.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            globalindex = true
        }
    }
    
    ///Action for 1 Year subscription
    @IBAction func YearlyPurchasesPressed(_ sender: Any) {
        if global == true{
            selectPlane = NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL
            selectIndex = 2
            plantype = 12
            UserDefaults.standard.set(selectIndex, forKey: "Index")
            self.ViewYear.backgroundColor = #colorLiteral(red: 0.6276120543, green: 0.1230646446, blue: 0.9404756427, alpha: 1)
            self.ViewQuarter.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.ViewMonths.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            globalindex =  true
        }
        //                IAPHandler.shared.purchaseMyProduct(index: 0)
        //                self.purchase(strProductId: NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL)
    }
    
    
    ///purchase package with product id
    func purchase(strProductId : String) {
        //  NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct(strProductId, atomically: true) { result in
            
            //  NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                let downloads = purchase.transaction.downloads
                if !downloads.isEmpty {
                    SwiftyStoreKit.start(downloads)
                }
                
                UserDefaults.standard.set(true, forKey: "isPremium")
                UserDefaults.standard.setValue(purchase.productId, forKey: "currentSubscriptionPID\(Defaults[PDUserDefaults.UserID])")
                if purchase.productId == self.NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY{
                    Defaults[PDUserDefaults.isMonthlyPur] = true
                    Defaults[PDUserDefaults.isMonthlyPremium] = true
                    Defaults[PDUserDefaults.isPremium] = true
                    //self.AddSubscriptionService(subsType : "Monthly")
                }
                if purchase.productId == self.NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL{
                    Defaults[PDUserDefaults.isYearlyPur] = true
                    Defaults[PDUserDefaults.isYearlyPremium] = true
                    Defaults[PDUserDefaults.isPremium] = true
                    // self.AddSubscriptionService(subsType : "Annual")
                }else if purchase.productId == self.NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER{
                    Defaults[PDUserDefaults.isSemiAnnualPur] = true
                    Defaults[PDUserDefaults.isSemiAnnualPremium] = true
                    Defaults[PDUserDefaults.isPremium] = true
                    // self.AddSubscriptionService(subsType : "Semi annual")
                }
                
                print("Purchase Success: \(purchase.productId)")
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            if let alert = self.alertForPurchaseResult(result) {
                self.showAlert(alert)
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            print("Price: \(product)")
        }
    }
}

extension UIViewController {
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return nil
        case .error(let error):
            print("Purchase Failed: \(error.localizedDescription)")
            switch error.code {
            case .unknown: return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            default:
                return alertWithTitle("Purchase failed", message: (error as NSError).localizedDescription)
            }
        }
    }
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
}


///End of  NewInAppPurVc.swift
//    func AddSubscriptionService(subsType : String) {
//        //self.showCustomHUD();
//        let strUrl = AppUrl.AddSubscriptionUrl()
//        print(strUrl)
//
//        let date = Date()
//        let df = DateFormatter()
//        df.dateFormat = "dd-MM-yyyy"
//        let curDate = df.string(from: date)
//
//        let Param = ["user_id" : Defaults[PDUserDefaults.UserID] as AnyObject, "purchase_date" : curDate as AnyObject, "subscription_type" : subsType as AnyObject]
//
//        CommunicationManager.callShrinkPostServiceFormData(strUrl, param: Param ) { (result, data) in
//            print(data)
//            if(result == "success") {
//                self.hideCustomHUD()
//                let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
//                self.view.makeToast(strMsg)
//            }else if (result == "failure") {
//                self.hideCustomHUD()
//                let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
//                self.view.makeToast(strMsg)
//            }else if (result == "othercase"){
//                self.hideCustomHUD()
//                let strMsg = (data as AnyObject as! NSDictionary)["message"] as! String
//                self.view.makeToast(strMsg)
//            }else{
//                self.hideCustomHUD()
//                self.view.makeToast((data as? String)!)
//            }
//        }
//    }
