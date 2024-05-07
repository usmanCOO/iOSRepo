//
//  UpdateDealStatusResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 11/9/22.
//

import Foundation
struct UpdateDealStatusResponse : Codable {
    let status : Bool?
    let data : UpdateDealStatusData?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        data = try values.decodeIfPresent(UpdateDealStatusData.self, forKey: .data)
    }

}
