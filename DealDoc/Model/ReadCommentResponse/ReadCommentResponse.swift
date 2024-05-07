//
//  ReadCommentResponse.swift
//  DealDoc
//
//  Created by Mackbook on 02/05/2023.
//

import Foundation
struct ReadCommentResponse : Codable {
    let success : Bool?
    let message : String?
    let updatereadstatus : [Int]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case updatereadstatus = "updatereadstatus"
      
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        updatereadstatus = try values.decodeIfPresent([Int].self, forKey: .updatereadstatus)
        
    }

}
