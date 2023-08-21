//
//  PDUserDefaults.swift
//  Ripple
//
//  Created by SyncAppData-3 on 20/02/18.
//  Copyright © 2018 SyncAppData-3. All rights reserved.
//


/*
 "user_id": "65",
 "firstname": "",
 "lastname": "",
 "username": "Riya",
 "email": "riya@mailinator.com",
 "password": "c56d0e9a7ccec67b4ea131655038d604",
 "mobile": "9876543210",
 "image": "userprofile/5d2ec7068b37c",
 "status": "1",
 "created_on": "2019-07-17 06:58:14",
 "login_by": null,
 "gender": null,
 "birthDate": null,
 "token": "",
 "address": null
 */


import UIKit

class PDUserDefaults: NSObject {
    
    static var isRemember = DefaultsKey<Bool>("isRemember")
    
    static var RemEmail = DefaultsKey<String>("RemEmail")
    static var RemPassword = DefaultsKey<String>("RemPassword")
    
    static var DelivFilter = DefaultsKey<String>("DelivFilter")
    static var RateFilter = DefaultsKey<String>("RateFilter")
    
    static var CartTotalAmt = DefaultsKey<String>("CartTotalAmt")
    static var CartTotalItem = DefaultsKey<String>("CartTotalItem")
    
    static var Jurisdiction = DefaultsKey<String>("Jurisdiction")
    static var SubscriptionID = DefaultsKey<String>("SubscriptionID")
    static var ExpiryDate = DefaultsKey<String>("ExpiryDate")
    static var isMonthlyPur = DefaultsKey<Bool>("isMonthlyPur")
    static var isSemiAnnualPur = DefaultsKey<Bool>("isSemiAnnualPur")
    static var isYearlyPur = DefaultsKey<Bool>("isYearlyPur")
    
    static var isMonthlyPremium = DefaultsKey<Bool>("isMonthlyPremium")
    static var isSemiAnnualPremium = DefaultsKey<Bool>("isSemiAnnualPremium")
    static var isYearlyPremium = DefaultsKey<Bool>("isYearlyPremium")
    
    
    static var isSubscribed = DefaultsKey<Bool>("isSubscribed")
    
    static var RegisDate = DefaultsKey<String>("RegisDate")
    
    static var InsurStatus = DefaultsKey<String>("InsurStatus")
    
    static var ModeType = DefaultsKey<String>("ModeType")
    static var OfflineType = DefaultsKey<String>("OfflineType")
    
    static var DeviceUDID = DefaultsKey<String>("DeviceUDID")
    static var LanguageType = DefaultsKey<String>("LanguageType")
    static var LanguageName = DefaultsKey<String>("LanguageName")
    
    static var usercomefrom = DefaultsKey<String>("userComeFrom")
    static var userName = DefaultsKey<String>("userName")
    static var userEmail = DefaultsKey<String>("userEmail")
    
    static var LoginUserType = DefaultsKey<String>("LoginUserType")
    static var AccessHistory = DefaultsKey<String>("AccessHistory")
    static var UserFirstName = DefaultsKey<String>("UserFirstName")
    static var UserPhoneNumber = DefaultsKey<String>("UserPhoneNumber")
    static var UserLastName = DefaultsKey<String>("UserLastName")
    static var isPremium = DefaultsKey<Bool>("isPremium")
    static var isShowSetting = DefaultsKey<Bool>("isShowSetting")
    static var appusername = DefaultsKey<String>("appusername")
    static var folderurl = DefaultsKey<String>("folderurl")
    static var foldername = DefaultsKey<String>("foldername")
    static var speedRate = DefaultsKey<Double?>("speedRate")
    static var qwaittime = DefaultsKey<Double?>("qwaittime")
    static var nextwaittime = DefaultsKey<Double?>("nextwaittime")
    static var imgReducPerc = DefaultsKey<Double?>("imgReducPerc")//specialization
    static var Specialization = DefaultsKey<String?>("Specialization")
    
    static var nameWaitTime = DefaultsKey<Double?>("nameWaitTime")
    static var descWaitTime = DefaultsKey<Double?>("descWaitTime")
    static var descYourself = DefaultsKey<String>("descYourself")
    static var relationship = DefaultsKey<String>("relationship")
    static var drinking = DefaultsKey<String>("drinking")
    static var smoking = DefaultsKey<String>("smoking")
    static var children = DefaultsKey<String>("children")
    static var living = DefaultsKey<String>("living")
    static var IndexRow = DefaultsKey<Int>("IndexRow")
    static var Promocode = DefaultsKey<String>("Promocode")
    
    
    static var ZipCode = DefaultsKey<String>("ZipCode")
    
