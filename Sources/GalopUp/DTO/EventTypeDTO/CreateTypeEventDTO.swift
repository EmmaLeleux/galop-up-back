//
//  CreateEventTypeDTO.swift
//  GalopUp
//
//  Created by Emma on 05/11/2026.
//

import Vapor

struct CreateTypeEventDto: Content{
    let name: String
    
    init(name: String) {
            self.name = name
        }
    
    func toModel() -> TypeEvent {
        let model = TypeEvent()
        model.name = name
        return model
    }
}
