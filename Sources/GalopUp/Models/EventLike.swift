//
//  EventLike.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor



final class EventLike: Model, @unchecked Sendable, Content {
    static let schema = "eventLike"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "event_id")
    var event: EventCustom
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
}
