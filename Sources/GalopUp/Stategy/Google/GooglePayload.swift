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

    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
        
        guard aud.contains(Environment.get("GOOGLE_ID_CLIENT_IOS") ?? "") else {
            throw JWTError.claimVerificationFailure(name: "aud", reason: "invalid audience")
        }
        guard iss == "accounts.google.com" || iss == "https://accounts.google.com" else {
            throw JWTError.claimVerificationFailure(name: "iss", reason: "invalid issuer")
        }
    }
}
