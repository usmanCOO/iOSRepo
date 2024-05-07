//
//  AddCommentData.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//


import Foundation
struct AddCommentData : Codable {
    let id : Int?
    let dealId : String?
    let statement: String?
    let replied_to: Int?
    let created_by : Int?
    let updatedAt : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case dealId = "dealId"
        case statement = "statement"
        case replied_to = "replied_to"
        case created_by = "created_by"
        case updatedAt = "updatedAt"
        case createdAt = "createdAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        dealId = try values.decodeIfPresent(String.self, forKey: .dealId)
        statement = try values.decodeIfPresent(String.self, forKey: .statement)
        replied_to = try values.decodeIfPresent(Int.self, forKey: .replied_to)
        created_by = try values.decodeIfPresent(Int.self, forKey: .created_by)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }

}
