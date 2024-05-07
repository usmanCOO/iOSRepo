//
//  UpdateUserResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 10/16/22.
//


import Foundation
struct UpdateUserResponse : Codable {
    let success : Bool?
    let message : String?
    let data : userData?
    

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case data = "data"
   
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(userData.self, forKey: .data)
    }

}
