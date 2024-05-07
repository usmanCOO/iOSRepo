//
//  LogsMetaData.swift
//  DealDoc
//
//  Created by Asad Khan on 12/19/22.
//


import Foundation
struct LogsMetaData : Codable {
    let data : String?
    let company : String?

    enum CodingKeys: String, CodingKey {

        case data = "data"
        case company = "company"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data = try values.decodeIfPresent(String.self, forKey: .data)
        company = try values.decodeIfPresent(String.self, forKey: .company)
    }

}
