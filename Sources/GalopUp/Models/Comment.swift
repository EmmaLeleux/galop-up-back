//
//  Comment.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor

final class Comments: Model, @unchecked Sendable, Content {
    static let schema = "comment"
    
    @ID(key: .id)
    var id: UUID?
  
    @Field(key: "content")
    var content: String
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    @OptionalParent(key: "post_id")
    var post: Post?
    
    @OptionalParent(key: "comment_id")
    var comment: Comments?
    
    @Children(for: \.$comment) var listComments: [Comments]
    
    @Children(for: \.$comment) var pictures: [Picture]
    
    @Children(for: \.$comment) var reported: [Report]
    
    @Siblings(through: CommentLikeByUser.self, from: \.$comment, to: \.$user)
    var likes: [User]
   
    
    
    init() {}
    
}
