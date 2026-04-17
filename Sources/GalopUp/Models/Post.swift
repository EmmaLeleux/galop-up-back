//
//  Post.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor

final class Post: Model, @unchecked Sendable, Content {
    static let schema = "post"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Parent(key: "user_id")
    var user: User
    
    @Children(for: \.$post) var pictures: [PostOrCommentPicture]
    
    @Children(for: \.$post) var comment: [Comments]
    
    @Children(for: \.$post) var reported: [Report]
    
    @Siblings(through: LessonPost.self, from: \.$post, to: \.$lesson)
    var lessons: [Lesson]
    
    @Siblings(through: PostLikeByUser.self, from: \.$post, to: \.$user)
    var likes: [User]
    
    @Siblings(through: TagPost.self, from: \.$post, to: \.$tag)
    var tags: [TagCustom]
    
    
    init() {}
    
}
