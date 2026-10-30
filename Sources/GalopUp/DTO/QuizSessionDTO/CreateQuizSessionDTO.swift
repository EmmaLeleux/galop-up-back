//
//  CreateQuizSessionDTO.swift
//  GalopUp
//
//  Created by Emma on 27/10/2026.
//

import Vapor

struct CreateQuizSessionDTO : Content, Validatable {
    let quiz : TypeQuizEnum
    let difficulty: DifficultyQuizEnum
    let niveauGalop : LevelGalopLessonQuizEnum?

    
    static func validations(_ validations: inout Validations){
        validations.add("difficulty", as: DifficultyQuizEnum.self)
        validations.add("quiz", as: TypeQuizEnum.self)
        
    }
    
    func toModel(userId: UUID) throws -> QuizSession {
        
        let model = QuizSession()
        model.quiz = quiz
        model.difficulty = difficulty
        model.niveauGalop = niveauGalop
        model.nbGoodAnswer = 0
        model.nbQuestion = 0
        model.status = .EN_COURS
        model.$user.id = userId
        return model
    }
   
}
