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
    let picture: String? //envoyer image par défaut si rien en bdd ?
    let role: UserRoleEnum
    let isBanned: Bool
    let deletedAt: Date?
   
}
