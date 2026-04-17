//
//  Tag.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor



final class TagCustom: Model, @unchecked Sendable, Content {
    static let schema = "tagCustom"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: TagPost.self, from: \.$tag, to: \.$post)
    var posts: [Post]
    
    
    init() {}
    
}
