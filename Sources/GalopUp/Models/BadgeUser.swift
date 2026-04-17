//
//  BadgeUser.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class BadgeUser: Model, @unchecked Sendable, Content {
    static let schema = "badgeUser"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "badge_id")
    var badge: Badge
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
}
