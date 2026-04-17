//
//  QuestionReportEnum.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class QuestionReport: Model, @unchecked Sendable, Content {
    static let schema = "questionReport"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "reason")
    var reason: String
    
    @Field(key: "status")
    var status:StatusReportEnum
    
    @Parent(key: "question_id")
    var question: Question
    
    @Parent(key: "author_id")
    var author: User
    
    
    init() {}
    
}
