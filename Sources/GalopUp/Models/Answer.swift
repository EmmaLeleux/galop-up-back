//
//  Answer.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class Answer: Model, @unchecked Sendable, Content {
    static let schema = "answer"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "isTrue")
    var isTrue: Bool
    
    @Parent(key: "question_id")
    var question: Question
    
    
    init() {}
    
}
