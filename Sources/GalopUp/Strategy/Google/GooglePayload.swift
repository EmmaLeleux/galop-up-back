//
//  GooglePayload.swift
//  GalopUp
//
//  Created by Emma on 15/05/2026.
//

import Vapor
import JWT

struct GooglePayload: JWTPayload, Authenticatable {
    var sub: String
    var email: String
    var name: String?
    var picture: String?
    var aud: String
    var exp: ExpirationClaim
    var iss: String
    var email_verified: Bool
    
    func verify(using signer: JWTSigner) throws {
        if email_verified == false {
            throw JWTError.claimVerificationFailure(name: "email_verified", reason: "not verified")
        }
        
        try exp.verifyNotExpired()
        
        guard let clientId = Environment.get("GOOGLE_ID_CLIENT_IOS"), aud == clientId else {
            throw JWTError.claimVerificationFailure(name: "aud", reason: "invalid audience")
        }
        guard iss == "accounts.google.com" || iss == "https://accounts.google.com" else {
            throw JWTError.claimVerificationFailure(name: "iss", reason: "invalid issuer")
        }
    }
}
