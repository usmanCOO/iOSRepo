//
//  DraftData.swift
//  DealDoc
//
//  Created by Asad Khan on 9/26/22.
//


import Foundation
struct DraftData : Codable {
    let questionId : Int?
    let status : Bool?

    enum CodingKeys: String, CodingKey {

        case questionId = "questionId"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        questionId = try values.decodeIfPresent(Int.self, forKey: .questionId)
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
    }

}
