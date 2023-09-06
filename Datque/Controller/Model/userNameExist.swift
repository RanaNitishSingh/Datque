//
//  userNameExist.swift
//  Datque
//
//  Created by Zero IT Solutions on 01/09/23.
//

import Foundation
struct userNameExist : Codable {
    let code : String?
    let msg : String?
    let exists : String?
    let data : [String]?

    enum userNameDate: String, CodingKey {

        case code = "code"
        case msg = "msg"
        case exists = "exists"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        exists = try values.decodeIfPresent(String.self, forKey: .exists)
        data = try values.decodeIfPresent([String].self, forKey: .data)
    }

}
