//
//  CommentLikeByUserMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct CommentLikeByUserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("commentLikeByUser")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("comment_id", .uuid, .required, .references("comment", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("commentLikeByUser").delete()
    }
}
