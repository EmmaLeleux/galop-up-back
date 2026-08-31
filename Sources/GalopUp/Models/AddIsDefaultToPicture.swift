//
//  AddIsDefaultToPicture.swift
//  GalopUp
//
//  Created by Emma on 04/08/2026.
//

import Fluent

struct AddIsDefaultToPictureMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("picture")
            .field("isDefault", .bool)
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("picture")
            .deleteField("isDefault")
            .update()
    }
}
