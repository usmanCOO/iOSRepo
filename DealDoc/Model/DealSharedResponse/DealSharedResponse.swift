//
//  DealSharedResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 10/14/22.
//


import Foundation
struct DealSharedResponse : Codable {
    let status : Bool?
    let data : [DealSharedData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        data = try values.decodeIfPresent([DealSharedData].self, forKey: .data)
    }

}
