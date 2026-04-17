//
//  QuizSessionMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct QuizSessionMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("quizSession")
            .id()
            .field("difficulty", .string, .required)
            .field("niveauGalop", .string, .required)
            .field("createdAt", .datetime)
            .field("nbQuestion", .int, .required)
            .field("nbGoodAnswer", .int, .required)
            .field("chrono", .datetime, .required)
            .field("quiz_id", .uuid, .required, .references("quiz", "id"))
            .field("user_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("quizSession").delete()
    }
}
