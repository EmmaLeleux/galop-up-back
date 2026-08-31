//
//  UpdateUserDTO.swift
//  GalopUp
//
//  Created by Emma on 08/06/2026.
//

import Vapor

struct UpdateUserDTO: Codable {
    let username: String?
    let picture: File?
    let pictureInBase: UUID?
    let level: LevelGalopUserEnum?
}
