//
//  userPayload.swift
//  GalopUp
//
//  Created by Emma on 11/05/2026.
//

import Vapor
import JWT


struct UserPayload : JWTPayload, Authenticatable {
    var id: UUID
    var expiration: Date
    
    func verify(using signer: JWTKit.JWTSigner) throws {
        if self.expiration < Date(){
            throw JWTError.claimVerificationFailure(name: "INVALID_TOKEN", reason: "INVALID_TOKEN")
        }
    }
    
    init(id: UUID, expiration: Double) {
        self.id = id
        self.expiration = Date().addingTimeInterval(expiration)
    }
    
}
