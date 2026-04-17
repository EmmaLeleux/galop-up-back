//
//  BadgeUserMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct BadgeUserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("badgeUser")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("badge_id", .uuid, .required, .references("badge", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("badgeUser").delete()
    }
}
