//
//  EventPostMigration.swift
//  GalopUp
//
//  Created by Emma on 04/07/2026.
//

import Fluent

struct EventPostMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("eventPost")
            .id()
            .field("event_id", .uuid, .required, .references("event", "id"))
            .field("post_id", .uuid, .required, .references("post", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("eventPost").delete()
    }
}
