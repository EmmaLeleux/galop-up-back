//
//  GetPictureDto.swift
//  GalopUp
//
//  Created by Emma on 30/06/2026.
//

import Vapor

struct GetPictureDto : Content {
    let id: UUID
    let key: String
    let name: String
    let url: String
    let order: Int?
}
