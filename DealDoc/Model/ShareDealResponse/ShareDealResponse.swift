//
//  ShareDealResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//



import Foundation
struct ShareDealResponse : Codable {
    let status : Bool?
    let data : ShareDealData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        data = try values.decodeIfPresent(ShareDealData.self, forKey: .data)
    }

}
