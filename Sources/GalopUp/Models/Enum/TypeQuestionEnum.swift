//
//  TypeQuestionEnum.swift
//  GalopUp
//
//  Created by Emma on 15/04/2026.
//

enum TypeQuestionEnum: String, Codable{
    case QCM = "QCM"
    case REPONSE_MULTIPLE = "Réponse Multiple"
    case TEXT = "Text"
    
    var nbAnswer: Int {
        switch self {
        case .QCM, .REPONSE_MULTIPLE:
            return 4
        case .TEXT:
            return 1
        }
    }
    
    var nbGoodAnswerMax: Int {
        switch self {
        case .QCM, .TEXT:
            return 1
        case .REPONSE_MULTIPLE:
            return 4
        }
    }
}
