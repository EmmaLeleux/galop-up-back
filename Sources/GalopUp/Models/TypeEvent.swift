//
//  TypeEvent.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class TypeEvent: Model, @unchecked Sendable, Content {
    static let schema = "typeEvent"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Children(for: \.$type) var event: [EventCustom]
    
    
    init() {}
    
}
