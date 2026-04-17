//
//  Event.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class EventCustom: Model, @unchecked Sendable, Content {
    static let schema = "event"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "picture")
    var picture: String
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "place")
    var place: String
    
    @Field(key: "level")
    var level: LevelGalopUserEnum?
    
    @Field(key: "lattitude")
    var lattitude: Double
    
    @Field(key: "longitude")
    var longitude: Double
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Parent(key: "type_id")
    var type: TypeEvent
    
    @Parent(key: "author_id")
    var author: User
    
    @Children(for: \.$event) var reports: [Report]
    
    @Siblings(through: EventLike.self, from: \.$event, to: \.$user)
    var likes: [User]
    
    init() {}
    
}
