//
//  ThemeQuestion.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//


import Fluent
import Vapor

final class ThemeQuestion: Model, @unchecked Sendable, Content {
    static let schema = "themeQuestion"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Children(for: \.$theme) var question: [Question]
    
    
    init() {}
    
}
