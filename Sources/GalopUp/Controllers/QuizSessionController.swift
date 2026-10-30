//
//  QuizSessionController.swift
//  GalopUp
//
//  Created by Emma on 26/10/2026.
//

import Fluent
import Vapor

struct QuizSessionController: RouteCollection {
    let userController: UserController
    let protectService: ProtectService
    let questionController: QuestionController
    func boot(routes: any RoutesBuilder) throws {
        let themeQuestion = routes.grouped("quiz-session")
        
        let protectedRoutes = themeQuestion.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, use: createQuizSession)
        protectedRoutes.on(.PATCH, use: AnswerQuestionAndContinueQuiz)
        
    }
    
    @Sendable
    func createQuizSession(req: Request) async throws -> QuizSessionQuestionResponseDto {
        let user = try await protectService.protect(req: req, roles: [.USER])
        
        guard let userId = user.id else{
            throw Abort(.badRequest, reason: "USER_NOT_FOUND")
        }
        
        try CreateQuizSessionDTO.validate(content: req)
        let quizSessionDto = try req.content.decode(CreateQuizSessionDTO.self)
        
        let quizSession = try quizSessionDto.toModel(userId: userId)
        
        try await quizSession.save(on: req.db)
        
        try await quizSession.$user.load(on: req.db)
        
        let userDto = try await userController.getUserById(req: req, userId: userId)
        
        var levelFirstQuestion: LevelGalopLessonQuizEnum? = nil
        switch quizSession.difficulty{
        case .CROISSANTE:
            levelFirstQuestion = .GALOP1
        case .DEFINIE:
            levelFirstQuestion = quizSessionDto.niveauGalop
        default:
            levelFirstQuestion = nil
        }
        
        let question = try await questionController.getOneQuestion(req: req, difficulty: levelFirstQuestion, exceptIds: [])
        return QuizSessionQuestionResponseDto(session: quizSession.toDTO(userDto: userDto), question: question)
    }
    
   
    func getMyActiveSession(req: Request) async throws -> QuizSession{
        let user = try await protectService.protect(req: req, roles: [.USER])

        let session = try await QuizSession.query(on: req.db)
            .filter(\.$user.$id, .equal, user.requireID())
            .filter(\.$status == .EN_COURS)
            .first()
        
        guard let session = session else{
            throw Abort(.notFound, reason: "SESSION_NOT_FOUND")
        }
        
        return session
    }
    
    @Sendable
    func AnswerQuestionAndContinueQuiz(req:Request) async throws -> QuizSessionQuestionResponseDto {
        let user = try await protectService.protect(req: req, roles: [.USER])

        let session = try await getMyActiveSession(req: req)

        let answerDTO = try req.content.decode(CheckAnswerDTO.self)

        let answer = try await Answer.query(on: req.db)
            .filter(\.$id, .equal, answerDTO.id)
            .first()

        guard let answer = answer else{
            throw Abort(.notFound, reason: "ANSWER_NOT_FOUND")
        }
        //en contre la montre, vérifier d'abord le chrono, et en survie, vérifier le nombre de vie
        guard session.nbQuestion < 20 else{
            throw Abort(.badRequest, reason: "LIMIT_QUIZ_REACHED")
        }
        try await answer.$question.load(on: req.db)
        
        let listQuestions = try await QuizSessionQuestion.query(on: req.db)
            .filter(\.$quizSession.$id == session.requireID())
            .all()
        
        let exceptIds = listQuestions.map { $0.$question.id } + [try answer.question.requireID()]
        
        
        let question = QuizSessionQuestion()
        question.$question.id = try answer.question.requireID()
        question.$quizSession.id = try session.requireID()
        question.order = listQuestions.count + 1
        session.nbQuestion += 1
        
        if answer.isTrue{
            session.nbGoodAnswer += 1
            question.isCorrect = true
        }
        else{
            question.isCorrect = false
        }
        
        try await question.save(on: req.db)
        
        if session.nbQuestion >= 20{
            session.status = .TERMINE
        }
        
        var levelQuestion = session.niveauGalop
        if session.difficulty == .CROISSANTE{
            levelQuestion = .GALOP4
        }
        
        try await session.save(on: req.db)

        try await session.$user.load(on: req.db)
        
        let userDto = try await userController.getUserById(req: req, userId: user.requireID())
        
        let sessionDto = session.toDTO(userDto: userDto)
        
        
        let questionDto = try await questionController.getOneQuestion(req: req, difficulty: levelQuestion, exceptIds: exceptIds)

        return QuizSessionQuestionResponseDto(session: sessionDto, question: questionDto)
    }
    

}
