//
//  Badge.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class Badge: Model, @unchecked Sendable, Content {
    static let schema = "badge"
    
    @ID(key: .id)
    var id: UUID?
  
    @Field(key: "name")
    var name: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "picture")
    var picture: String
    
    @Field(key: "typeObjectif")
    var typeObjectif: TypeObjectifBadgeEnum
    
    @Field(key: "objectifValue")
    var objectifValue: Int
    
    @Field(key: "deletedAt")
    var deletedAt: Date?
    
    @Siblings(through: BadgeUser.self, from: \.$badge, to: \.$user)
    var users: [User]
   
    
    
    init() {}
    
}
