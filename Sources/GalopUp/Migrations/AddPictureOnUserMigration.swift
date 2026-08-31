//
//  AddPictureOnUserMigration.swift
//  GalopUp
//
//  Created by Emma on 01/07/2026.
//

import Fluent

struct AddPictureOnUserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("user")
          .field("picture_id", .uuid, .references("picture", "id"))
            .update()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("user")
            .deleteField("picture_id")
            .update()
    }
}
