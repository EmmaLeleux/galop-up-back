//
//  CreateLessonDTO.swift
//  GalopUp
//
//  Created by Emma on 16/11/2026.
//

import Vapor

struct CreateLessonDto: Content{
    let name: String
    let description: String
    let level: LevelGalopLessonQuizEnum
    let picture: File
    let content: String
    
    
    func toModel() -> Lesson {
        let model = Lesson()
        model.name = name
        model.description = description
        model.level = level
        model.content = content
        model.status = .PUBLIEE
        return model
    }
}


