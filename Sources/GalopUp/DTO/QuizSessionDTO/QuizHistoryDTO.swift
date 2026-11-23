//
//  QuizHistoryDTO.swift
//  GalopUp
//
//  Created by Emma on 12/11/2026.
//

import Vapor

struct QuizHistoryDTO: Content {
    var id: UUID
    var difficulty: DifficultyQuizEnum
    var niveauGalop: LevelGalopLessonQuizEnum?
    var createdAt: Date
    var chrono: Double?
    var nbQuestion: Int
    var nbGoodAnswer: Int
    var quiz: TypeQuizEnum    
}
