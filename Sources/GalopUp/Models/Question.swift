//
//  Question.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class Question: Model, @unchecked Sendable, Content {
    static let schema = "question"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "question")
    var question: String
    
    @Field(key: "type")
    var type: TypeQuestionEnum
    
    @Field(key: "difficulty")
    var difficulty: LevelGalopLessonQuizEnum
    
    @Field(key: "status")
    var status: StatusQuestionEnum
    
    @OptionalParent(key: "lesson_id")
    var lesson: Lesson?
    
    @Parent(key: "theme_id")
    var theme: ThemeQuestion
    
    @Parent(key: "user_id")
    var user: User
    
    @Children(for: \.$question) var reportQuestion: [QuestionReport]

    @Children(for: \.$question) var answers: [Answer]

    
    init() {}
    
}
