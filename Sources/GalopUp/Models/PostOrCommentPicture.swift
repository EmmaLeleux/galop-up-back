//
//  PostPicture.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor

final class PostOrCommentPicture: Model, @unchecked Sendable, Content {
    static let schema = "postOrCommentPicture"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "picture")
    var picture: String
    
    @Field(key: "order")
    var order: Int
    
    @OptionalParent(key: "post_id")
    var post: Post?
    
    @OptionalParent(key: "comment_id")
    var comment: Comments?
    
    
    init() {}
    
}
