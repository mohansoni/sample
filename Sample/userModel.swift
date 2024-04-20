//
//  userModel.swift
//  Sample
//
//  Created by Mohan Soni on 20/04/24.
//

import Foundation

import Foundation

// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let id, assetType: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case assetType = "asset_type"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id, username, name: String
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case profileImage = "profile_image"
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String?
}

typealias UserModel = [WelcomeElement]
