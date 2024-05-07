//
//  LogsData.swift
//  DealDoc
//
//  Created by Asad Khan on 12/19/22.
//


import Foundation
struct LogsData : Codable {
    let id : Int?
    let log_type : String?
    let metadata : LogsMetaData?
    let userID : Int?
    let updatedAt : String?
    let createdAt : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case log_type = "log_type"
        case metadata = "metadata"
        case userID = "userID"
        case updatedAt = "updatedAt"
        case createdAt = "createdAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        log_type = try values.decodeIfPresent(String.self, forKey: .log_type)
        metadata = try values.decodeIfPresent(LogsMetaData.self, forKey: .metadata)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }

}
