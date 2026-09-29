//
//  CreateQuizDto.swift
//  GalopUp
//
//  Created by Emma on 28/09/2026.
//

import Vapor

struct CreateQuizDTO : Content, Validatable {
    let type : TypeQuizEnum
    let picture: File
    let description : String

    
    static func validations(_ validations: inout Validations){
        validations.add("description", as: String.self)
        
    }
    
    func toModel(picture: Picture) throws -> Quiz {
        guard let pictureId = picture.id else {
            throw Abort(.internalServerError, reason: "PICTURE_MISSING_ID")
        }
        
        let model = Quiz()
        model.type = type
        model.$picture.id = pictureId
        model.description = description
        return model
    }
   
}
