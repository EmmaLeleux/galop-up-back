//
//  User.swift
//  GalopUp
//
//  Created by Emma on 13/04/2026.
//

import Fluent
import Vapor

final class User: Model, @unchecked Sendable, Content {
    static let schema = "user"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String?
    
    @Field(key: "birthday")
    var birthday: Date?
    
    @Field(key: "googleId")
    var googleId: String?
    
    @Field(key: "appleId")
    var appleId: String?
    
    @Field(key: "level")
    var level: LevelGalopUserEnum?
    
    @Field(key: "picture")
    var picture: String?
    
    @Field(key: "role")
    var role: UserRoleEnum
    
    @Field(key: "isBanned")
    var isBanned: Bool
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Children(for: \.$user) var posts: [Post]
    
    @Children(for: \.$author) var reportMake: [Report]
    
    @Children(for: \.$user) var reported: [Report]
    
    @Children(for: \.$author) var event: [EventCustom]
    
    @Children(for: \.$user) var quiz: [QuizSession]
    
    @Children(for: \.$author) var reportQuestion: [QuestionReport]

    @Children(for: \.$user) var sanctions: [Moderation]
    
    @Children(for: \.$admin) var moderations: [Moderation]
    
    @Children(for: \.$user) var questionCreated: [Question]


    @Siblings(through: LessonLikeByUser.self, from: \.$user, to: \.$lesson)
    var lessonLikes: [Lesson]
    
    @Siblings(through: LessonReadByUser.self, from: \.$user, to: \.$lesson)
    var lessonReads: [Lesson]
    
    @Siblings(through: PostLikeByUser.self, from: \.$user, to: \.$post)
    var postLikes: [Post]
    
    @Siblings(through: BadgeUser.self, from: \.$user, to: \.$badge)
    var badges: [Badge]
    
    @Siblings(through: EventLike.self, from: \.$user, to: \.$event)
    var eventLikes: [EventCustom]
    
    init() {}
    
}
