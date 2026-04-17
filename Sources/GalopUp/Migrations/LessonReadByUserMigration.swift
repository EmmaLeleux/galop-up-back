//
//  LessonReadByUserMigration.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent

struct LessonReadByUserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("lessonReadByUser")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("lesson_id", .uuid, .required, .references("lesson", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("lessonReadByUser").delete()
    }
}
