//
//  AddCommentResponse.swift
//  DealDoc
//
//  Created by Asad Khan on 10/13/22.
//


import Foundation
struct AddCommentResponse : Codable {
    let message : String?
    let success : Bool?
    let data : AddCommentData?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case success = "success"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        data = try values.decodeIfPresent(AddCommentData.self, forKey: .data)
    }

}
