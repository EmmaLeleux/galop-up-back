//
//  CreateQuestionDTO.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor

struct CreateQuestionDTO : Content, Validatable {
    let question : String
    let type: TypeQuestionEnum
    let difficulty : LevelGalopLessonQuizEnum
    let themeId : UUID
    let picture : File?
    let answer : [CreateAnswerDTO]
    
    static func validations(_ validations: inout Validations){
        validations.add("question", as: String.self)
        
    }
    
    func toModel(userId: UUID, status: StatusQuestionEnum = .EN_ATTENTE) throws -> Question {
        
        let model = Question()
        model.question = question
        model.type = type
        model.status = status
        model.difficulty = difficulty
        model.$theme.id = themeId
        model.$user.id = userId
        return model
    }
   
}
