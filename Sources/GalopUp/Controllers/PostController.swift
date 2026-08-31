//
//  PostController.swift
//  GalopUp
//
//  Created by Emma on 04/07/2026.
//

import Vapor
struct PostController: RouteCollection {
    
    let pictureService: PictureService
    let userController: UserController
    let pictureController: PictureController
    
    func boot(routes: any RoutesBuilder) throws {
        let post = routes.grouped("post")
        
        let protectedRoutes = post.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, body: .collect(maxSize: "90mb"), use: createPost)
        protectedRoutes.get(use: getPosts)
    }
    
    @Sendable
    func createPost(req: Request) async throws -> PostResponseDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let postDto = try req.content.decode(CreatePostDTO.self)
        let post = postDto.toModel()
        post.$user.id = payload.id
        
        try await post.save(on: req.db)
        guard let postId = post.id else {
            throw Abort(.internalServerError, reason: "POST_NOT_CREATED")
        }
        
        
        for (index, picture) in postDto.pictures.enumerated(){
            let createPicture = CreatePictureDto(file: picture, order: index)
            
            let newKey = try await pictureService.upload(createPictureDto: createPicture)
            let newPictureId = createPicture.toModel(key: newKey, postId: post.id)
            try await newPictureId.save(on: req.db)
        }
        try await post.$user.load(on: req.db)

        
        
        let picturesPostDto = try await pictureController.getPicturesByPostId(postId: postId, req: req)
        
        let userDto = try await userController.getMyUser(req: req)
        return post.toDTO(pictureDto: picturesPostDto, userDto: userDto, nbLikes: 0)
    }
    
    @Sendable
    func getPosts(req: Request) async throws -> [PostResponseDTO] {
        try req.auth.require(UserPayload.self)
        
        let posts = try await Post.query(on: req.db)
            .with(\.$user)
            .all()
        
        var postsDto: [PostResponseDTO] = []

        for post in posts {
            let picturesPostsDto = try await pictureController.getPicturesByPostId(postId: post.id!, req: req)
            let userDto = try await userController.getUserById(req: req, userId: post.$user.id)
            postsDto.append(post.toDTO(pictureDto: picturesPostsDto, userDto: userDto, nbLikes: 1))
        }
        
        return postsDto
    }
}
