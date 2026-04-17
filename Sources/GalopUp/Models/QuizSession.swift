//
//  QuizSession.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class QuizSession: Model, @unchecked Sendable, Content {
    static let schema = "quizSession"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "difficulty")
    var difficulty: DifficultyQuizEnum
    
    @Field(key: "niveauGalop")
    var niveauGalop: LevelGalopLessonQuizEnum
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "nbQuestion")
    var nbQuestion: Int
    
    @Field(key: "nbGoodAnswer")
    var nbGoodAnswer: Int
    
    @Field(key: "chrono")
    var chrono: Date
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "quiz_id")
    var quiz: Quiz
    
    init() {}
    
}
