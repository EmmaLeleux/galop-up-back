//
//  UserResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 21/05/2026.
//

import Vapor

struct UserResponseDTO : Content {
    let id : UUID
    let username : String?
    let email: String
    let age: Int?
    let googleId: String?
    let appleId: String?
    let level: LevelGalopUserEnum?
    let picture: GetPictureDto?
    let role: UserRoleEnum
    let isBanned: Bool
    let deletedAt: Date?
   
}
