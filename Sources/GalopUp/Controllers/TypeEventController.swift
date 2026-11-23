//
//  TypeEventController.swift
//  GalopUp
//
//  Created by Emma on 05/11/2026.
//

import Vapor
struct TypeEventController: RouteCollection {
    
    let protectService: ProtectService
    func boot(routes: any RoutesBuilder) throws {
        let typeEvent = routes.grouped("type-event")
        
        let protectedRoutes = typeEvent.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, use: createTypeEvent)
        protectedRoutes.get(use: getTypeEvents)

    }
    
    @Sendable
    func createTypeEvent(req: Request) async throws -> TypeEventResponseDTO {
        _ = try await protectService.protect(req: req, roles: [.ADMIN])
        
        let typeEventDto = try req.content.decode(CreateTypeEventDto.self)
        
        let typeEvent = typeEventDto.toModel()
        
        try await typeEvent.save(on: req.db)
        
        return typeEvent.toDTO()
    }
    
    @Sendable
    func getTypeEvents(req: Request) async throws -> [TypeEventResponseDTO] {
        _ = try await protectService.protect(req: req, roles: [.ADMIN, .USER])
        
        let typeEvents: [TypeEvent] = try await TypeEvent.query(on: req.db)
            .filter(\.$deletedAt, .equal, Date?.none)
            .sort(\.$name, .ascending)
            .all()
        
        
        return typeEvents.map{ type in
            return type.toDTO()
        }
    }
    
}
