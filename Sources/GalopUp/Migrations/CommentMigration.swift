//
//  CommentMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct CommentMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("comment")
            .id()
            .field("content", .string, .required)
            .field("description", .string, .required)
            .field("createdAt", .datetime)
            .field("deletedAt", .datetime)
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("post_id", .uuid, .references("post", "id"))
            .field("comment_id", .uuid, .references("comment", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("comment").delete()
    }
}
