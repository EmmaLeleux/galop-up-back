//
//  createThemeQuestionDTO.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor

struct CreateThemeQuestionDTO : Content, Validatable {
    let name : String

    
    static func validations(_ validations: inout Validations){
        validations.add("name", as: String.self)
        
    }
    
    func toModel() throws -> ThemeQuestion {
        
        let model = ThemeQuestion()
        model.name = name
        return model
    }
   
}
