//
//  AppDelegate.swift
//  SocialApp
//
//  Created by mac on 10/12/21.
//

import SwiftyStoreKit
import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseMessaging
import GooglePlaces
import FirebaseStorage
import FirebaseDatabase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , MessagingDelegate, UNUserNotificationCenterDelegate {
    
    var isDebugMode = Bool()
    var window: UIWindow?
    @objc var navigationController: UINavigationController? = nil
    @objc var mainStoryboard : UIStoryboard? = nil
    
//    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_Free = "Key_free"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL = "DatqueAnnual"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER = "Datquehalfyearly"
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY = "DatqueyMonth"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        AIzaSyC1mqYWzor-LYneOzNgdOzHNr8BpoI5-0A
       // "AIzaSyBwezfsiSWnqPJ9O2nNOw-QRLNXJFgHZJE"
        GMSPlacesClient.provideAPIKey("AIzaSyANSQ7dONtZfOt7PwuLxQ_6Jy3CLDlvHgc")
       // GMSServices.provideAPIKey("AIzaSyC1mqYWzor-LYneOzNgdOzHNr8BpoI5-0A")
        //google key for get location finder
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
       
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
       
        application.registerForRemoteNotifications()
        getDate()
        registerForPushNotifications()        
        //MARK:INAPP_SETUP
        #if DEBUG
        isDebugMode = true
        #endif
        
        self.setupIAP()
        if !isDebugMode {
            self.verifyMontlySubscription()
            self.verifySixMontlySubscription()
            self.verifyYearlySubscription()
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "Datque")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {                UIApplication.shared.registerForRemoteNotifications()
            }
            print("Notification settings: \(settings)")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        let userInfo:[AnyHashable:Any] =  notification.request.content.userInfo
        let call_type = (userInfo[AnyHashable("action_type")]) as? String
        print("call_type", userInfo)
        if call_type == "video" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ChatAtLawyerNotification"), object: userInfo)
        }else if call_type == "audio" {
           NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ChatAtLawyerNotification"), object: userInfo)
            
        }else{}
    }
    
    //Notification Tapped by user//
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let call_type = (userInfo[AnyHashable("action_type")]) as? String
        if call_type == "video" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ChatAtLawyerNotification"), object: userInfo)
        }else if call_type == "audio" {
            print("Hello notification")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"ChatAtLawyerNotification"), object: userInfo)
            
        }else{}
        print(response.notification.request.content.categoryIdentifier)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("Hello Foreg Notification", userInfo)
     
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if userInfo.count !=  0       {
            if let silentPayloadData = (userInfo[AnyHashable("silentPayloadData")]) as? NSString {
                
                if silentPayloadData == "silentNotification" {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"CallEndByUser"), object: userInfo)
                }
            }
        }
        print("Hello BG Notification")
        
        if Auth.auth().canHandleNotification(userInfo) {
                completionHandler(.noData)
                return
            }
       
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken = \(fcmToken!)")
        Defaults[PDUserDefaults.FCMToken] = "\(fcmToken!)"
        print("token_is_here_FCM",Defaults[PDUserDefaults.FCMToken])
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        
        // Pass device token to auth.
        let firebaseAuth = Auth.auth() 

        //At development time we use .sandbox
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail To Register Remote Notification = \(error)")
    }
    
    func setupIAP() {
        print("inapppurchase")
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("transactionState:\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break // do nothing
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in

            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    func verifyYearlySubscription() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "f3ee128e1c0e4eedacc1a44dfe31eb7e")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = self.NON_CONSUMABLE_PURCHASE_PRODUCT_ID_ANNUAL//"com.bpa.yearly"
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    Defaults[PDUserDefaults.isYearlyPur] = true
                    Defaults[PDUserDefaults.isYearlyPremium] = true
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    Defaults[PDUserDefaults.isYearlyPur] = false
                    Defaults[PDUserDefaults.isYearlyPremium] = true
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    Defaults[PDUserDefaults.isYearlyPur] = false
                    Defaults[PDUserDefaults.isYearlyPremium] = false
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    func verifySixMontlySubscription() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "f3ee128e1c0e4eedacc1a44dfe31eb7e")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = self.NON_CONSUMABLE_PURCHASE_PRODUCT_ID_QUARTER//"com.bpa.semiannual"
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    Defaults[PDUserDefaults.isSemiAnnualPur] = true
                    Defaults[PDUserDefaults.isSemiAnnualPremium] = true
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    Defaults[PDUserDefaults.isSemiAnnualPur] = false
                    Defaults[PDUserDefaults.isSemiAnnualPremium] = true
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    Defaults[PDUserDefaults.isSemiAnnualPur] = false
                    Defaults[PDUserDefaults.isSemiAnnualPremium] = false
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    
    func verifyMontlySubscription() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "f3ee128e1c0e4eedacc1a44dfe31eb7e")
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = self.NON_CONSUMABLE_PURCHASE_PRODUCT_ID_MONTHLY
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                    Defaults[PDUserDefaults.isMonthlyPur] = true
                    Defaults[PDUserDefaults.isMonthlyPremium] = true
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                    Defaults[PDUserDefaults.isMonthlyPur] = false
                    Defaults[PDUserDefaults.isMonthlyPremium] = true
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                    Defaults[PDUserDefaults.isMonthlyPur] = false
                    Defaults[PDUserDefaults.isMonthlyPremium] = false
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
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
    
    
   
    
}
