//
//  Lesson.swift
//  GalopUp
//
//  Created by Emma on 13/04/2026.
//

import Fluent
import Vapor

final class Lesson: Model, @unchecked Sendable, Content {
    static let schema = "lesson"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "level")
    var level: LevelGalopLessonQuizEnum
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "picture")
    var picture: String
    
    @Field(key: "status")
    var status: LessonStatusEnum
    
    @Field(key: "content")
    var content: String
    
    @Siblings(through: LessonLikeByUser.self, from: \.$lesson, to: \.$user)
    var likes: [User]
    
    @Siblings(through: LessonReadByUser.self, from: \.$lesson, to: \.$user)
    var reads: [User]
    
    @Siblings(through: LessonPost.self, from: \.$lesson, to: \.$post)
    var posts: [Post]
    
    init() {}
    
}
