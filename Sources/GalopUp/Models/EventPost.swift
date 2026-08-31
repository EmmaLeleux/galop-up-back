//
//  EventPost.swift
//  GalopUp
//
//  Created by Emma on 04/07/2026.
//

import Fluent
import Vapor



final class EventPost: Model, @unchecked Sendable, Content {
    static let schema = "eventPost"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "event_id")
    var event: EventCustom
    
    @Parent(key: "post_id")
    var post: Post
    
    
    init() {}
    
}
