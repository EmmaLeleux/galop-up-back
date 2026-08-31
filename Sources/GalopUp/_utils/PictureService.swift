//
//  PictureService.swift
//  GalopUp
//
//  Created by Emma on 01/07/2026.
//

import Vapor
import SotoS3

struct PictureService {
    let s3: S3
    let mainBucket: String

    func upload(createPictureDto: CreatePictureDto) async throws -> String{
        let file = createPictureDto.file
        
        let allowExtension = ["jpg", "jpeg", "png", "webp"]
        guard let extention = file.extension?.lowercased(),
              allowExtension.contains(extention) else {
            throw Abort(.unsupportedMediaType, reason: "INVALID_MEDIA")
        }
        
        let key = "\(createPictureDto.bucketname != nil ? createPictureDto.bucketname! + "/": "")\(UUID().uuidString)\(file.extension ?? ".png")"
        
        let allowedContentTypes = ["image/jpeg", "image/png", "image/webp"]
        guard let contentType = file.contentType?.serialize(),
              allowedContentTypes.contains(contentType) else {
            throw Abort(.unsupportedMediaType, reason: "INVALID_CONTENT_TYPE")
        }
        
        let putRequest = S3.PutObjectRequest(
            body: AWSHTTPBody(buffer: file.data),
            bucket: mainBucket,
            contentType: contentType,
            key: key
        )
        let _ = try await s3.putObject(putRequest)
        return key
    }
    
    func getPresignedUrl(key: String) async throws -> String {
        let url = try await s3.signURL(
            url: URL(string: "http://localhost:9001/\(mainBucket)/\(key)")!,
            httpMethod: .GET,
            expires: .minutes(60)
        )
        return url.absoluteString
    }
    
    
    func delete(key: String) async throws{
        let deleteRequest = S3.DeleteObjectRequest(
                bucket: mainBucket,
                key: key
            )
            _ = try await s3.deleteObject(deleteRequest)    }
}
