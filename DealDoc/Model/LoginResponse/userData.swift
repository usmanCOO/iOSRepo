//
//  userData.swift
//  Meddpicc App
//
//  Created by Asad Khan on 9/14/22.
//


import Foundation
struct userData : Codable {
    let id : Int?
    let fullName : String?
    let phone_no : String?
    let email : String?
    let password : String?
    let isVerified : Bool?
    let verificationToken : String?
    let resetToken : String?
    let resetTokenExpiry : String?
    let appleID : String?
    let profilePhoto : String?
    let company : String?
    let createdAt : String?
    let updatedAt : String?
    let role_id : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fullName = "fullName"
        case phone_no = "phone_no"
        case email = "email"
        case password = "password"
        case isVerified = "isVerified"
        case verificationToken = "verificationToken"
        case resetToken = "resetToken"
        case resetTokenExpiry = "resetTokenExpiry"
        case appleID = "appleID"
        case profilePhoto = "profilePhoto"
        case company = "company"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case role_id = "role_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        isVerified = try values.decodeIfPresent(Bool.self, forKey: .isVerified)
        verificationToken = try values.decodeIfPresent(String.self, forKey: .verificationToken)
        resetToken = try values.decodeIfPresent(String.self, forKey: .resetToken)
        resetTokenExpiry = try values.decodeIfPresent(String.self, forKey: .resetTokenExpiry)
        appleID = try values.decodeIfPresent(String.self, forKey: .appleID)
        profilePhoto = try values.decodeIfPresent(String.self, forKey: .profilePhoto)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
        role_id = try values.decodeIfPresent(Int.self, forKey: .role_id)
    }

}
