//
//  SessionResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 12/2/22.
//

import Foundation
struct SessionResponse : Codable {
    let status : Bool?
    let user_sessions : [User_sessions]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case user_sessions = "user_sessions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        user_sessions = try values.decodeIfPresent([User_sessions].self, forKey: .user_sessions)
    }

}
