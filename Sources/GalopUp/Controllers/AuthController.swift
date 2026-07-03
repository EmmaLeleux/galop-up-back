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
        let tokens = try await RefreshToken.query(on: req.db)
            .filter(\.$user.$id == payload.id)
            .all()
        for refresh in tokens{
            if try Bcrypt.verify(refreshToken.refreshToken, created: refresh.token) {
                try await refresh.delete(on: req.db)
                return .noContent
                
            }
        }
        
        throw Abort(.notFound)
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
        
        
        if let user = try await User.query(on: req.db).filter(\.$googleId == googlePayload.sub).first(){
            
            return try await generateToken(user: user, req: req)
        }
        
        if let user = try await User.query(on: req.db).filter(\.$email == googlePayload.email).first(){
            
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
        print("entrée dans la route refresh")
        try RefreshTokenRequestDTO.validate(content: req)
        let refreshToken = try req.content.decode(RefreshTokenRequestDTO.self)
        
        let tokens = try await RefreshToken.query(on: req.db)
            .filter(\.$user.$id == refreshToken.userId)
            .all()
        for refresh in tokens{
            if try Bcrypt.verify(refreshToken.refreshToken, created: refresh.token) {
                if refresh.expireAt > Date() {
                    try await refresh.delete(on: req.db)
                    guard let user = try await User.find(refreshToken.userId.self, on: req.db) else{
                        throw Abort(.notFound)
                        
                    }
                    print ("génération des tokens")
                    return try await generateToken(user: user, req: req)
                }
                
                
            }
        }
        throw Abort(.notFound)
        
    }
 
    
    // MARK: Service Function
    
    private func generateToken(user: User, req: Request) async throws -> LoginResponse {
        let payloadAccess = UserPayload(id: user.id!, expiration: 60 * 15)
        let signerAccess = JWTSigner.hs256(key: req.application.config.JWT_SECRET)
        let accessToken = try signerAccess.sign(payloadAccess)
        
        let payloadRefresh = UserPayload(id: user.id!, expiration: 3600 * 24 * 30)
        let signerRefresh = JWTSigner.hs256(key: req.application.config.JWT_SECRET_REFRESH)
        let refreshTokenNotHash = try signerRefresh.sign(payloadRefresh)
        
        let refreshToken = RefreshToken()
        refreshToken.$user.id = user.id!
        refreshToken.expireAt = payloadRefresh.expiration
        refreshToken.token = try Bcrypt.hash(refreshTokenNotHash)
        
        try await refreshToken.save(on: req.db)
        
        return LoginResponse(accessToken: accessToken, accessTokenExpiration: payloadAccess.expiration, refreshToken: refreshTokenNotHash)
    }
    
}
