//
//  LoginResponse.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/6/22.
//


import Foundation
struct LoginResponse : Codable {
    let success : Bool?
    let message : String?
    let token : String?
    let refreshToken : String?
    var data : userData?
    

    enum CodingKeys: String, CodingKey {

        case message = "message"
        case success = "success"
        case token = "token"
        case refreshToken = "refreshToken"
        case data = "data"
   
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        data = try values.decodeIfPresent(userData.self, forKey: .data)
    }

}
