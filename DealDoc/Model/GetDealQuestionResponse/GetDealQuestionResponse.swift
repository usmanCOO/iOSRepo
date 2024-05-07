//
//  GetDealQuestionResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 9/27/22.
//

import Foundation
struct GetDealQuestionResponse : Codable {
    let status : Bool?
    let data : [ResponseData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        data = try values.decodeIfPresent([ResponseData].self, forKey: .data)
    }

}
