//
//  CreatePostDTO.swift
//  GalopUp
//
//  Created by Emma on 04/07/2026.
//

import Vapor

struct CreatePostDTO : Content, Validatable {
    let title : String
    let content : String
    let pictures: [File]
    let tags: [TagCustom]
    let lessons: [Lesson]
    let events: [EventCustom]
    
    static func validations(_ validations: inout Validations){
        validations.add("title", as: String.self)
        validations.add("content", as: String.self)
        
    }
    
    func toModel() -> Post {
        let model = Post()
        
        return model
    }
   
}
