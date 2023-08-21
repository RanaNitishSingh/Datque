//
//  MyExtensions.swift
//  ADA
//
//  Created by mac on 12/11/19.
//  Copyright © 2019 shrinkcom software pvt ltd. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}


struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


extension UIColor {
    convenience init?(hexaRGB: String, alpha: CGFloat = 1) {
        var chars = Array(hexaRGB.hasPrefix("#") ? hexaRGB.dropFirst() : hexaRGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }
        case 6: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: alpha)
    }

    convenience init?(hexaRGBA: String) {
        var chars = Array(hexaRGBA.hasPrefix("#") ? hexaRGBA.dropFirst() : hexaRGBA[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[0...1]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[6...7]), nil, 16)) / 255)
    }

    convenience init?(hexaARGB: String) {
        var chars = Array(hexaARGB.hasPrefix("#") ? hexaARGB.dropFirst() : hexaARGB[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars.append(contentsOf: ["F","F"])
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}






extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}


extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
}

extension UIImage {

    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        var newRect = CGRect(origin: .zero, size: CGSize(width: size.width*percentage, height: size.height*percentage))
        UIGraphicsBeginImageContextWithOptions(newRect.size, true, 1)
        self.draw(in: newRect)
        defer {UIGraphicsEndImageContext()}
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resizeTo(MB: Double) -> UIImage? {
        guard let fileSize = self.pngData()?.count else {return nil}
        let fileSizeInMB = CGFloat(fileSize)/(1024.0*1024.0)//form bytes to MB
        let percentage = 1/fileSizeInMB
        return resize(withPercentage: percentage)
    }
    
}


extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
          var width: CGFloat
          var height: CGFloat
          var newImage: UIImage

          let size = self.size
          let aspectRatio =  size.width/size.height

          switch contentMode {
              case .scaleAspectFit:
                  if aspectRatio > 1 {                            // Landscape image
                      width = dimension
                      height = dimension / aspectRatio
                  } else {                                        // Portrait image
                      height = dimension
                      width = dimension * aspectRatio
                  }

          default:
              fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
          }

          if #available(iOS 10.0, *) {
              let renderFormat = UIGraphicsImageRendererFormat.default()
              renderFormat.opaque = opaque
              let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
              newImage = renderer.image {
                  (context) in
                  self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
              }
          } else {
              UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                  self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                  newImage = UIGraphicsGetImageFromCurrentImageContext()!
              UIGraphicsEndImageContext()
          }

          return newImage
      }
  }


extension UIImage {
    
  func resizeImage(targetSize: CGSize) -> UIImage {
    let size = self.size
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
    UIGraphicsEndImageContext()

    return newImage!
  }
    
}

extension UIImage {
    
    func normalizedImage() -> UIImage {
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)

        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }

}


extension UITextView {
    func resizeForHeight(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}


extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
private var kAssociationKeyMaxLength: Int = 0
extension UITextField {
@IBInspectable var maxLength: Int {
       get {
           if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
               return length
           } else {
               return Int.max
           }
       }
       set {
           objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
           self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
       }
   }

   func isInputMethod() -> Bool {
       if let positionRange = self.markedTextRange {
           if let _ = self.position(from: positionRange.start, offset: 0) {
               return true
           }
       }
       return false
   }


@objc func checkMaxLength(textField: UITextField) {

       guard !self.isInputMethod(), let prospectiveText = self.text,
           prospectiveText.count > maxLength
       else {
           return
       }

       let selection = selectedTextRange
       let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
       text = prospectiveText.substring(to: maxCharIndex)
       selectedTextRange = selection
   }

}
extension CGRect {
    var center: CGPoint { return CGPoint(x: midX, y: midY) }
}

extension UIView {

    /** This is the function to get subViews of a view of a particular type
*/
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }


/** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
        func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
            var all = [T]()
            func getSubview(view: UIView) {
                if let aView = view as? T{
                all.append(aView)
                }
                guard view.subviews.count>0 else { return }
                view.subviews.forEach{ getSubview(view: $0) }
            }
            getSubview(view: self)
            return all
        }
    }


extension UIImage {
    func getExifData() -> CFDictionary? {
        var exifData: CFDictionary? = nil
        if let data = self.jpegData(compressionQuality: 1.0) {
            data.withUnsafeBytes {(bytes: UnsafePointer<UInt8>)->Void in
                if let cfData = CFDataCreate(kCFAllocatorDefault, bytes, data.count) {
                    let source = CGImageSourceCreateWithData(cfData, nil)
                    exifData = CGImageSourceCopyPropertiesAtIndex(source!, 0, nil)
                }
            }
        }
        return exifData
    }
}


extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}


extension UIImage {

    func saveToDocuments(filename:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }

}


extension UIApplication {
    /// Checks if view hierarchy of application contains `UIRemoteKeyboardWindow` if it does, keyboard is presented
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}

extension String {

    var numericValue: NSNumber? {

        //init number formater
        let numberFormater = NumberFormatter()

        //check if string is numeric
        numberFormater.numberStyle = .decimal

        guard let number = numberFormater.number(from: self.lowercased()) else {

            //check if string is spelled number
            numberFormater.numberStyle = .spellOut

            //change language to spanish
            //numberFormater.locale = Locale(identifier: "es")

            return numberFormater.number(from: self.lowercased())
        }

        // return converted numeric value
        return number
    }
}



//if UIApplication.shared.isKeyboardPresented {
//     print("Keyboard presented")
//} else {
//     print("Keyboard is not presented")
//}
