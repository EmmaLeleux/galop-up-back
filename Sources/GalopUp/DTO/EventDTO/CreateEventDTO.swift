//
//  CreateEventDTO.swift
//  GalopUp
//
//  Created by Emma on 05/11/2026.
//

import Vapor

struct CreateEventDto: Content{
    let name: String
    let description: String
    let picture: File
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
    let typeEventId: UUID
    
    
    func toModel() -> EventCustom {
        let model = EventCustom()
        model.name = name
        model.description = description
        model.startDate = startDate
        model.endDate = endDate
        model.deadline = deadline
        model.placeName = placeName
        model.address = address
        model.latitude = latitude
        model.longitude = longitude
        model.price = price
        model.capacity = capacity
        model.levelMin = levelMin
        model.levelMax = levelMax
        model.equipment = equipment
        model.$type.id = typeEventId
        return model
    }
}

