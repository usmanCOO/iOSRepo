//
//  ShareDealData.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//

import Foundation
struct ShareDealData : Codable {
    let id : Int?
    let dealId : Int?
    let userId : Int?
    let createdBy : Int?
    let updatedAt : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case dealId = "dealId"
        case userId = "userId"
        case createdBy = "createdBy"
        case updatedAt = "updatedAt"
        case createdAt = "createdAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        dealId = try values.decodeIfPresent(Int.self, forKey: .dealId)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        createdBy = try values.decodeIfPresent(Int.self, forKey: .createdBy)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }

}
