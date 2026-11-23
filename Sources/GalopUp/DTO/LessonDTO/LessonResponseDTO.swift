//
//  LessonResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 16/11/2026.
//

import Vapor

struct LessonResponseDTO : Content {
    let id: UUID
    let name: String
    let description: String
    let level: LevelGalopLessonQuizEnum
    let picture: GetPictureDto
    let content: String
    let isLikeByMe: Bool
}
