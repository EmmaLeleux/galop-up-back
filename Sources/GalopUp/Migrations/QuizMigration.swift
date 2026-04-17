//
//  QuizMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct QuizMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("quiz")
            .id()
            .field("type", .string, .required)
            .field("picture", .string, .required)
            .field("deletedAt", .datetime)
            .unique(on: "type")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("quiz").delete()
    }
}
