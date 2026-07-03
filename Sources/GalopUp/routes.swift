import Fluent
import Foundation
import Vapor
import SotoS3

func routes(_ app: Application) throws {
    
    guard let config = app.storage[AppConfigKey.self] else{
        throw Abort(.internalServerError, reason: "Missing AppConfig")
    }
    
    let client = AWSClient(
            credentialProvider: .static(
                accessKeyId: config.RUSTFS_ACCESS_KEY,
                secretAccessKey: config.RUSTFS_SECRET_KEY
            )
    )
    let s3 = S3(client: client, region: .useast1, endpoint: config.RUSTFS_ENDPOINT)

    let pictureService = PictureService(s3: s3, mainBucket: config.RUSTFS_BUCKET)
    
    try app.register(collection: PictureController(pictureService: pictureService))

    try app.register(collection: AuthController())
    try app.register(collection: UserController(pictureService: pictureService))
}
