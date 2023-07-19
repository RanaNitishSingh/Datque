//
//  AppModel.swift
//  SocialApp
//
//  Created by mac on 22/12/21.
//

import Foundation

// MARK: - GetUserInfoData
struct GetUserInfoData: Codable {
    let code: String?
    let msg: [Msg]?
}
// MARK : - GetUserInfoData Msg
struct Msg: Codable {
    let fbID, aboutMe, jobTitle, gender: String?
    let birthday: String?
    let age: Int?
    let company, school, firstName, lastName: String?
    let living, children, smoking, drinking: String?
    let relationship, sexuality, likeCount, dislikeCount: String?
    let purchased, status, height, weight: String?
    let bodyType, eyeColor, hairColor, bloodGroup: String?
    let skinType, language, profession, religion: String?
    let education: String?
    let image1: String?
    let image2: String?
    let image3, image4, image5, image6: String?

    enum CodingKeys: String, CodingKey {
        case fbID = "fb_id"
        case aboutMe = "about_me"
        case jobTitle = "job_title"
        case gender, birthday, age, company, school
        case firstName = "first_name"
        case lastName = "last_name"
        case living, children, smoking, drinking, relationship, sexuality
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case purchased, status, height, weight
        case bodyType = "body_type"
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case bloodGroup = "blood_group"
        case skinType = "skin_type"
        case language, profession, religion, education, image1, image2, image3, image4, image5, image6
    }
}


// MARK: - GetUserSignUpData
struct GetUserSignUpData: Codable {
    let code: String?
    let msg: [MsgSignUp]?
}
// MARK : - GetUserSignUpData Msg
struct MsgSignUp: Codable {
    let fbID, action, image1, firstName: String?
    let lastName, age, birthday, gender: String?

    enum CodingKeys: String, CodingKey {
        case fbID = "fb_id"
        case action, image1
        case firstName = "first_name"
        case lastName = "last_name"
        case age, birthday, gender
    }
}

// MARK: - userNearByMeData
struct userNearByMeData: Codable {
    let code: String?
    let msg: [MsguserNearByMe]?
}
// MARK : - userNearByMeData Msg
struct MsguserNearByMe: Codable {
    let fbID, firstName, lastName, birthday: String?
    let aboutMe, distance, gender, image1: String?
    let image2, image3, image4, image5: String?
    let image6, jobTitle, company, school: String?
    let living, children, smoking, drinking: String?
    let relationship, sexuality, swipe, block: String?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case fbID = "fb_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case birthday
        case aboutMe = "about_me"
        case distance, gender, image1, image2, image3, image4, image5, image6
        case jobTitle = "job_title"
        case company, school, living, children, smoking, drinking, relationship, sexuality, swipe, block, status
    }
}

// MARK: - GetUserNotificationsData
struct GetUserNotificationsData: Codable {
    let code: String?
    let msg: [MsgGetUserNotifications]?
}
// MARK : - Msg
struct MsgGetUserNotifications: Codable {
    let senderID, receiverID: String?
    let notification: Notification?

    enum CodingKeys: String, CodingKey {
        case senderID = "sender_id"
        case receiverID = "receiver_id"
        case notification
    }
}
// MARK : - Notification
struct Notification: Codable {
    let title, body: String?
    let icon: String?
    let actionType, distance, age: String?

    enum CodingKeys: String, CodingKey {
        case title, body, icon
        case actionType = "action_type"
        case distance, age
    }
}

//// MARK: - GetUserNotificationsData
//struct GetUserNotificationsData: Codable {
//    let code: String?
//    let msg: [MsgGetUserNotifications]?
//}
//// MARK : - Msg
//struct MsgGetUserNotifications: Codable {
//    let senderID, receiverID: String?
//    let notification: Notification?
//
//    enum CodingKeys: String, CodingKey {
//        case senderID = "sender_id"
//        case receiverID = "receiver_id"
//        case notification
//    }
//}
//// MARK : - Notification
//struct Notification: Codable {
//    let title, body: String?
//    let icon: String?
//    let actionType: String?
//
//    enum CodingKeys: String, CodingKey {
//        case title, body, icon
//        case actionType = "action_type"
//    }
//}


// MARK: - MyMatchData
struct MyMatchData: Codable {
    let code: String?
    let msg: [MsgMyMatchData]?
    let myLikes: MyLikes?
}
// MARK : - Msg
struct MsgMyMatchData: Codable {
    let actionProfile: String?
    let actionProfileName: ProfileName?
    let effectProfile: String?
    let effectProfileName: ProfileName?

    enum CodingKeys: String, CodingKey {
        case actionProfile = "action_profile"
        case actionProfileName = "action_profile_name"
        case effectProfile = "effect_profile"
        case effectProfileName = "effect_profile_name"
    }
}
// MARK : - ProfileName
struct ProfileName: Codable {
    let image1: String?
    let firstName, lastName: String?

    enum CodingKeys: String, CodingKey {
        case image1
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
// MARK : - MyLikes
struct MyLikes: Codable {
    let total: Int?
    let image1: String?
}

// MARK: - ShoworhideprofileData
struct ShoworhideprofileData: Codable {
    let code: String?
    let msg: [MsgShoworhideprofile]?
}
// MARK : - Msg
struct MsgShoworhideprofile: Codable {
    let response: String?
}


// MARK: - UploadImagesData
struct UploadImagesData: Codable {
    let code: String?
    let msg: [MsgUploadImagesData]?
}
// MARK : - Msg
struct MsgUploadImagesData: Codable {
    let response: String?
}

// MARK: - GetUserLikeDislikeData
struct GetUserLikeDislikeData: Codable {
    let code: String?
    let msg: [MsgGetUserLikeDislikeData]?
}
// MARK : - Msg
struct MsgGetUserLikeDislikeData: Codable {
    let fbID, likeCount, dislikeCount, status: String?

