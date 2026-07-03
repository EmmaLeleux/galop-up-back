//
//  PostPicture.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor

final class Picture: Model, @unchecked Sendable, Content {
    static let schema = "picture"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "key")
    var key: String
    
    @Field(key: "name")
    var name: String
    
    @OptionalField(key: "order")
    var order: Int?
    
    @OptionalParent(key: "post_id")
    var post: Post?
    
    @OptionalParent(key: "comment_id")
    var comment: Comments?
    
    @Children(for: \.$pictureId) var users: [User]

    
    
    init() {}
    
    func toDTO(url: String) -> GetPictureDto{
    
        
        return GetPictureDto(
            id: self.id ?? UUID(),
            key: self.key,
            name: self.name,
            url: url,
            order: self.order,
            
        )
        
    }
    
}
