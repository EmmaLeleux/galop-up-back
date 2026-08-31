//
//  RefreshTokenRequestDTO.swift
//  GalopUp
//
//  Created by Emma on 02/06/2026.
//

import Vapor

struct RefreshTokenRequestDTO: Content, Validatable {
    let refreshToken: String
    
    static func validations(_ validations: inout Validations){
        validations.add("refreshToken", as: String.self)
    }
}
