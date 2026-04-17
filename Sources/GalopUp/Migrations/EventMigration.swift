//
//  EventCustomMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct EventMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("event")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("picture", .string, .required)
            .field("date", .datetime, .required)
            .field("place", .string, .required)
            .field("level", .string, .required)
            .field("lattitude", .double, .required)
            .field("longitude", .double, .required)
            .field("deletedAt", .datetime)
            .field("type_id", .uuid, .required, .references("typeEvent", "id"))
            .field("author_id", .uuid, .required, .references("user", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("event").delete()
    }
}
