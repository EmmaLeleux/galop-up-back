//
//  QuizSession.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

import Fluent
import Vapor

final class QuizSession: Model, @unchecked Sendable, Content {
    static let schema = "quizSession"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "difficulty")
    var difficulty: DifficultyQuizEnum
    
    @OptionalField(key: "niveauGalop")
    var niveauGalop: LevelGalopLessonQuizEnum?
    
    @Timestamp(key: "createdAt", on: .create)
    var createdAt: Date?
    
    @OptionalField(key: "endAt")
    var endAt: Date?
    
    @Field(key: "nbQuestion")
    var nbQuestion: Int
    
    @Field(key: "nbGoodAnswer")
    var nbGoodAnswer: Int
    
    @OptionalField(key: "timeLimit")
    var timeLimit: Int?
    
    @Field(key: "status")
    var status: StatusQuizSessionEnum
    
    @Field(key: "quiz")
    var quiz: TypeQuizEnum
    
    @Parent(key: "user_id")
    var user: User
    
    
    
    init() {}
    
    
    func toDTO(userDto: UserPublicResponseDTO) -> QuizSessionResponseDto{
        
        let remaining: Double?
        if let limit = timeLimit {
            let elapsed = Date().timeIntervalSince(self.createdAt ?? Date())
            remaining = max(0, Double(limit) - elapsed)
        } else {
            remaining = nil
        }
        
        var totalTime: Double? {
            guard let start = self.createdAt, let end = self.endAt else { return nil }
            return end.timeIntervalSince(start)
        }
        
        return QuizSessionResponseDto(
            id: self.id ?? UUID(),
            difficulty: self.difficulty,
            niveauGalop: self.niveauGalop,
            createdAt: self.createdAt ?? Date(),
            chrono: totalTime,
            nbQuestion: self.nbQuestion,
            nbGoodAnswer: self.nbGoodAnswer,
            remainingSeconds: remaining,
            quiz: self.quiz,
            user: userDto
        )
        
    }
}
