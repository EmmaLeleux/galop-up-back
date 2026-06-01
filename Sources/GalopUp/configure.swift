import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) async throws {
    
    let config = try EnvConfig.validateEnv()
    
    app.storage[AppConfigKey.self] = config
    
    
    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: config.DATABASE_HOST,
        port: config.DATABASE_PORT,
        username: config.DATABASE_USERNAME,
        password: config.DATABASE_PASSWORD,
        database: config.DATABASE_NAME
    ), as: .mysql)
    
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .PATCH, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin],
        cacheExpiration: 5
    )
    
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors)
    
    app.migrations.add(UserMigration())
    app.migrations.add(TypeEventMigration())
    app.migrations.add(ThemeQuestionMigration())
    app.migrations.add(TagCustomMigration())
    app.migrations.add(QuizMigration())
    app.migrations.add(QuizSessionMigration())
    app.migrations.add(PostMigration())
    app.migrations.add(TagPostMigration())
    app.migrations.add(PostLikeByUserMigration())
    app.migrations.add(ModerationMigration())
    app.migrations.add(LessonMigration())
    app.migrations.add(LessonPostMigration())
    app.migrations.add(LessonReadByUserMigration())
    app.migrations.add(LessonLikeByUserMigration())
    app.migrations.add(EventMigration())
    app.migrations.add(EventLikeMigration())
    app.migrations.add(CommentMigration())
    app.migrations.add(CommentLikeByUserMigration())
    app.migrations.add(BadgeMigration())
    app.migrations.add(BadgeUserMigration())
    app.migrations.add(QuestionMigration())
    app.migrations.add(QuestionReportMigration())
    app.migrations.add(ReportMigration())
    app.migrations.add(PostOrCommentPictureMigration())
    app.migrations.add(AnswerMigration())
    app.migrations.add(RefreshTokenMigration())
    
    try await app.autoMigrate()
    
    // register routes
    try routes(app)
}

struct AppConfigKey: StorageKey {
    typealias Value = EnvConfig
}

extension Application {
    var config: EnvConfig {
        guard let config = storage[AppConfigKey.self] else {
            fatalError("AppConfig not loaded")
        }
        return config
    }
}
