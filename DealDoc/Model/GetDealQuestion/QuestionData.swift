//
//  DealCategoryModel.swift
//  DealDoc
//
//  Created by Asad Khan on 9/16/22.
//

import Foundation
import UIKit
struct DealCategoryModel : Codable {
    
    let id : Int?
    let name : String?
    let metadata : String?
    let createdAt : String?
    let updatedAt : String?
    let response : String?
    let question_id : Int?
    let deal_id:Int?
    var questions : [Questions]?
    var isFinished: Bool = false
    var color: UIImage = UIImage()
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case name = "name"
        case metadata = "metadata"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case response = "response"
        case question_id = "question_id"
        case deal_id = "deal_id"
        case questions = "Questions"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        metadata = try values.decodeIfPresent(String.self, forKey: .metadata)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        response = try values.decodeIfPresent(String.self, forKey: .response)
        question_id = try values.decodeIfPresent(Int.self, forKey: .question_id)
        deal_id = try values.decodeIfPresent(Int.self, forKey: .deal_id)
        questions = try values.decodeIfPresent([Questions].self, forKey: .questions)
    }
    init(id:Int?,name:String?,metadata:String?,createdAt:String?,updatedAt:String?,questions:[Questions]?,response:String?,question_id:Int?,deal_id:Int?) {
        self.id = id
        self.name = name
        self.metadata = metadata
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.questions = questions
        self.response = response
        self.deal_id = deal_id
        self.question_id = question_id
    }

}

