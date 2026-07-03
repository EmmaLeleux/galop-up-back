//
//  CreateFileDto.swift
//  GalopUp
//
//  Created by Emma on 01/07/2026.
//

import Vapor

struct CreatePictureDto: Content{
    let file: File
    let bucketname: String?
    let order: Int?
    
    init(file: File, bucketname: String? = nil, order: Int? = nil) {
            self.file = file
            self.bucketname = bucketname
            self.order = order
        }
    
    func toModel(key: String) -> Picture {
        let model = Picture()
        model.key = key
        model.name = file.filename
        model.order = order
        return model
    }
}
