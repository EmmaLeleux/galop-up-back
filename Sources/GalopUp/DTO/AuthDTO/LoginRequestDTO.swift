//
//  LoginRequestDTO.swift
//  GalopUp
//
//  Created by Emma on 12/05/2026.
//

import Vapor

struct LoginRequest : Content, Validatable {
    let email : String
    let password : String
    
    static func validations(_ validations: inout Validations){
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self)
    }
}
