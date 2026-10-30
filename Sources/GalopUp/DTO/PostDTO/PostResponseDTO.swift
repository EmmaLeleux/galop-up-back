//
//  GetPostDTO.swift
//  GalopUp
//
//  Created by Emma on 30/08/2026.
//

import Vapor

struct PostResponseDTO : Content {
    let id : UUID
    let title : String
    let content : String
    let pictures: [GetPictureDto]
    let author: UserPublicResponseDTO
    let createdAt: Date
    let nbLikes: Int
    let isLikeByMe: Bool
   
}
