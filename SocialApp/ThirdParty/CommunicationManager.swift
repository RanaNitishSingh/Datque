//
//  CommunicationManager.swift
//  EatApp
//
//  Created by Mac on 4/8/17.
//  Copyright © 2017 Ebabu IT Services. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

class CommunicationManager : NSObject {
    
    class func callSGetService(_ urlString: String, param : [String: AnyObject]?, header : [String: String]?, completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.request(urlString, method: .get , parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    print(response);
                    let json = JSON(response.result.value!)
                    
                    if json.dictionaryValue["ResultCode"]?.intValue == 200  {
                        completion("success", json.dictionaryObject as AnyObject)
                        
                    } else {
                        completion("error", (json.dictionaryValue["ResultMessage"]?.stringValue)! as AnyObject)
                    }
                }
                break
                
                
            case .failure(_):
                if response.result.error != nil{
                    print((response.result.error?.localizedDescription)! as String)
                    completion("error", "Error in fetching data" as AnyObject)
                }
                break
            }
        }
    }
    
    class func callSSGetService(_ urlString: String, param : [String: AnyObject]?, header : [String: String]?, completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.request(urlString, method: .get , parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    //print(response);
                    let json = JSON(response.result.value!)
                    print(json)
                    if json.dictionaryValue["success"] == "1" || json.dictionaryValue["success"] == true || json.dictionaryValue["success"] == "true" || json.dictionaryValue["success"] == "SUCCESS" {
                        completion("success", json.dictionaryObject as AnyObject)
                    } else if json.dictionaryValue["success"] == "0"  || json.dictionaryValue["success"] == false {
                        if json.dictionaryValue["message"] == "Invalid Token" {
                            //let error = NSError(domain:"Invalid Token", code:121, userInfo:nil)
                            completion("failure", json.dictionaryObject as AnyObject)

                        } else {
                            completion("error", (json.dictionaryValue["message"]?.stringValue)! as AnyObject)
                        }
                    } else if json.dictionaryValue["status"] == "2"  {
                        completion("other", json.dictionaryObject as AnyObject)
                    } else {
                        completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
                        //completion("error", json.dictionaryObject as AnyObject)
                    }
                }
                break
                
                
            case .failure(_):
                if response.result.error != nil{
                    print((response.result.error?.localizedDescription)! as String)
                    completion("error", "Error in fetching data" as AnyObject)
                }
                break
            }
        }
    }
    
    class func callGetService(_ urlString: String, param : [String: AnyObject]?, header : [String: String]?, completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.request(urlString, method: .get , parameters: param, encoding: JSONEncoding.default, headers: header).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    //print(response);
                    let json = JSON(response.result.value!)
                    print(json)
                    if json.dictionaryValue["code"] == 200 {
                        completion("success", json.dictionaryObject as AnyObject)
                    } else if json.dictionaryValue["code"] == 201 {
                        completion("failure", json.dictionaryObject as AnyObject)
                        /*if json.dictionaryValue["msg"] == "Invalid Token" {
                            //let error = NSError(domain:"Invalid Token", code:121, userInfo:nil)
                            completion("failure", json.dictionaryObject as AnyObject)
                        } else {
                            completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
                        }*/
                    }else {
                        completion("error", (json.dictionaryValue["msg"]!["error_lable"].stringValue) as AnyObject)
                        //completion("error", json.dictionaryObject as AnyObject)
                    }
                }
                break
                
            case .failure(_):
                if response.result.error != nil{
                    print((response.result.error?.localizedDescription)! as String)
                   completion("error", "Error in fetching data" as AnyObject)
                }
                break
            }
        }
    }
    
    
    class func callPostService(_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default , headers: ["Content-Type" : "application/json"])
            .responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        print(response);
                        let json = JSON(response.result.value!)
                        
                        if json.dictionaryValue["status"] == "success" || json.dictionaryValue["status"] == "failed" {
                            completion("success", json.dictionaryObject as AnyObject)
                            
                        } else {
                            completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
                        }
                    }
                    break
                    
                case .failure(_):
                    if response.result.error != nil{
                        print((response.result.error?.localizedDescription)! as String)
                        completion("error", "Error in fetching data" as AnyObject)
                    }
                    break
                }
        }
    }
    
    class func callPostServiceFormData (_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
        }, to: urlString, method: .post,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    
                    if response.result.value != nil {
                        print(response);
                        let json = JSON(response.result.value!)
                        if json.dictionaryValue["ResultCode"]?.intValue == 200  {
                            completion("success", json.dictionaryObject as AnyObject)
                        } else if json.dictionaryValue["status"] == "false" {
                            
                            if json.dictionaryValue["message"] == "Invalid Token" {
                                
                            } else {
                                completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
                            }
                        } else {
                            completion("error", (json.dictionaryValue["ResultMessage"]?.stringValue)! as AnyObject)
                        }
                    }
                }
                break
                
            case .failure(let encodingError):
                print("error:\(encodingError)")
                break
                
            }
        })
    }
    
    
    class func callPostServiceWithHeader(_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default , headers: nil)
            .responseJSON { (response:DataResponse<Any>) in
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil {
                        print(response);
                        let json = JSON(response.result.value!)
                        
                        if json.dictionaryValue["status"] == "success" || json.dictionaryValue["status"] == "true"{
                            completion("success", json.dictionaryObject as AnyObject)
                            
                        } else  if json.dictionaryValue["status"] == "false" {
                            
                            if json.dictionaryValue["message"] == "Invalid Token" {
                                
                            } else {
                                completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
                            }
                            
                        } else {
                            completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
                        }
                    }
                    break
                    
                case .failure(_):
                    if response.result.error != nil {
                        print((response.result.error?.localizedDescription)! as String)
                        completion("error", "Error in fetching data" as AnyObject)
                    }
                    break
                }
        }
    }
    
    class func callPostServiceFormDataWithHeader(_ urlString: String, param : [String: AnyObject]?, header : [String: String]? , completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
        }, to: urlString, method: .post, headers: header,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    
                    if response.result.value != nil {
                        print(response);
                        let json = JSON(response.result.value!)
                        if json.dictionaryValue["ResultCode"]?.intValue == 200 {
                            completion("success", json.dictionaryObject as AnyObject)
                        } else if json.dictionaryValue["status"] == "false" {
                            
                            if json.dictionaryValue["message"] == "Invalid Token" {
                            } else {
                                completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
                            }
                        } else {
                            completion("error", (json.dictionaryValue["ResultMessage"]?.stringValue)! as AnyObject)
                        }
                    } else {
                        completion("error", ("data not found") as AnyObject)
                    }
                }
                break
            case .failure(let encodingError):
                print("error:\(encodingError)")
                break                
            }
        })
    }
    
    //MARK: Upload Image Data
    class func uploadImageAndData(_ strURL : String, parameters : [String:AnyObject], uploadDataArray : NSMutableArray, imageKey: String, header : [String: String]?,completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            if uploadDataArray.count > 0{
                for i in 0...uploadDataArray.count-1 {
                    let filename : String = "image\(i).png"
                    multipartFormData.append(uploadDataArray[i] as! Data, withName: imageKey, fileName: filename , mimeType: "image/png")
                }
            }
            
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
            
        }, to: strURL, method: .post, headers: header, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    
                    if response.result.value != nil {
                        print(response);
                        let json = JSON(response.result.value!)
                        
                        if json.dictionaryValue["ResultCode"]?.intValue == 200 {
                            completion("success", json.dictionaryObject as AnyObject)
                        }else  if json.dictionaryValue["status"] == "1" || json.dictionaryValue["status"] == true || json.dictionaryValue["status"] == "true" || json.dictionaryValue["message"] == "SUCCESS" {
                            
                            completion("success", json.dictionaryObject as AnyObject)
                        }  else  if json.dictionaryValue["status"] == "false" || json.dictionaryValue["status"] == false || json.dictionaryValue["status"] == "0" || json.dictionaryValue["message"] == "FAILURE" {
                            
                            if json.dictionaryValue["message"] == "Invalid Token" {
                            } else {
                                completion("error", (json.dictionaryValue["message"]?.stringValue)! as AnyObject)
                            }
                        } else {
                            completion("error", (json.dictionaryValue["message"]?.stringValue)! as AnyObject)
                        }
                    }
                }
                break
            case .failure(let encodingError):
                print("error:\(encodingError)")
                break
            }
        })
    }
    
    
    
    class func callMyPostServiceFormData (_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
        }, to: urlString, method: .post,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    print("urlString = \(urlString)")
                    //print(response)
                    
                    if response.result.value != nil {
                        //print(response);
                        let json = JSON(response.result.value!)
                        print(json)
                        if json.dictionaryValue["status"] == "1" || json.dictionaryValue["status"] == true || json.dictionaryValue["status"] == "true" || json.dictionaryValue["message"] == "SUCCESS" {
                            completion("success", json.dictionaryObject as AnyObject)
                        } else if json.dictionaryValue["status"] == "0"  || json.dictionaryValue["status"] == false || json.dictionaryValue["status"] == "false" {
                            if json.dictionaryValue["message"] == "Invalid Token" {
                                let error = NSError(domain:"Invalid Token", code:121, userInfo:nil)
                                completion("failure", error.localizedDescription as AnyObject)

                            } else {
                                completion("failure", json.dictionaryObject as AnyObject)
                            }
                        } else if json.dictionaryValue["status"] == "2"  {
                            completion("other", json.dictionaryObject as AnyObject)
                        } else {
                            completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
                            //completion("error", json.dictionaryObject as AnyObject)
                        }
                    }else{
                        completion("error", response.result.error?.localizedDescription as AnyObject)
                    }
                }
                break
            case .failure(let encodingError):
                print("error:\(encodingError)")
                completion("failure", encodingError.localizedDescription as AnyObject )
                break
            }
        })
    }
    
    class func callNewPostServiceFormData (_ urlString: String, header : [String: String]?, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
        }, to: urlString, method: .post, headers: header,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    print("urlString = \(urlString)")
                    print(response)
                    
                    if response.result.value != nil {
                        //print(response);
                        let json = JSON(response.result.value!)
                        print(json)
                        if json.dictionaryValue["success"] == "1" || json.dictionaryValue["success"] == true || json.dictionaryValue["success"] == "true" || json.dictionaryValue["success"] == "SUCCESS" {
                            completion("success", json.dictionaryObject as AnyObject)
                        } else if json.dictionaryValue["success"] == "0"  || json.dictionaryValue["success"] == false {
                            if json.dictionaryValue["message"] == "Invalid Token" {
                                //let error = NSError(domain:"Invalid Token", code:121, userInfo:nil)
                                completion("failure", json.dictionaryObject as AnyObject)

                            } else {
                                completion("error", (json.dictionaryValue["message"]?.stringValue)! as AnyObject)
                            }
                        } else if json.dictionaryValue["status"] == "2"  {
                            completion("other", json.dictionaryObject as AnyObject)
                        } else {
                            completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
                            //completion("error", json.dictionaryObject as AnyObject)
                        }
                    }else{
                        completion("error", response.result.error?.localizedDescription as AnyObject)
                    }
                }
                break
            case .failure(let encodingError):
                print("error:\(encodingError)")
                completion("failure", encodingError.localizedDescription as AnyObject )
                break
            }
        })
    }
    
    class func callShrinkPostServiceFormData (_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
        }, to: urlString, method: .post,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    print("urlString = \(urlString)")
                    print(response)
                    
                    if response.result.value != nil {
                        //print(response);
                        let json = JSON(response.result.value!)
                        print(json)
                        if json.dictionaryValue["result"] == "1" || json.dictionaryValue["result"] == true || json.dictionaryValue["result"] == 1 || json.dictionaryValue["result"] == "SUCCESS" ||
                        json.dictionaryValue["status"] == 1 {
                            completion("success", json.dictionaryObject as AnyObject)
                        } else if json.dictionaryValue["result"] == "0" || json.dictionaryValue["result"] == false || json.dictionaryValue["result"] == 0 || json.dictionaryValue["result"] == "FAILURE" || json.dictionaryValue["status"] == 0  {
                            completion("failure", json.dictionaryObject as AnyObject)
                        } else {
                            completion("othercase", json.dictionaryObject as AnyObject)
                        }
                    }else{
                        completion("error", response.result.error?.localizedDescription as AnyObject)
                    }
                }
                break
            case .failure(let encodingError):
                print("error:\(encodingError)")
                completion("failure", encodingError.localizedDescription as AnyObject )
                break
            }
        })
    }
    
    
    class func callSPostServiceFormData (_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
           
           Alamofire.upload(multipartFormData: { multipartFormData in
               for (key, value) in param! {
                   multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
               }
           }, to: urlString, method: .post,
              
              encodingCompletion: { encodingResult in
               switch encodingResult {
               case .success( let upload,_,_):
                   upload.responseJSON {
                       response in
                       print("urlString = \(urlString)")
                       print(response)
                       
                       if response.result.value != nil {
                           //print(response);
                           let json = JSON(response.result.value!)
                           print(json)
                           if json.dictionaryValue["response"] == "1" || json.dictionaryValue["response"] == true || json.dictionaryValue["response"] == 1 || json.dictionaryValue["response"] == "SUCCESS" {
                               completion("success", json.dictionaryObject as AnyObject)
                           } else if json.dictionaryValue["response"] == "0" || json.dictionaryValue["response"] == false || json.dictionaryValue["response"] == 0 || json.dictionaryValue["response"] == "FAILURE"   {
                               completion("failure", json.dictionaryObject as AnyObject)
                           } else {
                               completion("othercase", json.dictionaryObject as AnyObject)
                           }
                       }else{
                           completion("error", response.result.error?.localizedDescription as AnyObject)
                       }
                   }
                   break
               case .failure(let encodingError):
                   print("error:\(encodingError)")
                   completion("failure", encodingError.localizedDescription as AnyObject )
                   break
               }
           })
       }
    
       class func callDoktorPostServiceFormData (_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param! {
                multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
            }
        }, to: urlString, method: .post,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success( let upload,_,_):
                upload.responseJSON {
                    response in
                    print("urlString = \(urlString)")
                    print(response)
                    
                    if response.result.value != nil {
                        //print(response);
                        let json = JSON(response.result.value!)
                        print(json)
                        if json.dictionaryValue["responce"] == "1" || json.dictionaryValue["responce"] == true || json.dictionaryValue["responce"] == 1 || json.dictionaryValue["responce"] == "SUCCESS" {
                            completion("success", json.dictionaryObject as AnyObject)
                        } else if json.dictionaryValue["responce"] == "0" || json.dictionaryValue["responce"] == false || json.dictionaryValue["responce"] == 0 || json.dictionaryValue["responce"] == "FAILURE"   {
                            completion("failure", json.dictionaryObject as AnyObject)
                        } else {
                            completion("othercase", json.dictionaryObject as AnyObject)
                        }
                    }else{
                        completion("error", response.result.error?.localizedDescription as AnyObject)
                    }
                }
                break
            case .failure(let encodingError):
                print("error:\(encodingError)")
                completion("failure", encodingError.localizedDescription as AnyObject )
                break
            }
        })
    }
    
}


