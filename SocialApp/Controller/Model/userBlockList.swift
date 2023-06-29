//
//  userBlockList.swift
//  SocialApp
//
//  Created by Nitish on 27/06/23.
//

import Foundation

struct UserBlockList : Codable {
    let code : String?
    let msg : [blockList]?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case msg = "msg"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent([blockList].self, forKey: .msg)
    }

}

struct blockList : Codable {
    let id : String?
    let user_id : String?
    let fb_id : String?
    let first_name : String?
    let last_name : String?
    let image : String?
    let created : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case fb_id = "fb_id"
        case first_name = "first_name"
        case last_name = "last_name"
        case image = "image"
        case created = "created"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        fb_id = try values.decodeIfPresent(String.self, forKey: .fb_id)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        created = try values.decodeIfPresent(String.self, forKey: .created)
    }

}
