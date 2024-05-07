//
//  DraftDealResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 9/26/22.
//


import Foundation
struct DraftDealResponse : Codable {
    let status : Bool?
    let data : [DraftData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        data = try values.decodeIfPresent([DraftData].self, forKey: .data)
    }

}
