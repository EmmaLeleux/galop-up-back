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
    let isDefault: Bool
    
    init(file: File, bucketname: String? = nil, order: Int? = nil, isDefault: Bool = false) {
            self.file = file
            self.bucketname = bucketname
            self.order = order
        self.isDefault = isDefault
        }
    
    func toModel(key: String, postId: UUID? = nil) -> Picture {
        let model = Picture()
        model.key = key
        model.name = file.filename
        model.order = order
        model.isDefault = isDefault
        model.$post.id = postId
        return model
    }
}
