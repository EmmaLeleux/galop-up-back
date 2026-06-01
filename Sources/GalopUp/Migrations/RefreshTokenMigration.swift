//
//  RefreshTokenMigration.swift
//  GalopUp
//
//  Created by Emma on 29/05/2026.
//

import Fluent

struct RefreshTokenMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("refreshToken")
            .id()
            .field("token", .string, .required)
            .field("expire_at", .datetime)
            .field("user_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("refreshToken").delete()
    }
}
