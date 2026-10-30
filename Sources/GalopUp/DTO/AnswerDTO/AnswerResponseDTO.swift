//
//  AnswerResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 30/09/2026.
//

import Vapor

struct AnswerResponseDTO : Content {
    let id : UUID
    let description: String
   
}
