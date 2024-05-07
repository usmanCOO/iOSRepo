//
//  CreatePaymentLogResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 11/10/22.
//

import Foundation
struct CreatePaymentLogResponse : Codable {
    let success : Bool?
    let message : String?
    let data : CreatePaymentLogData?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(CreatePaymentLogData.self, forKey: .data)
    }

}
