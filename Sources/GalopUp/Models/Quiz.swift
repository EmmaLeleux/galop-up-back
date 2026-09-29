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
    var type: TypeQuizEnum
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Parent(key: "picture")
    var picture: Picture
   
    @Children(for: \.$quiz) var session: [QuizSession]

    init() {}
    
    func toDTO(url: String) -> QuizResponseDto{
        
        return QuizResponseDto(
            id: self.id ?? UUID(),
            type: self.type,
            picture: self.picture.toDTO(url: url),
            description: self.description
        )
        
    }
    
}
