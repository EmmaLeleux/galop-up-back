//
//  PostOrCommentPictureMigration.swift
//  GalopUp
//
//  Created by Emma on 16/04/2026.
//

import Fluent

struct PictureMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("picture")
            .id()
            .field("key", .string, .required)
            .field("name", .string, .required)
            .field("order", .int)
            .field("post_id", .uuid, .references("post", "id"))
            .field("comment_id", .uuid, .references("comment", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("picture").delete()
    }
}
