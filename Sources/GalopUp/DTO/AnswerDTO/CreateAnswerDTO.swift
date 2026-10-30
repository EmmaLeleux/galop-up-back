//
//  CreateAnswerDTO.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor

struct CreateAnswerDTO : Content, Validatable {
    let description : String
    let isTrue: Bool
    
    static func validations(_ validations: inout Validations){
        validations.add("description", as: String.self)
        validations.add("isTrue", as: Bool.self)
        
    }
    
    func toModel(questionId: UUID) throws -> Answer {
        
        let model = Answer()
        model.description = description
        model.isTrue = isTrue
        model.$question.id = questionId
        return model
    }
   
}
