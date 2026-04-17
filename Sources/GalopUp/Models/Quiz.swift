//
//  Quiz.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class Quiz: Model, @unchecked Sendable, Content {
    static let schema = "quiz"
    
    @ID(key: .id)
    var id: UUID?
  
    @Field(key: "type")
    var type: String
    
    @Field(key: "picture")
    var picture: String
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
   
    @Children(for: \.$quiz) var session: [QuizSession]

    init() {}
    
}
