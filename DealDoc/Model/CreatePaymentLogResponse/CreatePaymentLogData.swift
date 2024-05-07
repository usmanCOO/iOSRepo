//
//  CreatePaymentLogData.swift
//  DealDoc
//
//  Created by Asad Khan on 11/10/22.
//

import Foundation
struct CreatePaymentLogData : Codable {
    let id : Int?
    let deal_name : String?
    let payment_status : Bool?
    let payment_amount : Int?
    let payment_response : String?
    let createdAt : String?
    let updatedAt : String?
  
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case deal_name = "deal_name"
        case payment_status = "payment_status"
        case payment_amount = "payment_amount"
        case payment_response = "payment_response"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        deal_name = try values.decodeIfPresent(String.self, forKey: .deal_name)
        payment_status = try values.decodeIfPresent(Bool.self, forKey: .payment_status)
        payment_amount = try values.decodeIfPresent(Int.self, forKey: .payment_amount)
        payment_response = try values.decodeIfPresent(String.self, forKey: .payment_response)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
       
    }

}


