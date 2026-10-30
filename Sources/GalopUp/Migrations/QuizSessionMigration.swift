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
            .field("niveauGalop", .string)
            .field("createdAt", .datetime)
            .field("endAt", .datetime)
            .field("nbQuestion", .int, .required)
            .field("nbGoodAnswer", .int, .required)
            .field("chrono", .double)
            .field("timeLimit", .int)
            .field("status", .string, .required)
            .field("quiz", .string, .required)
            .field("user_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("quizSession").delete()
    }
}
