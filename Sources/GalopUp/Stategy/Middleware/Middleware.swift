//
//  Middleware.swift
//  GalopUp
//
//  Created by Emma on 17/04/2026.
//

import Vapor
import JWT


final class GalopUpMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: any Responder) -> EventLoopFuture<Response> {
        guard let token = request.headers["Authorization"].first?.split(separator: " ").last else {
            return request.eventLoop.future(error: Abort(.unauthorized, reason: "INVALID_TOKEN"))
        }
        
        
        let signer = JWTSigner.hs256(key: request.application.config.JWT_SECRET)
        let payload : UserPayload
        
        do {
            payload = try signer.verify(String(token), as: UserPayload.self)
            
        }  catch {
            return request.eventLoop.future(error: Abort(.unauthorized, reason: "INVALID_TOKEN"))
        }

        request.auth.login(payload)
        
        return next.respond(to: request)

    }
    
    
    
   
}
