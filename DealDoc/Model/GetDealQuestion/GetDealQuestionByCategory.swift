//
//  GetDealQuestionByCategory.swift
//  DealDoc
//
//  Created by Asad Khan on 9/16/22.
//

import Foundation
struct GetDealQuestionByCategory : Codable {
    let data : [DealCategoryModel]?
    let status : Bool?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent([DealCategoryModel].self, forKey: .data)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }

}
