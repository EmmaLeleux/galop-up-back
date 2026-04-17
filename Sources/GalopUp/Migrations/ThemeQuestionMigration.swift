//
//  ThemeQuestionMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct ThemeQuestionMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("themeQuestion")
            .id()
            .field("name", .string, .required)
            .field("deletedAt", .datetime)
            .unique(on: "name")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("themeQuestion").delete()
    }
}
