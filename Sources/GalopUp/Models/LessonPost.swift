//
//  LessonPost.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor



final class LessonPost: Model, @unchecked Sendable, Content {
    static let schema = "lessonPost"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "lesson_id")
    var lesson: Lesson
    
    @Parent(key: "post_id")
    var post: Post
    
    
    init() {}
    
}