/*
 class func callGetService(_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
 
 let auth = ["Authorization": "consumer_key=ck_7ac58f60e1d6b70aca1f8dff733d02c0c5a77331,consumer_key=cs_5b3be20a3ea4536cc66c610030ca871368460298","Content-Type":"application/json; charset=utf-8"]
 
 //Alamofire.Request.authenticate(<#T##Request#>)
 Alamofire.request(urlString, method: .get , parameters: param, encoding: JSONEncoding.default, headers: auth).responseJSON { (response:DataResponse<Any>) in
 
 switch(response.result) {
 case .success(_):
 if response.result.value != nil {
 print(response);
 let json = JSON(response.result.value!)
 
 if json.dictionaryValue["message"] == "SUCCESS" || json.dictionaryValue["code"]?.intValue == 100 {
 completion("success", json.dictionaryObject as AnyObject)
 
 } else {
 completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
 }
 }
 break
 
 case .failure(_):
 if response.result.error != nil{
 print((response.result.error?.localizedDescription)! as String)
 completion("error", "Error in fetching data" as AnyObject)
 }
 break
 }
 }
 }
 
 
 class func callPostService(_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
 
 Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default , headers: ["Content-Type" : "application/json"])
 .responseJSON { (response:DataResponse<Any>) in
 
 switch(response.result) {
 case .success(_):
 if response.result.value != nil {
 print(response);
 let json = JSON(response.result.value!)
 
 if json.dictionaryValue["message"] == "SUCCESS" || json.dictionaryValue["code"]?.intValue == 100 {
 completion("success", json.dictionaryObject as AnyObject)
 
 }else if json.dictionaryValue["message"] == "FAILURE" && json.dictionaryValue["response"]!["error"].stringValue == "MObile_NO_IS_ALREADY_EXISTS"{
 completion("MobileError", json.dictionaryObject as AnyObject)
 }else if json.dictionaryValue["status"]?.boolValue == false{
 completion("InvalidNumber", json.dictionaryValue as AnyObject)
 }
 else {
 completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
 }
 }
 break
 
 case .failure(_):
 if response.result.error != nil{
 print((response.result.error?.localizedDescription)! as String)
 completion("error", "Error in fetching data" as AnyObject)
 }
 break
 }
 }
 }
 
 class func callPostServiceFormData (_ urlString: String, param : [String: AnyObject]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
 
 Alamofire.upload(multipartFormData: { multipartFormData in
 for (key, value) in param! {
 multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
 }
 }, to: urlString, method: .post,
 
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success( let upload,_,_):
 upload.responseJSON {
 response in
 
 if response.result.value != nil {
 print(response);
 let json = JSON(response.result.value!)
 if json.dictionaryValue["status"] == "success" || json.dictionaryValue["status"] == "true" || json.dictionaryValue["message"] == "SUCCESS" {
 completion("success", json.dictionaryObject as AnyObject)
 } else if json.dictionaryValue["status"] == "false" {
 
 if json.dictionaryValue["message"] == "Invalid Token" {
 
 } else {
 completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
 }
 } else {
 completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
 }
 }
 }
 break
 
 case .failure(let encodingError):
 print("error:\(encodingError)")
 break
 
 }
 })
 }
 
 
 class func callPostServiceWithHeader(_ urlString: String, param : [String: AnyObject]?, header : [String: String]?,  completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
 
 Alamofire.request(urlString, method: .post, parameters: param, encoding: JSONEncoding.default , headers: header)
 .responseJSON { (response:DataResponse<Any>) in
 
 switch(response.result) {
 case .success(_):
 if response.result.value != nil {
 print(response);
 let json = JSON(response.result.value!)
 
 if json.dictionaryValue["status"] == "success" || json.dictionaryValue["status"] == "true" || json.dictionaryValue["message"] == "SUCCESS" {
 completion("success", json.dictionaryObject as AnyObject)
 
 } else  if json.dictionaryValue["status"] == "false" {
 
 if json.dictionaryValue["message"] == "Invalid Token" {
 
 } else {
 completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
 }
 
 } else {
 completion("error", (json.dictionaryValue["message"]?.stringValue) as AnyObject)
 }
 }
 break
 
 case .failure(_):
 if response.result.error != nil {
 print((response.result.error?.localizedDescription)! as String)
 completion("error", "Error in fetching data" as AnyObject)
 }
 break
 }
 }
 }
 
 class func callPostServiceFormDataWithHeader(_ urlString: String, param : [String: AnyObject]?, header : [String: String]?, completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
 
 Alamofire.upload(multipartFormData: { multipartFormData in
 for (key, value) in param! {
 multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
 }
 }, to: urlString, method: .post, headers: header,
 
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success( let upload,_,_):
 upload.responseJSON {
 response in
 
 if response.result.value != nil {
 print(response);
 let json = JSON(response.result.value!)
 if json.dictionaryValue["status"] == "success" || json.dictionaryValue["status"] == "true" || json.dictionaryValue["message"] == "SUCCESS" {
 completion("success", json.dictionaryObject as AnyObject)
 } else if json.dictionaryValue["status"] == "false" {
 
 if json.dictionaryValue["message"] == "Invalid Token" {
 
 } else {
 completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
 }
 
 } else {
 completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
 }
 } else {
 
 completion("error", ("data not found") as AnyObject)
 }
 }
 break
 
 case .failure(let encodingError):
 print("error:\(encodingError)")
 break
 
 }
 })
 }
 
 
 //MARK: Upload Image Data
 class func uploadImageAndData(_ strURL : String, parameters : [String:AnyObject], uploadDataArray : NSMutableArray, imageKey: String,completion: @escaping (_ result: String, _ data : AnyObject) -> Void) {
 
 Alamofire.upload(multipartFormData: { multipartFormData in
 
 if uploadDataArray.count > 0{
 for i in 0...uploadDataArray.count-1 {
 let filename : String = "image\(i).jpeg"
 multipartFormData.append(uploadDataArray[i] as! Data, withName: imageKey, fileName: filename , mimeType: "image/jpeg")
 }
 }
 
 for (key, value) in parameters {
 multipartFormData.append(value.data(using: String.Encoding.utf8.rawValue)! , withName: key)
 
 }
 
 }, to: strURL, method: .post, headers: nil, encodingCompletion: { encodingResult in
 switch encodingResult {
 case .success( let upload,_,_):
 upload.responseJSON {
 response in
 
 if response.result.value != nil {
 print(response);
 let json = JSON(response.result.value!)
 
 if json.dictionaryValue["status"] == "success" || json.dictionaryValue["status"] == "true" || json.dictionaryValue["message"] == "SUCCESS" {
 completion("success", json.dictionaryObject as AnyObject)
 } else  if json.dictionaryValue["status"] == "false" {
 
 if json.dictionaryValue["message"] == "Invalid Token" {
 
 } else {
 completion("error", (json.dictionaryValue["msg"]?.stringValue)! as AnyObject)
 }
 } else {
 completion("error", (json.dictionaryValue["response"]!["error_lable"].stringValue) as AnyObject)
 }
 }
 }
 break
 
 case .failure(let encodingError):
 print("error:\(encodingError)")
 break
 
 }
 })
 }
 */
