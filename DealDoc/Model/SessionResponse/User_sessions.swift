//
//  User_sessions.swift
//  DealDoc
//
//  Created by Asad Khan on 12/2/22.
//

import Foundation
struct User_sessions : Codable {
    let id : Int?
    let metadata : metaData?
    let session_url : String?
    let session_start_date : String?
    let createdAt : String?
    let updatedAt : String?
    let deal_id : Int?
    let user_id : Int?
    let deal : Deal_data?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case metadata = "metadata"
        case session_url = "session_url"
        case session_start_date = "session_start_date"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case deal_id = "deal_id"
        case user_id = "user_id"
        case deal = "Deal"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        metadata = try values.decodeIfPresent(metaData.self, forKey: .metadata)
        session_url = try values.decodeIfPresent(String.self, forKey: .session_url)
        session_start_date = try values.decodeIfPresent(String.self, forKey: .session_start_date)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        deal_id = try values.decodeIfPresent(Int.self, forKey: .deal_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        deal = try values.decodeIfPresent(Deal_data.self, forKey: .deal)
    }

}
