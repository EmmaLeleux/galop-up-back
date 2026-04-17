//
//  ModerationMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct ModerationMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("moderation")
            .id()
            .field("reason", .string, .required)
            .field("isActive", .bool, .required)
            .field("createdAt", .datetime)
            .field("endAt", .datetime)
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("admin_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("moderation").delete()
    }
}
