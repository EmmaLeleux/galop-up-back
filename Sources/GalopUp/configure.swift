import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "127.0.0.1",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 3306,
        username: Environment.get("DATABASE_USERNAME") ?? "root",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "galop_up_db"
    ), as: .mysql)

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

    try await app.autoMigrate()

    // register routes
    try routes(app)
}
