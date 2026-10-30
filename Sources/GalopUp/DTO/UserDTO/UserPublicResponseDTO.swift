//
//  UserPublicResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 18/10/2026.
//

import Vapor

struct UserPublicResponseDTO: Content {
    let id: UUID
    let username: String?
    let picture: GetPictureDto?
}
