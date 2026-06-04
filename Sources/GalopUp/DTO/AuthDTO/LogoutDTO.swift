//
//  LogoutDTO.swift
//  GalopUp
//
//  Created by Emma on 01/06/2026.
//

import Vapor

struct LogoutDTO: Content, Validatable {
    let refreshToken: String
    
    static func validations(_ validations: inout Validations){
        validations.add("refreshToken", as: String.self)
    }
}