    enum CodingKeys: String, CodingKey {
        case fbID = "fb_id"
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case status
    }
}




// MARK: - GetProfileLikesData
struct GetProfileLikesData: Codable {
    let code: String?
    let msg: [MsgGetProfileLikesData]?
}
// MARK : - Msg
struct MsgGetProfileLikesData: Codable {
    let actionProfile: String?
    let profileInfo: ProfileInfo?

    enum CodingKeys: String, CodingKey {
        case actionProfile = "action_profile"
        case profileInfo = "profile_info"
    }
}
// MARK : - ProfileInfo
struct ProfileInfo: Codable {
    let fbID, firstName: String?
    let image1: String?
    let lastName, likeCount, dislikeCount: String?

    enum CodingKeys: String, CodingKey {
        case fbID = "fb_id"
        case firstName = "first_name"
        case image1
        case lastName = "last_name"
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
    }
}



// MARK : - ChatUserInfo
struct ChatUserInfo: Codable {
    let block: String?
    let date: String?
    let like: String?
    let msg: String?
    let name: String?
    let pic: String?
    
    let read: String?
    let rid: String?
    let sort: String?
    
    let status: String?
    let timestamp: String?

    
    init(json: [String: Any]) {
        self.block = json["block"] as? String ?? ""
        self.date = json["date"] as? String ?? ""
        self.like = json["like"] as? String ?? ""
    
        self.msg = json["msg"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.pic = json["pic"] as? String ?? ""
        
        self.read = json["read"] as? String ?? ""
        self.rid = json["rid"] as? String ?? ""
        self.sort = json["sort"] as? String ?? ""
        
        self.status = json["status"] as? String ?? ""
        self.timestamp = json["timestamp"] as? String ?? ""
    }
    
}
struct LiveUserInfo: Codable {
    let user_id: String?
    let user_name: String?
    let user_picture: String?
    let rtc_token: String?
    
    init(json: [String: Any]) {
        self.user_id = json["user_id"] as? String ?? ""
        self.user_name = json["user_name"] as? String ?? ""
        self.user_picture = json["user_picture"] as? String ?? ""
        self.rtc_token = json["rtc_token"] as? String ?? ""
    
    }
    
}
// MARK: - UserChatDetailData
struct UserChatDetailData: Codable {
    let chatID, lat, long, picURL: String?
    let recImg: String?
    let receiverID, senderID: String?
    let senderName: String?
    let status: String?
    let text, time, timestamp, type: String?

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case lat, long
        case picURL = "pic_url"
        case recImg = "rec_img"
        case receiverID = "receiver_id"
        case senderID = "sender_id"
        case senderName = "sender_name"
        case status, text, time, timestamp, type
    }
    
    init(json: [String: Any]) {
        self.chatID = json["chat_id"] as? String ?? ""
        self.lat = json["lat"] as? String ?? ""
        self.long = json["long"] as? String ?? ""
        self.picURL = json["pic_url"] as? String ?? ""
        self.recImg = json["rec_img"] as? String ?? ""
        self.receiverID = json["receiver_id"] as? String ?? ""
        self.senderID = json["sender_id"] as? String ?? ""
        self.senderName = json["sender_name"] as? String ?? ""
        
        self.status = json["status"] as? String ?? ""
        self.text = json["text"] as? String ?? ""
        self.time = json["time"] as? String ?? ""
        self.timestamp = json["timestamp"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        
    }
    
}


// MARK: - GetSendPushNotificationModel
struct GetSendPushNotificationModel: Codable {
    let multicastID: Double?
    let success, failure, canonicalIDS: Int?
    let results: [SendPushNotiResultData]?

    enum CodingKeys: String, CodingKey {
        case multicastID = "multicast_id"
        case success, failure
        case canonicalIDS = "canonical_ids"
        case results
    }
}

// MARK: - SendPushNotiResultData
struct SendPushNotiResultData: Codable {
    let error: String?
}



// MARK: - GetFlatUserData
struct GetFlatUserData: Codable {
    let code: String?
    let msg: [GetFlatUserDataMsg]?
}

// MARK : - Msg
struct GetFlatUserDataMsg: Codable {
    let response: String?
    let is_block : Bool?
}

// MARK: - PaymentSuccessData
struct PaymentSuccessData: Codable {
    let code: String?
    let msg: [PaymentSuccessMsg]?
}
// MARK : - Msg
struct PaymentSuccessMsg: Codable {
    let transactionID, authCode, responseCode, amount: String?
    let paymentStatus, paymentResponse: String?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transactionId"
        case authCode, responseCode, amount, paymentStatus, paymentResponse
    }
}


// MARK: - UpdatePurchaseStatusData
struct UpdatePurchaseStatusData: Codable {
    let code: String?
    let msg: String?
}
// MARK : - Msg
struct UpdatePurchaseStatusMsg: Codable {
    let response: String?
}

// MARK: - FirstChatData
struct FirstChatData: Codable {
    let code: String?
    let msg: MsgFirstChatData?
}
// MARK : - Msg
struct MsgFirstChatData: Codable {
    let response: String?
}




