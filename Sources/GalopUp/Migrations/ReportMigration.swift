//
//  ReportMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct ReportMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("report")
            .id()
            .field("createdAt", .datetime)
            .field("reason", .string, .required)
            .field("status", .string, .required)
            .field("post_id", .uuid, .references("post", "id"))
            .field("comment_id", .uuid, .references("comment", "id"))
            .field("event_id", .uuid, .references("event", "id"))
            .field("user_id", .uuid, .references("user", "id"))
            .field("author_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("report").delete()
    }
}
