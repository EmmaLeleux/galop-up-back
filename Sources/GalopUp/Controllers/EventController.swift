//
//  EventController.swift
//  GalopUp
//
//  Created by Emma on 06/11/2026.
//

import Vapor
import Fluent
struct EventController: RouteCollection {
    
    let pictureService: PictureService
    let protectService: ProtectService
    func boot(routes: any RoutesBuilder) throws {
        let event = routes.grouped("event")
        
        let protectedRoutes = event.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, body: .collect(maxSize: "90mb"), use: createEvent)
        protectedRoutes.get(use: getEvents)
        protectedRoutes.on(.POST, ":eventId", "like", use: likeEvent)
        protectedRoutes.on(.DELETE, ":eventId", "like", use: unlikeEvent)
        protectedRoutes.on(.GET, "like", use: getLikesEvents)
        
    }
    
    @Sendable
    func createEvent(req: Request) async throws -> EventResponseDTO {
        let user = try await protectService.protect(req: req, roles: [.ADMIN])
        
        guard let userId = user.id else{
            throw Abort(.notFound, reason: "USER_NOT_FOUND")
        }
        
        let eventDto = try req.content.decode(CreateEventDto.self)
        
        let event =  eventDto.toModel()
        
        let createPicture = CreatePictureDto(file: eventDto.picture, bucketname: "event")
        var newKey: String = ""
        
        do{
            
            newKey = try await pictureService.upload(createPictureDto: createPicture)
            let newPictureId = createPicture.toModel(key: newKey)
            try await newPictureId.save(on: req.db)
            event.$picture.id = try newPictureId.requireID()
        }
        catch{
            if newKey != ""{
                try await pictureService.delete(key: newKey)
            }
            throw Abort(.badRequest, reason: "ERROR_UPLOADING_PICTURE")
        }
        
        event.$author.id = userId
        try await event.save(on: req.db)
        
        try await event.$author.load(on: req.db)
        try await event.$likes.load(on: req.db)
        try await event.author.$pictureId.load(on: req.db)
        try await event.$type.load(on: req.db)
        try await event.$picture.load(on: req.db)
        
        let urlEvent = try await pictureService.getPresignedUrl(key: event.picture.key)
        let urlAuthor = try await pictureService.getPresignedUrl(key: event.author.pictureId?.key ?? "")
        
        return event.toDTO(urlEvent: urlEvent, urlAuthor: urlAuthor, currentUserId: userId)
    }
    
    @Sendable
    func getEvents(req: Request) async throws -> [EventResponseDTO] {
        let user = try await protectService.protect(req: req, roles: [.ADMIN, .USER])
        
        let events = try await EventCustom.query(on: req.db)
            .filter(\.$deletedAt, .equal, nil)
            .filter(\.$startDate, .greaterThanOrEqual, Date())
            .with(\.$picture)
            .with(\.$author) { $0.with(\.$pictureId) }
            .with(\.$likes)
            .with(\.$type)
            .sort(\.$startDate, .ascending)
            .all()
        
        var eventsDto: [EventResponseDTO] = []
        
        for event in events {
            let urlEvent = try await pictureService.getPresignedUrl(key: event.picture.key)
            let urlAuthor = try await pictureService.getPresignedUrl(key: event.author.pictureId?.key ?? "")
            eventsDto.append(event.toDTO(urlEvent: urlEvent, urlAuthor: urlAuthor, currentUserId: try user.requireID()))
        }
        
        return eventsDto
    }
    
    @Sendable
    func getLikesEvents(req: Request) async throws -> [EventResponseDTO] {
        let user = try await protectService.protect(req: req, roles: [.ADMIN, .USER])
        
        let likedIds = try await EventLike.query(on: req.db)
            .filter(\.$user.$id, .equal, user.requireID())
            .all()
            .map { $0.$event.id }

        guard !likedIds.isEmpty else { return [] }

        let events = try await EventCustom.query(on: req.db)
            .filter(\.$id ~~ likedIds)
            .filter(\.$deletedAt, .equal, nil)
            .filter(\.$startDate, .greaterThanOrEqual, Date())
            .with(\.$picture)
            .with(\.$author) { $0.with(\.$pictureId) }
            .with(\.$likes)
            .with(\.$type)
            .sort(\.$startDate, .ascending)
            .all()
        
        var eventsDto: [EventResponseDTO] = []
        
        for event in events {
            let urlEvent = try await pictureService.getPresignedUrl(key: event.picture.key)
            let urlAuthor = try await pictureService.getPresignedUrl(key: event.author.pictureId?.key ?? "")
            eventsDto.append(event.toDTO(urlEvent: urlEvent, urlAuthor: urlAuthor, currentUserId: try user.requireID()))
        }
        
        return eventsDto
    }
    
    @Sendable
    func likeEvent(req: Request) async throws -> HTTPStatus {
        let user = try await protectService.protect(req: req, roles: [.USER])
        
        guard let eventId = req.parameters.get("eventId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let userId = user.id else{
            throw Abort(.badRequest)
        }
        
        let existingLike = try await EventLike.query(on: req.db)
            .filter(\.$event.$id, .equal, eventId)
            .filter(\.$user.$id, .equal, userId)
            .first()
        
        guard existingLike == nil else {
            return .noContent
        }
        
        let like = EventLike()
        like.$event.id = eventId
        like.$user.id = userId
        try await like.save(on: req.db)
        return .created
    }
    
    @Sendable
    func unlikeEvent(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        guard let eventId = req.parameters.get("eventId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        try await EventLike.query(on: req.db)
            .filter(\.$event.$id, .equal, eventId)
            .filter(\.$user.$id, .equal, payload.id)
            .delete()
        
        return .noContent
    }
    
}
