//
//  LessonLikeByUserMigration.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent

struct LessonLikeByUserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("lessonLikeByUser")
            .id()
            .field("user_id", .uuid, .required, .references("user", "id"))
            .field("lesson_id", .uuid, .required, .references("lesson", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("lessonLikeByUser").delete()
    }
}
