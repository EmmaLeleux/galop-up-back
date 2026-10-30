//
//  QuizSessionResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 27/10/2026.
//

import Vapor

struct QuizSessionResponseDto: Content {
    var id: UUID
    var difficulty: DifficultyQuizEnum
    var niveauGalop: LevelGalopLessonQuizEnum?
    var createdAt: Date
    var chrono: Double?
    var nbQuestion: Int
    var nbGoodAnswer: Int
    var remainingSeconds: Double?
    var quiz: TypeQuizEnum
    var user: UserPublicResponseDTO
    
}

