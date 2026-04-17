//
//  EventLikeMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct EventLikeMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("eventLike")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("event_id", .uuid, .required, .references("event", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("eventLike").delete()
    }
}
