//
//  UpdateDealStatusData.swift
//  DealDoc
//
//  Created by Asad Khan on 11/9/22.
//

import Foundation
struct UpdateDealStatusData : Codable {
    let id : Int?
    let status : String?
    let createdBy : String?
    let createdAt : String?
    let updatedAt : String?
    let userId : Int?
    let dealId : Int?
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case status = "status"
        case createdBy = "createdBy"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case userId = "userId"
        case dealId = "dealId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        createdBy = try values.decodeIfPresent(String.self, forKey: .createdBy)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        dealId = try values.decodeIfPresent(Int.self, forKey: .dealId)
       
    }

}
