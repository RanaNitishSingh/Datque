//
//  AppUrl.swift
//  MyDIo
//
//  Created by Shrinkcom
//  Copyright © 2019 Shrinkcom. All rights reserved.


import UIKit
import CoreData

class AppUrl : NSObject {
    //"http://52.90.40.219/xodating/API//index.php?p="
    //static let mainDomain : String = "https://xomap.app/new/API/index.php?p="
    static let mainDomain : String = "https://datque.zeroitsolutions.com/API/index.php?p="

    static let imageURL : String = ""
   
    class func AppName() -> String {
        return ""
    }
    class func getRTcToken() -> String {
        return mainDomain+"video_token"
    }
    class func getUserInfoURL() -> String {
        return mainDomain+"getUserInfo"
    }//http://52.90.40.219/xodating/API//index.php?p=getUserInfo
    
    class func screenBoost() -> String {
        return mainDomain+"boostProfile"
    }//http://52.90.40.219/xodating/API//index.php?p=boostProfile
    
    
    class func SignUpURL () -> String {
        return mainDomain+"signup"
    }//http://52.90.40.219/xodating/API//index.php?p=signup
    class func ReportURL () -> String {
        return mainDomain+"report_user"
    }
    class func userLikeDislikeURL () -> String {
        return mainDomain+"user_like_dislike"
    }//http://52.90.40.219/xodating/API//index.php?p=user_like_dislike
    
    class func userNearByMeURL () -> String {
        return mainDomain+"userNearByMe"
    }//http://52.90.40.219/xodating/API//index.php?p=userNearByMe
    
    class func is_user_existURL () -> String {
        return mainDomain+"is_user_exist"
    }//http://52.90.40.219/xodating/API//index.php?p=is_user_exist
    
    class func getUserNotificationsURL () -> String {
        return mainDomain+"getUserNotifications"
    }//http://52.90.40.219/xodating/API//index.php?p=getUserNotifications
    
    class func myLikiesURL () -> String {
        return mainDomain+"mylikies"
    }//http://52.90.40.219/xodating/API//index.php?p=mylikies
    
    class func myMatchURL () -> String {
        return mainDomain+"myMatch"
    }//http://52.90.40.219/xodating/API//index.php?p=myMatch
    
    class func changeProfilePictureURL () -> String {
        return mainDomain+"changeProfilePicture"
    }//http://52.90.40.219/xodating/API//index.php?p=changeProfilePicture
    
    class func showorhideprofileURL() -> String {
        return mainDomain+"show_or_hide_profile"
    }//http://52.90.40.219/xodating/API//index.php?p=show_or_hide_profile
    
    class func deleteAccountURL() -> String {
        return mainDomain+"deleteAccount"
    }//http://52.90.40.219/xodating/API//index.php?p=deleteAccount
    
    class func uploadImagesURL() -> String {
        return mainDomain+"uploadImages"
    }//http://52.90.40.219/xodating/API//index.php?p=uploadImages
    
    class func deleteImagesURL() -> String {
        return mainDomain+"deleteImages"
    }//http://52.90.40.219/xodating/API//index.php?p=deleteImages
    
    class func editUserInfoURL() -> String {
        return mainDomain+"editUserInfo"
    }//http://52.90.40.219/xodating/API//index.php?p=editUserInfo
    class func editProfileInfoURL() -> String {
        return mainDomain+"edit_profile"
    }
    
    class func getUserLikeDislikeURL() -> String {
        return mainDomain+"getUserLikeDislike"
    }//http://52.90.40.219/xodating/API//index.php?p=getUserLikeDislike
    
    class func getProfilelikesURL() -> String {
        return mainDomain+"getProfilelikes"
    }//http://52.90.40.219/xodating/API//index.php?p=getProfilelikes
    
    class func sendPushNotificationURL () -> String {
        return mainDomain+"sendPushNotification"
    }//http://52.90.40.219/xodating/API//index.php?p=sendPushNotification
    
    class func updateFromFirebaseURL () -> String {
        return mainDomain+"Update_From_Firebase"
    }//http://52.90.40.219/xodating/API//index.php?p=Update_From_Firebase
    
    class func flat_userURL () -> String {
        return mainDomain+"flat_user"
    }//http://52.90.40.219/xodating/API//index.php?p=flat_user
    
    class func payment_successURL () -> String {
        return mainDomain+"payment_success"
    }//http://52.90.40.219/xodating/API//index.php?p=payment_success
    
    class func update_purchase_StatusURL () -> String {
        return mainDomain+"update_purchase_Status"
    }//http://52.90.40.219/xodating/API//index.php?p=update_purchase_Status
    
    class func gifFirstURL() -> String {
        return "https://media.giphy.com/media/"
    }//https://media.giphy.com/media/
    
    class func gifThirdURL() -> String {
        return "/200w.gif"
    }///200w.gif
    
    class func firstChatURL() -> String {
        return mainDomain+"firstchat"
    }//http://52.90.40.219/xodating/API//index.php?p=firstchat
    
    class func unMatchURL () -> String {
        return mainDomain+"unMatch"
    }//http://52.90.40.219/xodating/API//index.php?p=unMatch
   
    class func blockUserProfileURL () -> String {
        return mainDomain+"block_user_profile"
    }//https://datque.zeroitsolutions.com/API/index.php
    
    class func blockUserChatURL () -> String {
        return mainDomain+"block_user_chat"
    }//https://datque.zeroitsolutions.com/API/index.php
    
    class func userChatBlockedURL () -> String {
        return mainDomain+"user_chat_blocked"
    }//https://datque.zeroitsolutions.com/API/index.php
    
    class func blockUsersListURL () -> String {
        return mainDomain+"block_users_list"
    }//https://datque.zeroitsolutions.com/API/index.php
    
    class func likeUser () -> String {
        return mainDomain+"user_like_dislike"
    }//https://datque.zeroitsolutions.com/API/index.php
}



