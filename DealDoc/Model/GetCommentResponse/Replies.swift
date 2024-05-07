//
//  Replies.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//

import Foundation
struct Replies : Codable {
    let id : Int?
    let statement : String?
    let createdAt : String?
    let updatedAt : String?
    let deal_id : Int?
    let replied_to : Int?
    let created_by : Int?
    let user : userData?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case statement = "statement"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case deal_id = "deal_id"
        case replied_to = "replied_to"
        case created_by = "created_by"
        case user = "User"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        statement = try values.decodeIfPresent(String.self, forKey: .statement)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        deal_id = try values.decodeIfPresent(Int.self, forKey: .deal_id)
        replied_to = try values.decodeIfPresent(Int.self, forKey: .replied_to)
        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
        user = try values.decodeIfPresent(userData.self, forKey: .user)
    }

}
