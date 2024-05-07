//
//  Questions.swift
//  DealDoc
//
//  Created by Asad Khan on 9/16/22.
//

import Foundation
struct Questions : Codable {
    let id : Int?
    let statement : String?
    let metadata : String?
    let createdAt : String?
    let updatedAt : String?
    let category_id : Int?
    var isAnsweredType: QuestionSelectionType = .none

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case statement = "statement"
        case metadata = "metadata"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case category_id = "category_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        statement = try values.decodeIfPresent(String.self, forKey: .statement)
        metadata = try values.decodeIfPresent(String.self, forKey: .metadata)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
    }
    init(id:Int?,statement:String?,metadata:String?,createdAt:String?,updatedAt:String?,category_id:Int?,isAnsweredType:QuestionSelectionType) {
        self.id = id
        self.statement = statement
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.category_id = category_id
        self.isAnsweredType = isAnsweredType
    }

}
