//
//  NitIAPHandler.swift
//  SocialApp
//
//  Created by mac on 13/02/23.
//

import Foundation
import StoreKit

class MyStoreKitDelegate: NSObject {
    
    let monthlySubID = "DatqueyMonth"
    let quaterlySubID = "Datquehalfyearly"
    let yearlySubID = "DatqueAnnual"
    var products: [String: SKProduct] = [:]
    
    func fetchProducts() {
        let productIDs = Set([monthlySubID,quaterlySubID, yearlySubID])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func purchase(productID: String) {
        if let product = products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension MyStoreKitDelegate: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            print("Valid: \(product)")
            products[product.productIdentifier] = product
        }
    }
}
