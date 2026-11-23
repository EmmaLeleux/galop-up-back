//
//  EventCustomMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct EventMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("event")
            .id()
            .field("name", .string, .required)
            .field("description", .custom("TEXT"), .required)
            .field("picture_id", .uuid, .required, .references("picture", "id"))
            .field("startDate", .datetime, .required)
            .field("endDate", .datetime, .required)
            .field("deadline", .datetime)
            .field("placeName", .string, .required)
            .field("address", .string, .required)
            .field("latitude", .double, .required)
            .field("longitude", .double, .required)
            .field("price", .double)
            .field("capacity", .int)
            .field("levelMin", .string)
            .field("levelMax", .string)
            .field("equipment", .string)
            .field("deletedAt", .datetime)
            .field("type_id", .uuid, .required, .references("typeEvent", "id"))
            .field("author_id", .uuid, .required, .references("user", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("event").delete()
    }
}
