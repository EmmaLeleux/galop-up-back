//
//  LessonMigration.swift
//  GalopUp
//
//  Created by Emma on 13/04/2026.
//

import Fluent

struct LessonMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("lesson")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("level", .string, .required)
            .field("createdAt", .datetime)
            .field("picture_id", .uuid, .required, .references("picture", "id"))
            .field("status", .string, .required)
            .field("content", .custom("TEXT"), .required)
            .create()
    }
    
    
    func revert(on database: any Database) async throws {
        try await database.schema("lesson").delete()
    }
}
