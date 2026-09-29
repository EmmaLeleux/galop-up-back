//
//  QuizController.swift
//  GalopUp
//
//  Created by Emma on 28/09/2026.
//

import Vapor
struct QuizController: RouteCollection {
    
    let pictureService: PictureService
    let protectService: ProtectService
    func boot(routes: any RoutesBuilder) throws {
        let quiz = routes.grouped("quiz")
        
        let protectedRoutes = quiz.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, body: .collect(maxSize: "90mb"), use: createQuiz)
        protectedRoutes.get(use: getQuizzes)

    }
    
    @Sendable
    func createQuiz(req: Request) async throws -> QuizResponseDto {
        _ = try await protectService.protect(req: req, roles: [.ADMIN])
        
        let quizDto = try req.content.decode(CreateQuizDTO.self)
        
        let createPicture = CreatePictureDto(file: quizDto.picture)
        
        let newKey = try await pictureService.upload(createPictureDto: createPicture)
        let newPicture = createPicture.toModel(key: newKey)
        try await newPicture.save(on: req.db)
        
        let quiz = try quizDto.toModel(picture: newPicture)
        
        try await quiz.save(on: req.db)
        
        try await quiz.$picture.load(on: req.db)
        
        let url = try await pictureService.getPresignedUrl(key: quiz.picture.key)
        
        return quiz.toDTO(url: url)
    }
    
    @Sendable
    func getQuizzes(req: Request) async throws -> [QuizResponseDto] {
        _ = try await protectService.protect(req: req, roles: [.ADMIN, .USER])
        
        let quizzes: [Quiz] = try await Quiz.query(on: req.db)
            .with(\.$picture)
            .all()
        
        var quizzesDto: [QuizResponseDto] = []
        
        for quiz in quizzes {
            let url = try await pictureService.getPresignedUrl(key: quiz.picture.key)
            quizzesDto.append(quiz.toDTO(url: url))
        }
        
        return quizzesDto
    }
    
}
