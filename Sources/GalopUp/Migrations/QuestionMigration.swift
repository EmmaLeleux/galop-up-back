//
//  QuestionMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct QuestionMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("question")
            .id()
            .field("question", .string, .required)
            .field("type", .string, .required)
            .field("difficulty", .string, .required)
            .field("status", .string, .required)
            .field("lesson_id", .uuid, .references("lesson", "id"))
            .field("theme_id", .uuid, .required, .references("themeQuestion", "id"))
            .field("user_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("question").delete()
    }
}
