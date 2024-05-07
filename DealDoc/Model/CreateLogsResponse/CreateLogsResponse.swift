//
//  CreateLogsResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 12/19/22.
//


import Foundation
struct CreateLogsResponse : Codable {
    let success : Bool?
    let message : String?
    let data : LogsData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(LogsData.self, forKey: .data)
    }

}
