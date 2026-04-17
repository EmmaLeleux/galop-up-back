//
//  PostLikeByUserMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct PostLikeByUserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("postLikeByUser")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("post_id", .uuid, .required, .references("post", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("postLikeByUser").delete()
    }
}
