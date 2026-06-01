//
//  refreshToken.swift
//  GalopUp
//
//  Created by Emma on 29/05/2026.
//

import Fluent
import Vapor

final class RefreshToken: Model, @unchecked Sendable, Content {
    static let schema = "refreshToken"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String
    
    @Field(key: "expire_at")
    var expireAt: Date
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
}
