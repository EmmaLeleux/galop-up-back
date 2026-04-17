//
//  AnswerMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct AnswerMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("answer")
            .id()
            .field("description", .string, .required)
            .field("isTrue", .bool, .required)
            .field("question_id", .uuid, .required, .references("question", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("answer").delete()
    }
}
