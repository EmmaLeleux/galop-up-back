//
//  CommentLikeByUser.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor



final class CommentLikeByUser: Model, @unchecked Sendable, Content {
    static let schema = "commentLikeByUser"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "comment_id")
    var comment: Comments
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
}
