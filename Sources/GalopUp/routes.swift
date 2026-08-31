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
    
    let userController = UserController(pictureService: pictureService)
    
    let pictureController = PictureController(pictureService: pictureService)

    try app.register(collection: AuthController())
    try app.register(collection: userController)
    try app.register(collection: pictureController)
    try app.register(collection: PostController(pictureService: pictureService, userController: userController, pictureController: pictureController))
}
