//
//  CreateUserWithGoogleDTO.swift
//  GalopUp
//
//  Created by Emma on 15/05/2026.
//

import Vapor

struct CreateUserWithGoogleDTO : Content {
    let email : String
    let googleId : String
    
    func toModel() -> User {
        let model = User()
        model.email = email
        model.googleId = googleId
        model.role = UserRoleEnum.USER
        model.isBanned = false
        return model
    }
   
}
