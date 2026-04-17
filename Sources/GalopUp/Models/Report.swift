//
//  ReportPostOrComment.swift
//  GalopUp
//
//  Created by Emma on 14/04/2026.
//

import Fluent
import Vapor

final class Report: Model, @unchecked Sendable, Content {
    static let schema = "report"
    
    @ID(key: .id)
    var id: UUID?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @Field(key: "reason")
    var reason: String
    
    @Field(key: "status")
    var status:StatusReportEnum
    
    @OptionalParent(key: "post_id")
    var post: Post?
    
    @OptionalParent(key: "comment_id")
    var comment: Comments?
    
    @OptionalParent(key: "event_id")
    var event: EventCustom?
    
    @OptionalParent(key: "user_id")
    var user: User?
    
    @Parent(key: "author_id")
    var author: User
    
    
    init() {}
    
}
