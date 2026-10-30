//
//  QuizSessionQuestion.swift
//  GalopUp
//
//  Created by Emma on 29/10/2026.
//

import Fluent
import Vapor

final class QuizSessionQuestion: Model, @unchecked Sendable, Content {
    static let schema = "quizSessionQuestion"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "order")
    var order: Int
    
    @Field(key: "isCorrect")
    var isCorrect: Bool
    
    @Parent(key: "quizSession_id")
    var quizSession: QuizSession
    
    @Parent(key: "question_id")
    var question: Question
    
}
