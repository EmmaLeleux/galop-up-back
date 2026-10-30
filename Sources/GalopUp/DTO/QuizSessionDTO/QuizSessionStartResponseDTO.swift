//
//  QuizSessionStartResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 28/10/2026.
//

import Vapor

struct QuizSessionQuestionResponseDto: Content {
    let session: QuizSessionResponseDto
    let question: QuestionResponseDTO?
}
