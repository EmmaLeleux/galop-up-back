//
//  BadgeMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct BadgeMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("badge")
            .id()
            .field("name", .string, .required)
            .field("description", .string, .required)
            .field("picture", .string, .required)
            .field("typeObjectif", .string, .required)
            .field("objectifValue", .int, .required)
            .field("deletedAt", .datetime)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("badge").delete()
    }
}
