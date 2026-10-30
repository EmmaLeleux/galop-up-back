//
//  QuestionController.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor
import FluentSQL

struct QuestionController: RouteCollection {
    
    let pictureService: PictureService
    let protectService: ProtectService
    func boot(routes: any RoutesBuilder) throws {
        let question = routes.grouped("question")
        
        let protectedRoutes = question.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, body: .collect(maxSize: "90mb"), use: createQuestion)
        
    }
    
    @Sendable
    func createQuestion(req: Request) async throws -> QuestionResponseDTO {
        let user = try await protectService.protect(req: req, roles: [.ADMIN])
        
        guard let userId = user.id else{
            throw Abort (.badRequest, reason: "USER_NOT_FOUND")
        }
        
        let questionDto = try req.content.decode(CreateQuestionDTO.self)
        
        if questionDto.answer.count == 0{
            throw Abort (.badRequest, reason: "ANSWER_EMPTY")
        }
        
        if questionDto.type.nbAnswer != questionDto.answer.count{
            throw Abort (.badRequest, reason: "NUMBER_OF_ANSWER_NOT_VALID")
        }
        
        var nbGoodAnswer: Int = 0
        for answer in questionDto.answer{
            if answer.isTrue{
                nbGoodAnswer += 1
            }
        }
        if nbGoodAnswer == 0{
            throw Abort (.badRequest, reason: "AT_LEAST_ONE_ANSWER_MUST_BE_TRUE")
        }
        if nbGoodAnswer > questionDto.type.nbGoodAnswerMax{
            throw Abort (.badRequest, reason: "TOO_MUCH_GOOD_ANSWER")
        }
        
        let question = try questionDto.toModel(userId: userId, status: StatusQuestionEnum.VALIDE)
        
        if let file = questionDto.picture{
            let createPicture = CreatePictureDto(file: file)
            
            let newKey = try await pictureService.upload(createPictureDto: createPicture)
            let newPicture = createPicture.toModel(key: newKey)
            try await newPicture.save(on: req.db)
            
            question.$pictureId.id = newPicture.id
            
        }
        try await question.save(on: req.db)
        
        guard let _ = question.id else {
            throw Abort(.internalServerError, reason: "QUESTION_NOT_CREATED")
        }
        
        
        for answer in questionDto.answer{
            let newAnswer = try answer.toModel(questionId: question.id!)
            try await newAnswer.save(on: req.db)
        }
        
        try await question.$pictureId.load(on: req.db)
        try await question.$user.load(on: req.db)
        try await question.user.$pictureId.load(on: req.db)
        try await question.$theme.load(on: req.db)
        try await question.$answers.load(on: req.db)
        
        let urlPictureUser = try await pictureService.getPresignedUrl(key: question.user.pictureId?.key ?? "")
        
        if let picture = question.pictureId {
            let url = try await pictureService.getPresignedUrl(key: picture.key)
            
            return question.toDTO(urlPictureUser: urlPictureUser, url: url)
        }
        else{
            return question.toDTO(urlPictureUser: urlPictureUser)
        }
        
    }
    
    
    func getOneQuestion(req: Request, difficulty: LevelGalopLessonQuizEnum? = nil, exceptIds: [UUID]) async throws -> QuestionResponseDTO{
        
        var query = Question.query(on: req.db)
            .filter(\.$status == .VALIDE)
        
        if let difficulty {
            query = query.filter(\.$difficulty == difficulty)
        }
        print(exceptIds)
        if !exceptIds.isEmpty {
            print(exceptIds)
            query = query.filter(\.$id !~ exceptIds)
        }
        
        guard let question = try await query
            .sort(.sql(unsafeRaw: "RAND()"))
            .first()
                
        else {
            throw Abort(.notFound, reason: "NO_QUESTION_AVAILABLE")
        }
        
        try await question.$pictureId.load(on: req.db)
        try await question.$user.load(on: req.db)
        try await question.user.$pictureId.load(on: req.db)
        try await question.$theme.load(on: req.db)
        try await question.$answers.load(on: req.db)
        
        let urlPictureUser = try await pictureService.getPresignedUrl(key: question.user.pictureId?.key ?? "")
        
        if let picture = question.pictureId {
            let url = try await pictureService.getPresignedUrl(key: picture.key)
            
            return question.toDTO(urlPictureUser: urlPictureUser, url: url)
        }
        else{
            return question.toDTO(urlPictureUser: urlPictureUser)
        }
    }
    
}
