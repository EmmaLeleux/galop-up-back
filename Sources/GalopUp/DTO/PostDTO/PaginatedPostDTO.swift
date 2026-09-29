//
//  PaginatedPostDTO.swift
//  GalopUp
//
//  Created by Emma on 12/09/2026.
//

import Vapor

struct PaginatedPostsDTO: Content {
    let posts: [PostResponseDTO]
    let nextCursor: String?
}
