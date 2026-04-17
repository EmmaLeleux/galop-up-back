//
//  UserMigration.swift
//  GalopUp
//
//  Created by Emma on 13/04/2026.
//

import Fluent

struct UserMigration : AsyncMigration {
    func prepare(on database: any Database) async throws {
        
        try await database.schema("user")
            .id()
            .field("username", .string)
            .field("email", .string, .required)
            .field("password", .string)
            .field("birthday", .datetime)
            .field("googleId", .string)
            .field("appleId", .string)
            .field("level", .string)
            .field("picture", .string)
            .field("role", .string, .required)
            .field("isBanned", .bool, .required)
            .field("deletedAt", .datetime)
            .unique(on: "username")
            .unique(on: "email")
            .unique(on: "googleId")
            .unique(on: "appleId")
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema("user").delete()
    }
}
