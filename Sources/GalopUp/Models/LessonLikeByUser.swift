//
//  LessonLikeByUser.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor



final class LessonLikeByUser: Model, @unchecked Sendable, Content {
    static let schema = "lessonLikeByUser"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "lesson_id")
    var lesson: Lesson
    
    @Parent(key: "user_id")
    var user: User
    
    
    init() {}
    
}
