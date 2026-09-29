//
//  QuizResponseDto.swift
//  GalopUp
//
//  Created by Emma on 28/09/2026.
//

import Vapor

struct QuizResponseDto: Content {
    var id: UUID
    var type: TypeQuizEnum
    var picture: GetPictureDto
    var description: String
}
