//
//  RefreshTokenSecurityMigration.swift
//  GalopUp
//
//  Created by Emma on 21/10/2026.
//

import Fluent
import FluentMySQLDriver
import Vapor

struct TriggerAndProcedureMigration: AsyncMigration {
    func prepare(on database: any Database) async throws {
        guard let mysql = database as? any MySQLDatabase else {
            throw Abort(.internalServerError, reason: "MYSQL_DATABASE_REQUIRED")
        }

        _ = try await mysql.simpleQuery("""
            CREATE PROCEDURE purge_expired_refresh_tokens()
            BEGIN
                DELETE FROM refreshToken WHERE expire_at < UTC_TIMESTAMP();
            END
            """).get()

        _ = try await mysql.simpleQuery("""
            CREATE EVENT purge_refresh_tokens_daily
            ON SCHEDULE EVERY 1 DAY
            STARTS (CURRENT_DATE + INTERVAL 1 DAY + INTERVAL 3 HOUR)
            DO CALL purge_expired_refresh_tokens()
            """).get()

        _ = try await mysql.simpleQuery("""
            CREATE TRIGGER revoke_tokens_on_user_delete
            AFTER UPDATE ON `user`
            FOR EACH ROW
            BEGIN
                IF NEW.deletedAt IS NOT NULL AND OLD.deletedAt IS NULL THEN
                    DELETE FROM refreshToken WHERE user_id = NEW.id;
                END IF;
            END
            """).get()
    }

    func revert(on database: any Database) async throws {
        guard let mysql = database as? any MySQLDatabase else {
            throw Abort(.internalServerError, reason: "MYSQL_DATABASE_REQUIRED")
        }
        _ = try await mysql.simpleQuery("DROP TRIGGER IF EXISTS revoke_tokens_on_user_delete").get()
        _ = try await mysql.simpleQuery("DROP EVENT IF EXISTS purge_refresh_tokens_daily").get()
        _ = try await mysql.simpleQuery("DROP PROCEDURE IF EXISTS purge_expired_refresh_tokens").get()
    }
}
