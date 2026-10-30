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
    let protectService: ProtectService
    func boot(routes: any RoutesBuilder) throws {
        let post = routes.grouped("post")
        
        let protectedRoutes = post.grouped(GalopUpMiddleware())
        protectedRoutes.on(.POST, body: .collect(maxSize: "90mb"), use: createPost)
        protectedRoutes.get(use: getPosts)
        protectedRoutes.on(.POST, ":postId", "like", use: likePost)
        protectedRoutes.on(.DELETE, ":postId", "like", use: unlikePost)
    }
    
    @Sendable
    func createPost(req: Request) async throws -> PostResponseDTO {
        let user = try await protectService.protect(req: req, roles: [.USER])
        
        guard let userId = user.id else{
            throw Abort(.badRequest, reason: "USER_NOT_FOUND")
        }
        
        try CreatePostDTO.validate(content: req)
        
        let postDto = try req.content.decode(CreatePostDTO.self)
        
        if let postPicture = postDto.pictures{
            if postPicture.count > 4 {
                throw Abort(.badRequest, reason: "TOO_MANY_POST_PICTURES")
            }
        }
        
        let post = postDto.toModel()
        post.$user.id = userId
        
        try await post.save(on: req.db)
        
        let postId = try post.requireID()
        
        if let postPicture = postDto.pictures{
            for (index, picture) in postPicture.enumerated(){
                let createPicture = CreatePictureDto(file: picture, order: index)
                
                let newKey = try await pictureService.upload(createPictureDto: createPicture)
                let newPictureId = createPicture.toModel(key: newKey, postId: postId)
                try await newPictureId.save(on: req.db)
            }
        }
        
        
        try await post.$user.load(on: req.db)
        try await post.$likes.load(on: req.db)
        
        let picturesPostDto = try await pictureController.getPicturesByPostId(postId: postId, req: req)
        
        let userDto = try await userController.getUserById(req: req, userId: userId)
        return post.toDTO(pictureDto: picturesPostDto, userDto: userDto, currentUserId: userId)
    }
    
    @Sendable
    func getPosts(req: Request) async throws -> PaginatedPostsDTO {
        let payload = try req.auth.require(UserPayload.self)
        
        let pageSize = 10
        let cursorString = try? req.query.get(String.self, at: "cursor")
        let cursorDate = cursorString.flatMap { ISO8601DateFormatter().date(from: $0) }
        
        var query = Post.query(on: req.db).with(\.$user).with(\.$likes)
        if let cursorDate {
            query = query.filter(\.$createdAt, .lessThan, cursorDate)        }
        
        let posts = try await query
            .sort(\.$createdAt, .descending)
            .limit(pageSize)
            .all()
        
        var postsDto: [PostResponseDTO] = []
        
        for post in posts {
            let postId = try post.requireID()
            let picturesPostsDto = try await pictureController.getPicturesByPostId(postId: postId, req: req)
            let userDto = try await userController.getUserById(req: req, userId: post.$user.id)
            postsDto.append(post.toDTO(pictureDto: picturesPostsDto, userDto: userDto, currentUserId: payload.id))
        }
        
        let nextCursor: String?
        if let last = posts.last, posts.count == pageSize, let createdAt = last.createdAt {
            nextCursor = ISO8601DateFormatter().string(from: createdAt)
        } else {
            nextCursor = nil
        }
        
        return PaginatedPostsDTO(posts: postsDto, nextCursor: nextCursor)
    }
    
    @Sendable
    func likePost(req: Request) async throws -> HTTPStatus {
        let user = try await protectService.protect(req: req, roles: [.USER])
        
        guard let postId = req.parameters.get("postId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let userId = user.id else{
            throw Abort(.badRequest)
        }
        
        let existingLike = try await PostLikeByUser.query(on: req.db)
            .filter(\.$post.$id, .equal, postId)
            .filter(\.$user.$id, .equal, userId)
            .first()
        
        guard existingLike == nil else {
            return .noContent
        }
        
        let like = PostLikeByUser()
        like.$post.id = postId
        like.$user.id = userId
        try await like.save(on: req.db)
        return .created
    }
    
    @Sendable
    func unlikePost(req: Request) async throws -> HTTPStatus {
        let payload = try req.auth.require(UserPayload.self)
        guard let postId = req.parameters.get("postId", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        try await PostLikeByUser.query(on: req.db)
            .filter(\.$post.$id, .equal, postId)
            .filter(\.$user.$id, .equal, payload.id)
            .delete()
        
        return .noContent
    }
}
