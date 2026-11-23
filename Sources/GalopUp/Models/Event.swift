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
    
    @Parent(key: "picture_id")
    var picture: Picture
    
    @Field(key: "startDate")
    var startDate: Date
    
    @Field(key: "endDate")
    var endDate: Date
    
    @OptionalField(key: "deadline")
    var deadline: Date?
    
    @Field(key: "placeName")
    var placeName: String
    
    @Field(key: "address")
    var address: String
    
    @Field(key: "latitude")
    var latitude: Double
    
    @Field(key: "longitude")
    var longitude: Double
    
    @OptionalField(key: "price")
    var price: Double?
    
    @OptionalField(key: "capacity")
    var capacity: Int?
    
    @OptionalField(key: "levelMin")
    var levelMin: LevelGalopUserEnum?
    
    @OptionalField(key: "levelMax")
    var levelMax: LevelGalopUserEnum?
    
    @OptionalField(key: "equipment")
    var equipment: String?
    
    @OptionalField(key: "deletedAt")
    var deletedAt: Date?
    
    @Parent(key: "type_id")
    var type: TypeEvent
    
    @Parent(key: "author_id")
    var author: User
    
    @Children(for: \.$event) var reports: [Report]
    
    @Siblings(through: EventLike.self, from: \.$event, to: \.$user)
    var likes: [User]
    
    @Siblings(through: EventPost.self, from: \.$event, to: \.$post)
    var posts: [Post]
    
    init() {}
    
    func toDTO(urlEvent: String, urlAuthor: String, currentUserId: UUID) -> EventResponseDTO {
        
        return EventResponseDTO(
            id: self.id ?? UUID(),
            name: self.name,
            description: self.description,
            picture: self.picture.toDTO(url: urlEvent),
            startDate: self.startDate,
            endDate: self.endDate,
            deadline: self.deadline,
            placeName: self.placeName,
            address: self.address,
            latitude: self.latitude,
            longitude: self.longitude,
            price: self.price,
            capacity: self.capacity,
            levelMin: self.levelMin,
            levelMax: self.levelMax,
            equipment: self.equipment,
            typeEvent: self.type.toDTO(),
            author: self.author.toPublicDTO(url: urlAuthor),
            isLikeByMe: self.likes.contains { $0.id == currentUserId })
    }
    
}
