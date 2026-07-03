//
//  PictureController.swift
//  GalopUp
//
//  Created by Emma on 30/06/2026.
//

import Foundation
import Vapor
import SotoS3

struct PictureController: RouteCollection {
    let pictureService: PictureService
    
    func boot(routes: any RoutesBuilder) throws {
        let picture = routes.grouped("picture")
        let protectedRoutes = picture.grouped(GalopUpMiddleware())

        protectedRoutes.on(.POST, "upload", body: .collect(maxSize: "50mb"), use: upload)
    }

    @Sendable
    func upload(req: Request) async throws -> GetPictureDto {
        try req.auth.require(UserPayload.self)
        let fileDto = try req.content.decode(CreatePictureDto.self)
       
        
        let key = try await pictureService.upload(createPictureDto: fileDto)
        let newPicture = fileDto.toModel(key: key)
        try await newPicture.save(on: req.db)
        
        let url = try await pictureService.getPresignedUrl(key: key)
        return newPicture.toDTO(url: url)
        
    }
    

}
