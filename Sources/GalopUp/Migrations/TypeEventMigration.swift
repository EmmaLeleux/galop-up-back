//
//  TypeEventMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct TypeEventMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("typeEvent")
            .id()
            .field("name", .string, .required)
            .field("deletedAt", .datetime)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("typeEvent").delete()
    }
}
