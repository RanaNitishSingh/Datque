//
//  IAPHandler.swift
//  Joy
//
//  Created by Jesus Nieves on 10/10/18.
//  Copyright © 2018 Jesus Nieves. All rights reserved.
//

//
//  IAPHandler.swift
//
//  Created by Dejan Atanasov on 13/07/2017.
//  Copyright © 2017 Dejan Atanasov. All rights reserved.
//
import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    case failed
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        case .failed: return "There was a problem trying to make the purchase, try it later!"
        }
    }
}

var isPaymentSuccess = false
class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
   // let NON_CONSUMABLE_PURCHASE_PRODUCT_ID = "ADAPhotoAAA"
   
    
//    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_Free = "key_free"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL = "DatQueoneyear"
     let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER = "DatQuesixmonth"
     let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY = "DatQueonemonth"
    
   // let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_Free = "key_free"
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    var purchaseProductsBlock: (([SKProduct]) -> Void)?
    
    var current =  true
    var threedays =  true
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int){
        print("Product count = \(iapProducts.count)")
       if iapProducts.count == 0 { return }
        
      if self.canMakePurchases() {
            let product = iapProducts[index]
            productID = product.productIdentifier
            let payment = SKPayment(product: product)
          
            SKPaymentQueue.default().add(payment)
            SKPaymentQueue.default().add(self)
            print(product)
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
           
            
        } else {
            purchaseStatusBlock?(.disabled)
        }
        
    }
    
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        // Put here your IAP Products ID's
       // let productIdentifiers = NSSet(objects:            NON_CONSUMABLE_PURCHASE_PRODUCT_ID_Free
      // )
        
       let productIdentifiers = NSSet(objects:            NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL,NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER,NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY
      )
        print(productIdentifiers, "productIdentifiers")
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
}


extension IAPHandler : SKProductsRequestDelegate, SKPaymentTransactionObserver {
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        print(response.products , "responseproduct")
        self.purchaseProductsBlock?(response.products)
//        DispatchQueue.main.async {
//            self.purchaseProductsBlock?(response.products)
//
//        }
        if (response.products.count > 0) {
            iapProducts = response.products
            var strPackage = ""
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
                strPackage = strPackage + "\n" + "\(product.localizedDescription)\nfor just \(price1Str!)"
            }
        }
    }
    
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    UserDefaults.standard.set(true, forKey: "isPremium")
                    UserDefaults.standard.setValue(productID, forKey: "currentSubscriptionPID\(Defaults[PDUserDefaults.UserID])")
                    selectdate()
                    isPaymentSuccess = true
                    current = false
                    threedays =  false
                    UserDefaults.standard.set(isPaymentSuccess, forKey: "Payment")
                    UserDefaults.standard.set(current, forKey: "current")
                    UserDefaults.standard.set(threedays, forKey: "threedays")
                    if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL{
                        Defaults[PDUserDefaults.isYearlyPur] = true
                        Defaults[PDUserDefaults.isYearlyPremium] = true
                        Defaults[PDUserDefaults.isPremium] = true
                    }else if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER{
                        Defaults[PDUserDefaults.isSemiAnnualPur] = true
                        Defaults[PDUserDefaults.isSemiAnnualPremium] = true
                        Defaults[PDUserDefaults.isPremium] = true
                    }else if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY{
                        Defaults[PDUserDefaults.isMonthlyPur] = true
                        Defaults[PDUserDefaults.isMonthlyPremium] = true
                        Defaults[PDUserDefaults.isPremium] = true
                    }
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    global = true
                    print("true")
                    break
                case .failed:
                    print("failed")
                    
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    purchaseStatusBlock?(.failed)
                    global = true
                    print("true")
                    break                    
                case .restored:
                    print("restored")
                    UserDefaults.standard.set(true, forKey: "isPremium")
                    UserDefaults.standard.setValue(productID, forKey: "currentSubscriptionPID\(Defaults[PDUserDefaults.UserID])")
                    
                    if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL{
                        Defaults[PDUserDefaults.isYearlyPur] = true
                        Defaults[PDUserDefaults.isYearlyPremium] = true
                        Defaults[PDUserDefaults.isPremium] = true
                    }else if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER{
                        Defaults[PDUserDefaults.isSemiAnnualPur] = true
                        Defaults[PDUserDefaults.isSemiAnnualPremium] = true
                        Defaults[PDUserDefaults.isPremium] = true
                    }else if productID == NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY{
                        Defaults[PDUserDefaults.isMonthlyPur] = true
                        Defaults[PDUserDefaults.isMonthlyPremium] = true
                        Defaults[PDUserDefaults.isPremium] = true
                    }
                    Defaults[PDUserDefaults.isPremium] = true
                    UserDefaults.standard.set(true, forKey: "isPremium")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                     global = true
                    print("true")
                    break
                    
                default: break
                }}}
    }
    func  selectdate(){

        let index = UserDefaults.standard.integer(forKey: "Index")


        if ( index ==  1) == true{
            let todaysDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy  "
            let DateInFormat1 = dateFormatter.string(from: todaysDate as Date)
            print(DateInFormat1)
            UserDefaults.standard.set(DateInFormat1, forKey: "StartingDate")

            let tomorrow = Calendar.current.date(byAdding: .month, value: 1, to: todaysDate as Date)
            let nextTimeDate1 = dateFormatter.string(from: tomorrow! )
            print(nextTimeDate1)
            UserDefaults.standard.set(nextTimeDate1, forKey: "ExpireDate")
            guard let timeInterval = tomorrow?.timeIntervalSince1970 else { return }
            let myInt = Int(timeInterval)
            let nitDate1 = myInt * 1000
            print(nitDate1)

        }
        if ( index ==  2) == true{
            let todaysDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy  "
            let DateInFormat2 = dateFormatter.string(from: todaysDate as Date)
            print(DateInFormat2)
            UserDefaults.standard.set(DateInFormat2, forKey: "StartingDate")

            let tomorrow = Calendar.current.date(byAdding: .month, value: 6, to: todaysDate as Date)
            let nextTimeDate2 = dateFormatter.string(from: tomorrow! )
            print(nextTimeDate2)
            UserDefaults.standard.set(nextTimeDate2, forKey: "ExpireDate")
            guard let timeInterval = tomorrow?.timeIntervalSince1970 else { return }
            let myInt = Int(timeInterval)
            let nitDate2 = myInt * 1000
            print(nitDate2)

        }
        if ( index ==  0) == true{
            let todaysDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "d MMM yyyy  "
            let DateInFormat3 = dateFormatter.string(from: todaysDate as Date)
            print(DateInFormat3)
            UserDefaults.standard.set(DateInFormat3, forKey: "StartingDate")

            let tomorrow = Calendar.current.date(byAdding: .year, value: 1, to: todaysDate as Date)
            let nextTimeDate3 = dateFormatter.string(from: tomorrow! )
            print(nextTimeDate3)
            UserDefaults.standard.set(nextTimeDate3, forKey: "ExpireDate")
            guard let timeInterval = tomorrow?.timeIntervalSince1970 else { return }
            let myInt = Int(timeInterval)
            let nitDate3 = myInt * 1000
            print(nitDate3)

        }
        
    }
}
