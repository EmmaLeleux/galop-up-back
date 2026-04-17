//
//  PostLikeByUser.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor



final class PostLikeByUser: Model, @unchecked Sendable, Content {
    static let schema = "postLikeByUser"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "post_id")
    var post: Post
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
}
