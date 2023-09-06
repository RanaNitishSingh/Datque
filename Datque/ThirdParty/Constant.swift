//
//  Constant.swift
//  HelloEatsUserApp
//
//  Created by mac on 17/05/21.
//

import Foundation
import UIKit
import CoreData
let  APPDELEGATE =  UIApplication.shared.delegate as! AppDelegate
var notificationData : [AnyHashable : Any]?
func getContextObj() -> NSManagedObjectContext {
    
    let appDel = UIApplication.shared.delegate as! AppDelegate
    return appDel.persistentContainer.viewContext
}
