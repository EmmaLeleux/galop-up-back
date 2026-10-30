//
//  AuthController.swift
//  GalopUp
//
//  Created by Emma on 12/05/2026.
//

import Fluent
import Vapor
import JWT

struct AuthController: RouteCollection {
    
    
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        
        
        //routes  public
        auth.post("login", use: login)
        auth.post("register", use: register)
        auth.post("google", use: google)
        auth.post("refresh-token", use: refreshAccessToken)
        
        let protectedRoutes = auth.grouped(GalopUpMiddleware())
        protectedRoutes.delete("logout", use: logout)
        
        
    }
    
    @Sendable
    func login(req: Request) async throws -> LoginResponse {
        try LoginRequest.validate(content: req)
        let userData = try req.content.decode(LoginRequest.self)
        
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == userData.email)
            .filter(\.$deletedAt == nil)
            .first() else {
            throw Abort(.unauthorized, reason: "INVALID_CREDENTIALS")
        }
        
        if let password = user.password {
            guard try Bcrypt.verify(userData.password, created: password) else {
                throw Abort(.unauthorized, reason: "INVALID_CREDENTIALS")
            }
            
            return try await generateToken(user: user, req: req)
        }
        
        throw Abort(.unauthorized, reason: "INVALID_CREDENTIALS")
        
        
    }
    
    @Sendable
    func logout(req: Request) async throws -> HTTPStatus {
        try LogoutDTO.validate(content: req)
        let refreshToken = try req.content.decode(LogoutDTO.self)
        
        let payload = try req.auth.require(UserPayload.self)
        try await RefreshToken.query(on: req.db)
            .filter(\.$token == hashToken(refreshToken.refreshToken))
            .filter(\.$user.$id == payload.id)
            .delete()
        
        return .noContent
    }
    
    
    
    
    @Sendable
    func register(req: Request) async throws -> LoginResponse{
        try CreateUserDTO.validate(content: req)
        let userDto = try req.content.decode(CreateUserDTO.self)
        let user = userDto.toModel()
        
        try await UserController.verifyEmailUnique(email: user.email, req: req)
        
        guard let password = user.password else{
            throw Abort(.badRequest, reason: "PASSWORD_MISSING")
        }
        
        guard user.password == userDto.confirmPassword else{
            throw Abort(.badRequest, reason: "PASSWORDS_NOT_CHECKED")
        }
        
        user.password = try Bcrypt.hash(password)
        
        
        
        try await user.save(on: req.db)
        return try await generateToken(user: user, req: req)
    }
    
    @Sendable
    func google(req: Request) async throws -> LoginResponse{
        
        let googleToken = try req.content.decode(GoogleAuthDTO.self)
        let response = try await req.client.get("https://www.googleapis.com/oauth2/v3/certs")
        guard let body = response.body else {
            throw Abort(.internalServerError, reason: "NO_GOOGLE_BODY")
        }
        
        let jwks = try JSONDecoder().decode(JWKS.self, from: Data(buffer: body))
        let signers = JWTSigners()
        try signers.use(jwks: jwks)
        let googlePayload = try signers.verify(googleToken.token, as: GooglePayload.self)
        
        
        if let user = try await User.query(on: req.db)
            .filter(\.$googleId == googlePayload.sub)
            .filter(\.$deletedAt == nil)
            .first(){
            
            return try await generateToken(user: user, req: req)
        }
        
        if let user = try await User.query(on: req.db)
            .filter(\.$email == googlePayload.email)
            .filter(\.$deletedAt == nil)
            .first(){
            
            user.googleId = googlePayload.sub
            try await user.save(on: req.db)
            
            return try await generateToken(user: user, req: req)
        }
        
        let newUser = CreateUserWithGoogleDTO(email: googlePayload.email, googleId: googlePayload.sub).toModel()
        
        try await newUser.save(on: req.db)
        return try await generateToken(user: newUser, req: req)
        
    }
    
    
    @Sendable
    func refreshAccessToken(req: Request) async throws -> LoginResponse {
        try RefreshTokenRequestDTO.validate(content: req)
        let refreshToken = try req.content.decode(RefreshTokenRequestDTO.self)
        
        let signerRefresh = JWTSigner.hs256(key: req.application.config.JWT_SECRET_REFRESH)
        let payload = try signerRefresh.verify(refreshToken.refreshToken, as: UserPayload.self)
        
        guard let stored = try await RefreshToken.query(on: req.db)
            .filter(\.$token == hashToken(refreshToken.refreshToken))
            .filter(\.$user.$id == payload.id)
            .first(),
              stored.expireAt > Date()
        else {
            throw Abort(.unauthorized, reason: "INVALID_REFRESH_TOKEN")
        }
        try await stored.delete(on: req.db)
        guard let user = try await User.find(payload.id, on: req.db) else{
            throw Abort(.notFound)
            
        }
        return try await generateToken(user: user, req: req)
        
        
    }
    
    
    
    // MARK: Service Function
    
    private func generateToken(user: User, req: Request) async throws -> LoginResponse {
        let userId = try user.requireID()
        
        let payloadAccess = UserPayload(id: userId, expiration: 60 * 15)
        let signerAccess = JWTSigner.hs256(key: req.application.config.JWT_SECRET)
        let accessToken = try signerAccess.sign(payloadAccess)
        
        let payloadRefresh = UserPayload(id: userId, expiration: 3600 * 24 * 30)
        let signerRefresh = JWTSigner.hs256(key: req.application.config.JWT_SECRET_REFRESH)
        let refreshTokenNotHash = try signerRefresh.sign(payloadRefresh)
        
        let refreshToken = RefreshToken()
        refreshToken.$user.id = userId
        refreshToken.expireAt = payloadRefresh.expiration
        refreshToken.token = hashToken(refreshTokenNotHash)
        
        try await refreshToken.save(on: req.db)
        
        return LoginResponse(accessToken: accessToken, accessTokenExpiration: payloadAccess.expiration, refreshToken: refreshTokenNotHash)
    }
    
    private func hashToken(_ token: String) -> String {
        SHA256.hash(data: Data(token.utf8)).hex
    }
}
