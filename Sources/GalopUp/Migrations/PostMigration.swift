//
//  PostMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct PostMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("post")
            .id()
            .field("title", .string, .required)
            .field("content", .string, .required)
            .field("createdAt", .datetime)
            .field("deletedAt", .datetime)
            .field("user_id", .uuid, .required,.references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("post").delete()
    }
}
