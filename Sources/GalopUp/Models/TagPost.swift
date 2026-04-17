//
//  TagPost.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor



final class TagPost: Model, @unchecked Sendable, Content {
    static let schema = "tagPost"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "post_id")
    var post: Post
    
    @Parent(key: "tag_id")
    var tag: TagCustom
    
    
    init() {}
    
}
