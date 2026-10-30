//
//  AddPictureOnUserMigration.swift
//  GalopUp
//
//  Created by Emma on 01/07/2026.
//

import Fluent
import SQLKit
import Vapor

struct AddPictureOnUserMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("user")
            .field("picture_id", .uuid, .references("picture", "id"))
            .update()
    }

    func revert(on database: any Database) async throws {
            guard let sql = database as? any SQLDatabase else {
                throw Abort(.internalServerError, reason: "SQL_DATABASE_REQUIRED")
            }

            try await sql.raw("""
                ALTER TABLE `user`
                DROP FOREIGN KEY `1dda89506492a6abb68934b0adff659402384a54`,
                DROP INDEX `1dda89506492a6abb68934b0adff659402384a54`,
                DROP COLUMN `picture_id`
                """).run()
        }
}
