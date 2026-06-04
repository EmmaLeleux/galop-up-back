//
//  RefreshTokenRequestDTO.swift
//  GalopUp
//
//  Created by Emma on 02/06/2026.
//

import Vapor

struct RefreshTokenRequestDTO: Content, Validatable {
    let refreshToken: String
    let userId: UUID
    
    static func validations(_ validations: inout Validations){
        validations.add("refreshToken", as: String.self)
        validations.add("userId", as: UUID.self)
    }
}
