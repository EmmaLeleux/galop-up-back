//
//  QuestionResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor

struct QuestionResponseDTO : Content {
    let id : UUID
    let question : String
    let type: TypeQuestionEnum
    let difficulty : LevelGalopLessonQuizEnum
    let status : StatusQuestionEnum
    let theme : ThemeQuestionResponseDto
    let user : UserPublicResponseDTO
    let picture : GetPictureDto?
    let answers : [AnswerResponseDTO]
   
}
