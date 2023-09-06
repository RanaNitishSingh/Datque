//
//  searchUserName.swift
//  Datque
//
//  Created by Zero IT Solutions on 04/09/23.
//

import Foundation
struct searchUserName : Codable {
    let code : String?
    let msg : String?
    let data : [userNameData]?

    enum searchUserNameData: String, CodingKey {

        case code = "code"
        case msg = "msg"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        data = try values.decodeIfPresent([userNameData].self, forKey: .data)
    }

}

struct userNameData : Codable {
    let id : String?
    let fb_id : String?
    let username : String?
    let email : String?
    let first_name : String?
    let last_name : String?
    let birthday : String?
    let otp_code : String?
    let age : String?
    let gender : String?
    let about_me : String?
    let lat_long : String?
    let lat : String?
    let long : String?
    let view : String?
    let job_title : String?
    let company : String?
    let living : String?
    let children : String?
    let smoking : String?
    let drinking : String?
    let relationship : String?
    let sexuality : String?
    let school : String?
    let image1 : String?
    let image2 : String?
    let image3 : String?
    let image4 : String?
    let image5 : String?
    let image6 : String?
    let like_count : String?
    let dislike_count : String?
    let hide_me : String?
    let block : String?
    let purchased : String?
    let version : String?
    let device : String?
    let profile_type : String?
    let device_token : String?
    let plan_type : String?
    let expire_timestamp : String?
    let subscription_datetime : String?
    let promoted : String?
    let promoted_mins : String?
    let promoted_date : String?
    let hide_age : String?
    let hide_location : String?
    let height : String?
    let weight : String?
    let body_type : String?
    let eye_color : String?
    let hair_color : String?
    let blood_group : String?
    let skin_type : String?
    let language : String?
    let profession : String?
    let religion : String?
    let education : String?
    let status : String?
    let created : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fb_id = "fb_id"
        case username = "username"
        case email = "email"
        case first_name = "first_name"
        case last_name = "last_name"
        case birthday = "birthday"
        case otp_code = "otp_code"
        case age = "age"
        case gender = "gender"
        case about_me = "about_me"
        case lat_long = "lat_long"
        case lat = "lat"
        case long = "long"
        case view = "view"
        case job_title = "job_title"
        case company = "company"
        case living = "living"
        case children = "children"
        case smoking = "smoking"
        case drinking = "drinking"
        case relationship = "relationship"
        case sexuality = "sexuality"
        case school = "school"
        case image1 = "image1"
        case image2 = "image2"
        case image3 = "image3"
        case image4 = "image4"
        case image5 = "image5"
        case image6 = "image6"
        case like_count = "like_count"
        case dislike_count = "dislike_count"
        case hide_me = "hide_me"
        case block = "block"
        case purchased = "purchased"
        case version = "version"
        case device = "device"
        case profile_type = "profile_type"
        case device_token = "device_token"
        case plan_type = "plan_type"
        case expire_timestamp = "expire_timestamp"
        case subscription_datetime = "subscription_datetime"
        case promoted = "promoted"
        case promoted_mins = "promoted_mins"
        case promoted_date = "promoted_date"
        case hide_age = "hide_age"
        case hide_location = "hide_location"
        case height = "height"
        case weight = "weight"
        case body_type = "body_type"
        case eye_color = "eye_color"
        case hair_color = "hair_color"
        case blood_group = "blood_group"
        case skin_type = "skin_type"
        case language = "language"
        case profession = "profession"
        case religion = "religion"
        case education = "education"
        case status = "status"
        case created = "created"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        fb_id = try values.decodeIfPresent(String.self, forKey: .fb_id)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        birthday = try values.decodeIfPresent(String.self, forKey: .birthday)
        otp_code = try values.decodeIfPresent(String.self, forKey: .otp_code)
        age = try values.decodeIfPresent(String.self, forKey: .age)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        about_me = try values.decodeIfPresent(String.self, forKey: .about_me)
        lat_long = try values.decodeIfPresent(String.self, forKey: .lat_long)
        lat = try values.decodeIfPresent(String.self, forKey: .lat)
        long = try values.decodeIfPresent(String.self, forKey: .long)
        view = try values.decodeIfPresent(String.self, forKey: .view)
        job_title = try values.decodeIfPresent(String.self, forKey: .job_title)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        living = try values.decodeIfPresent(String.self, forKey: .living)
        children = try values.decodeIfPresent(String.self, forKey: .children)
        smoking = try values.decodeIfPresent(String.self, forKey: .smoking)
        drinking = try values.decodeIfPresent(String.self, forKey: .drinking)
        relationship = try values.decodeIfPresent(String.self, forKey: .relationship)
        sexuality = try values.decodeIfPresent(String.self, forKey: .sexuality)
        school = try values.decodeIfPresent(String.self, forKey: .school)
        image1 = try values.decodeIfPresent(String.self, forKey: .image1)
        image2 = try values.decodeIfPresent(String.self, forKey: .image2)
        image3 = try values.decodeIfPresent(String.self, forKey: .image3)
        image4 = try values.decodeIfPresent(String.self, forKey: .image4)
        image5 = try values.decodeIfPresent(String.self, forKey: .image5)
        image6 = try values.decodeIfPresent(String.self, forKey: .image6)
        like_count = try values.decodeIfPresent(String.self, forKey: .like_count)
        dislike_count = try values.decodeIfPresent(String.self, forKey: .dislike_count)
        hide_me = try values.decodeIfPresent(String.self, forKey: .hide_me)
        block = try values.decodeIfPresent(String.self, forKey: .block)
        purchased = try values.decodeIfPresent(String.self, forKey: .purchased)
        version = try values.decodeIfPresent(String.self, forKey: .version)
        device = try values.decodeIfPresent(String.self, forKey: .device)
        profile_type = try values.decodeIfPresent(String.self, forKey: .profile_type)
        device_token = try values.decodeIfPresent(String.self, forKey: .device_token)
        plan_type = try values.decodeIfPresent(String.self, forKey: .plan_type)
        expire_timestamp = try values.decodeIfPresent(String.self, forKey: .expire_timestamp)
        subscription_datetime = try values.decodeIfPresent(String.self, forKey: .subscription_datetime)
        promoted = try values.decodeIfPresent(String.self, forKey: .promoted)
        promoted_mins = try values.decodeIfPresent(String.self, forKey: .promoted_mins)
        promoted_date = try values.decodeIfPresent(String.self, forKey: .promoted_date)
        hide_age = try values.decodeIfPresent(String.self, forKey: .hide_age)
        hide_location = try values.decodeIfPresent(String.self, forKey: .hide_location)
        height = try values.decodeIfPresent(String.self, forKey: .height)
        weight = try values.decodeIfPresent(String.self, forKey: .weight)
        body_type = try values.decodeIfPresent(String.self, forKey: .body_type)
        eye_color = try values.decodeIfPresent(String.self, forKey: .eye_color)
        hair_color = try values.decodeIfPresent(String.self, forKey: .hair_color)
        blood_group = try values.decodeIfPresent(String.self, forKey: .blood_group)
        skin_type = try values.decodeIfPresent(String.self, forKey: .skin_type)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        profession = try values.decodeIfPresent(String.self, forKey: .profession)
        religion = try values.decodeIfPresent(String.self, forKey: .religion)
        education = try values.decodeIfPresent(String.self, forKey: .education)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        created = try values.decodeIfPresent(String.self, forKey: .created)
    }

}
