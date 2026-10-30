//
//  QuizSessionQuestion.swift
//  GalopUp
//
//  Created by Emma on 29/10/2026.
//

import Fluent

struct QuizSessionQuestionMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("quizSessionQuestion")
            .id()
            .field("order", .int, .required)
            .field("isCorrect", .bool, .required)
            .field("quizSession_id", .uuid, .required, .references("quizSession", "id"))
            .field("question_id", .uuid, .required, .references("question", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("quizSessionQuestion").delete()
    }
}
