//
//  ThemeQuestiobController.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor
struct ThemeQuestionController: RouteCollection {
    
    let protectService: ProtectService
    func boot(routes: any RoutesBuilder) throws {
        let themeQuestion = routes.grouped("theme-question")
        
        let protectedRoutes = themeQuestion.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, body: .collect(maxSize: "90mb"), use: createThemeQuestion)
        protectedRoutes.get(use: getThemeQuestions)

    }
    
    @Sendable
    func createThemeQuestion(req: Request) async throws -> ThemeQuestionResponseDto {
        _ = try await protectService.protect(req: req, roles: [.ADMIN])
        
        let themeQuestionDto = try req.content.decode(CreateThemeQuestionDTO.self)
        
        let themeQuestion = try themeQuestionDto.toModel()
        
        try await themeQuestion.save(on: req.db)
        
        return themeQuestion.toDTO()
    }
    
    @Sendable
    func getThemeQuestions(req: Request) async throws -> [ThemeQuestionResponseDto] {
        _ = try await protectService.protect(req: req, roles: [.ADMIN, .USER])
        
        let themeQuestions: [ThemeQuestion] = try await ThemeQuestion.query(on: req.db)
            .filter(\.$deletedAt, .equal, Date?.none)
            .sort(\.$name, .ascending)
            .all()
        
        
        return themeQuestions.map{ theme in
            return theme.toDTO()
        }
    }
    
}
