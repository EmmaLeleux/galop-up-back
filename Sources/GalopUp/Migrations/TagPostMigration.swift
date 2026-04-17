//
//  TagPostMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct TagPostMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("tagPost")
            .id()
            .field("tag_id", .uuid, .required, .references("tagCustom", "id"))
            .field("post_id", .uuid, .required, .references("post", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("tagPost").delete()
    }
}
