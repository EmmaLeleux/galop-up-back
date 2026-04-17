//
//  LessonPostMigration.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Fluent

struct LessonPostMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("lessonPost")
            .id()
            .field("lesson_id", .uuid, .required, .references("lesson", "id"))
            .field("post_id", .uuid, .required, .references("post", "id"))
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("lessonPost").delete()
    }
}
