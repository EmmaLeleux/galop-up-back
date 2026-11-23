//
//  EventResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 05/11/2026.
//

import Vapor

struct EventResponseDTO : Content {
    let id: UUID
    let name: String
    let description: String
    let picture: GetPictureDto
    let startDate: Date
    let endDate: Date
    let deadline: Date?
    let placeName: String
    let address: String
    let latitude: Double
    let longitude: Double
    let price: Double?
    let capacity: Int?
    let levelMin: LevelGalopUserEnum?
    let levelMax: LevelGalopUserEnum?
    let equipment: String?
    let typeEvent: TypeEventResponseDTO
    let author: UserPublicResponseDTO
    let isLikeByMe: Bool
}
