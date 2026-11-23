//
//  QuizSessionController.swift
//  GalopUp
//
//  Created by Emma on 26/10/2026.
//

import Fluent
import Vapor
import SQLKit

struct QuizSessionController: RouteCollection {
    let userController: UserController
    let protectService: ProtectService
    let questionController: QuestionController
    func boot(routes: any RoutesBuilder) throws {
        let themeQuestion = routes.grouped("quiz-session")
        
        let protectedRoutes = themeQuestion.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, use: createQuizSession)
        protectedRoutes.on(.PATCH, use: AnswerQuestionAndContinueQuiz)
        protectedRoutes.patch("stop", use: stopQuiz)
        protectedRoutes.patch("finish", use: finishQuiz)
        protectedRoutes.on(.GET, use: getQuizHistory)
        
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
        if quizSession.quiz == .CONTRE_LA_MONTRE{
            quizSession.timeLimit = 60
        }
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
    func stopQuiz(req: Request) async throws -> HTTPStatus{
        
        let _ = try await protectService.protect(req: req, roles: [.USER])
        
        let session = try await getMyActiveSession(req: req)
        
        session.status = .ABANDONE
        session.endAt = Date()
        
        try await session.save(on: req.db)
        
        return .noContent
        
    }
    
    @Sendable
    func finishQuiz(req: Request) async throws -> QuizSessionQuestionResponseDto {
        let user = try await protectService.protect(req: req, roles: [.USER])
        let session = try await getMyActiveSession(req: req)
        
        guard let deadline = session.deadline else {
            throw Abort(.badRequest, reason: "QUIZ_NOT_CONCERNED")
        }
        
        guard Date() >= deadline.addingTimeInterval(-1) else {
            throw Abort(.badRequest, reason: "TIMING_NOT_REACHED")
        }
        
        session.status = .TERMINE
        session.endAt = deadline
        try await session.save(on: req.db)
        
        try await session.$user.load(on: req.db)
        
        let userDto = try await userController.getUserById(req: req, userId: user.requireID())
        
        let sessionDto = session.toDTO(userDto: userDto)
        
        return QuizSessionQuestionResponseDto(session: sessionDto, question: nil)
    }
    
    @Sendable
    func getQuizHistory(req: Request) async throws -> [QuizHistoryDTO] {
        let payload = try req.auth.require(UserPayload.self)
        
        guard let sql = req.db as? any SQLDatabase else {
            throw Abort(.internalServerError, reason: "SQL_DATABASE_REQUIRED")
        }
        
        return try await sql.raw("""
            SELECT id,
                   difficulty,
                   niveauGalop,
                   createdAt,
                   CAST(TIMESTAMPDIFF(MICROSECOND, createdAt, endAt) / 1000000 AS DOUBLE) AS chrono,
                   nbQuestion,
                   nbGoodAnswer,
                   quiz
            FROM quizSession
            WHERE user_id = \(bind: payload.id) AND status = 'Terminé'
            ORDER BY createdAt DESC
            LIMIT 20
            """).all(decoding: QuizHistoryDTO.self)
    }
    
    @Sendable
    func AnswerQuestionAndContinueQuiz(req:Request) async throws -> QuizSessionQuestionResponseDto {
        let user = try await protectService.protect(req: req, roles: [.USER])
        
        let session = try await getMyActiveSession(req: req)
        
        if let deadline = session.deadline, Date() > deadline.addingTimeInterval(2) {
            session.status = .TERMINE
            session.endAt = deadline
            try await session.save(on: req.db)
            
            let userDto = try await userController.getUserById(req: req, userId: user.requireID())
            return QuizSessionQuestionResponseDto(session: session.toDTO(userDto: userDto), question: nil)
        }
        
        let answerDTO = try req.content.decode(CheckAnswerDTO.self)
        
        let answer = try await Answer.query(on: req.db)
            .filter(\.$id, .equal, answerDTO.id)
            .first()
        
        guard let answer = answer else{
            throw Abort(.notFound, reason: "ANSWER_NOT_FOUND")
        }
        
        guard session.status == .EN_COURS else{
            throw Abort(.badRequest, reason: "QUIZ_ALREADY_FINISHED")
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
        
        
        if (session.quiz == .CLASSIQUE && session.nbQuestion >= 20) || (session.quiz == .SURVIE && (session.nbQuestion - session.nbGoodAnswer) >= 3){
            session.status = .TERMINE
            session.endAt = Date()
        }
        
        
        var levelQuestion = session.niveauGalop
        if session.difficulty == .CROISSANTE{
            levelQuestion = .GALOP4
        }
        
        let questionDto = try await questionController.getOneQuestion(req: req, difficulty: levelQuestion, exceptIds: exceptIds)
        
        if questionDto == nil{
            session.status = .TERMINE
            session.endAt = Date()
        }
        
        try await session.save(on: req.db)
        
        try await session.$user.load(on: req.db)
        
        let userDto = try await userController.getUserById(req: req, userId: user.requireID())
        
        let sessionDto = session.toDTO(userDto: userDto)
        
        
        
        
        
        return QuizSessionQuestionResponseDto(session: sessionDto, question: questionDto)
    }
    
    
}
