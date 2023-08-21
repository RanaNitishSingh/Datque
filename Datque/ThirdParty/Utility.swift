//
//  Utility.swift


import UIKit
import AVKit
import AVFoundation
import Photos
class Utility: NSObject
{
    
    class func convertImageToBase64(image: UIImage) -> String
    {
        let imageData = image.pngData()!
        
        return imageData.base64EncodedString()
    }
    
    static var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var overlayView = UIView();
    static var mainView = UIView();
    static var imgview = UIImageView();
    
    
    static var messageActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView();
    static var messageOverlayView = UIView();
    static var messageLoaingView = UIView();
    
    override init(){
        
    }
    static func dateToString(date: Date, withFormat:String, withTimezone:TimeZone = TimeZone.ReferenceType.default) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = withTimezone
        dateFormatter.dateFormat = withFormat
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
    static func showLoading(color: UIColor = UIColor.white){
        DispatchQueue.main.async {
            if(!activityIndicator.isAnimating)
            {
                self.mainView = UIView()
                self.mainView.frame = UIScreen.main.bounds
                self.mainView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                self.overlayView = UIView()
                self.activityIndicator = UIActivityIndicatorView()
                
                overlayView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                overlayView.backgroundColor =  UIColor.clear
                
                overlayView.clipsToBounds = true
                overlayView.layer.cornerRadius = 10
                //overlayView.layer.zPosition = 1
                
                // activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                //activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
                //activityIndicator.style = .whiteLarge
                
                imgview.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                imgview.center = CGPoint(x: overlayView.bounds.width/2, y: overlayView.bounds.height/2)
//                let jeremyGif = UIImage.gif(name: "progress")!
//
//                imgview.animationImages = jeremyGif.images
//                imgview.animationDuration = jeremyGif.duration
                // imgview.animationRepeatCount = 1
                imgview.startAnimating()
                // imgview.image = #imageLiteral(resourceName: "gmsg")
                //activityIndicator.addSubview(imgview)
                overlayView.addSubview(imgview)
                self.mainView.addSubview(overlayView)
                
                if APPDELEGATE.window?.viewWithTag(701) != nil
                {
                    UIApplication.shared.windows[0].bringSubviewToFront(mainView)
                }
                else
                {
                    if #available(iOS 13, *) {
                        overlayView.center = UIApplication.shared.windows.first { $0.isKeyWindow }!.center
                    } else {
                        overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    }
                    //  overlayView.center = (UIApplication.shared.keyWindow?.center)!
                    mainView.tag = 701
                    UIApplication.shared.windows[0].addSubview(mainView)
                    activityIndicator.startAnimating()
                }
            }
            
        }
        
    }
    
    
    static func hideLoading(){
        DispatchQueue.main.async {
            activityIndicator.stopAnimating();
            UIApplication.shared.keyWindow?.viewWithTag(701)?.removeFromSuperview()
        }
    }
    
    static func conteverDictToJson(dict:Dictionary<String, Any>) -> Void{
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        print(jsonString)
    }
    
    //MARK:
    //MARK: - Date Handler
    static func stringToString(strDate:String, fromFormat:String, toFormat:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC") ?? TimeZone(identifier: "UTC") ?? TimeZone.ReferenceType.default
        dateFormatter.dateFormat = fromFormat
        let currentDate = dateFormatter.date(from: strDate) ?? Date()
        dateFormatter.dateFormat =  toFormat
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        let currentDates = dateFormatter.string(from: currentDate)
        return currentDates
        
    }
    static func secondsToHoursMinutes(seconds : Int64) -> String
    {
        return "\(seconds / 3600) hr \((seconds % 3600) / 60) min"
    }
    static func minutToHoursMinutes(minut : Double) -> String {
        
        let seconds =  Int64.init(minut * 60)
        return "\(seconds / 3600) : \((seconds % 3600) / 60)"
    }
    
    static func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
    }
    
    static func convertSelectedDateToMilliSecond(serverDate:Date,strTimeZone:String)-> Int64
    {
        let timezone = TimeZone.init(identifier: strTimeZone) ?? TimeZone.ReferenceType.default
        
        
        let offSetMiliSecond = Int64(timezone.secondsFromGMT() * 1000)
        let timeSince1970 = Int64(serverDate.timeIntervalSince1970)
        let finalSelectedDateMilli =   Int64(  Int64(timeSince1970 * 1000) +  offSetMiliSecond)
        return finalSelectedDateMilli
    }
    static func stringToDate(strDate: String, withFormat:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.ReferenceType.default
        
        dateFormatter.dateFormat = withFormat
        return dateFormatter.date(from: strDate) ?? Date()
    }
    //MARK:
    //MARK: - Gesture Handler
    
    static func showCameraPermissionPopup() {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            NSLog("cameraAuthorizationStatus=denied")
            break
        case .authorized:
            NSLog("cameraAuthorizationStatus=authorized")
            break
        case .restricted:
            NSLog("cameraAuthorizationStatus=restricted")
            break
        case .notDetermined:
            NSLog("cameraAuthorizationStatus=notDetermined")
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                DispatchQueue.main.sync {
                    if granted {
                    } else {
                    }
                }
            }
        @unknown default:
            print("error")
        }
    }
    
    
    @available(iOS 14, *)
    static func showGalleryPermissionPopup() {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined: break
                // The user hasn't determined this app's access.
            case .restricted: break
                // The system restricted this app's access.
            case .denied: break
                // The user explicitly denied this app's access.
            case .authorized: break
                // The user authorized this app to access Photos data.
            case .limited: break
                // The user authorized this app for limited Photos access.
            @unknown default:
                fatalError()
            }
        }
    }
}



