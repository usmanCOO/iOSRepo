//
//  ResponseData.swift
//  DealDoc
//
//  Created by Asad Khan on 9/27/22.
//


import Foundation
struct ResponseData : Codable {
    let id : Int?
    let response : String?
    let metadata : String?
    let createdAt : String?
    let updatedAt : String?
    let question_id : Int?
    let deal_id : Int?
    var questionList : [Questions]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case response = "response"
        case metadata = "metadata"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case question_id = "question_id"
        case deal_id = "deal_id"
        case questionList = "Questions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        metadata = try values.decodeIfPresent(String.self, forKey: .metadata)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
        deal_id = try values.decodeIfPresent(Int.self, forKey: .deal_id)
        questionList = try values.decodeIfPresent([Questions].self, forKey: .questionList)
    }

}
