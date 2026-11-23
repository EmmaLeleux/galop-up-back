//
//  TypeEventResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 05/11/2026.
//

import Vapor

struct TypeEventResponseDTO : Content {
    let id: UUID
    let name: String
}
