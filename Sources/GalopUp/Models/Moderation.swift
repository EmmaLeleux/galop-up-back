//
//  Moderation.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor



final class Moderation: Model, @unchecked Sendable, Content {
    static let schema = "moderation"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "reason")
    var reason: String
    
    @Field(key: "isActive")
    var isActive: Bool
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "endAt")
    var endAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    @Parent(key: "admin_id")
    var admin: User
    
    init() {}
    
}
