//
//  QuestionReportMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct QuestionReportMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("questionReport")
            .id()
            .field("createdAt", .datetime)
            .field("reason", .string, .required)
            .field("status", .string, .required)
            .field("question_id", .uuid, .required, .references("question", "id"))
            .field("author_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("questionReport").delete()
    }
}