    static var isLogin = DefaultsKey<Bool>("isLogin")
    static var isHighFilter = DefaultsKey<Bool>("isHighFilter")
    static var appCurrency = DefaultsKey<String>("appCurrency")
    static var currencyId = DefaultsKey<Int>("currencyId")
    static var currencySymbol = DefaultsKey<String>("currencySymbol")
    static var ImageArray = DefaultsKey<Array<Any>?>("imgArray")
    static var AccessToken = DefaultsKey<String>("AccessToken")
    static var nameImg = DefaultsKey<Data>("nameImg")
    static var addressImg = DefaultsKey<Data>("addressImg")
    static var selfieImg = DefaultsKey<Data>("selfieImg")
    static var selfieCreditImg = DefaultsKey<Data>("selfieCreditImg")
    static var teststatus = DefaultsKey<String?>("teststatus")
    static var testid = DefaultsKey<String>("testid")
    static var isShowMood = DefaultsKey<String>("isShowMood")
    static var categoryid = DefaultsKey<String>("categoryid")
    static var profileImg = DefaultsKey<String>("profileImg")
    static var AdministratorId = DefaultsKey<String>("AdministratorId")
    static var CompanyId  = DefaultsKey<String>("CompanyId")
    static var HistoryComeFrom = DefaultsKey<String>("HistoryComeFrom")
    static var tower = DefaultsKey<String>("tower")
    static var department = DefaultsKey<String>("department")
    static var password = DefaultsKey<String>("password")
    static var isFingerprintOn = DefaultsKey<Bool>("isFingerprintOn")
    static var VigilanteUserID = DefaultsKey<String>("VigilanteUserID")
    static var VigilanteCompanyID = DefaultsKey<String>("VigilanteCompanyID")
    static var PackageExpires = DefaultsKey<String>("PackageExpires")
    static var SubscriptionStatus = DefaultsKey<String>("SubscriptionStatus")
    static var DeviceToken = DefaultsKey<String?>("DeviceToken")
    static var Online = DefaultsKey<String?>("Online")
    static var Active = DefaultsKey<String?>("Active")
    static var Id = DefaultsKey<String?>("Id")
    static var Role = DefaultsKey<String?>("Role")
    
    static var AboutMe = DefaultsKey<String>("AboutMe")
    static var JobTitle = DefaultsKey<String>("JobTitle")
    
    static var Birthday = DefaultsKey<String>("Birthday")
    static var Age = DefaultsKey<Int>("Age")
    static var Company = DefaultsKey<String>("Company")
    static var School = DefaultsKey<String>("School")
    static var ActiveView = DefaultsKey<Int>("ActiveView")
    //for key key app
    static var UserLat = DefaultsKey<String>("UserLat")
    static var UserLng = DefaultsKey<String>("UserLng")
    static var UserID = DefaultsKey<String>("UserID")
    static var FCMToken = DefaultsKey<String>("FCMToken")
    static var Gender = DefaultsKey<String?>("Gender")
    static var Distance = DefaultsKey<String?>("Distance")
    static var AgeMin = DefaultsKey<String>("AgeMin")
    static var AgeMax = DefaultsKey<String>("AgeMax")
    static var MarriedStatus = DefaultsKey<String>("MarriedStatus")
    static var Height = DefaultsKey<String>("Height")
    static var ResetFilter = DefaultsKey<String>("ResetFilter")
    static var Weight = DefaultsKey<String>("Weight")
    static var BloodGroup = DefaultsKey<String>("BloodGroup")
    static var SkinType = DefaultsKey<String>("SkinType")
    static var Language = DefaultsKey<String>("Language")
    static var Profession = DefaultsKey<String>("Profession")
    static var Religion = DefaultsKey<String>("Religion")
    static var Education = DefaultsKey<String>("Education")
    static var BodyType = DefaultsKey<String>("BodyType")
    static var HairColor = DefaultsKey<String>("HairColor")
    static var EyeColor = DefaultsKey<String>("EyeColor")
    static var SelectedLocation = DefaultsKey<String>("SelectedLocation")
    //use for agora video call
    static var agoraToken = DefaultsKey<String?>("agoraToken")
    static var agoraChannelName = DefaultsKey<String?>("agoraChannelName")
    static var agoraUID = DefaultsKey<String?>("agoraUID")
    static var ProfileValue = DefaultsKey<Double>("ProfileValue")
    
}



