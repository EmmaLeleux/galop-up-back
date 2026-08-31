//
//  envConfig.swift
//  GalopUp
//
//  Created by Emma on 18/04/2026.
//

import Vapor

struct EnvConfig{
    let DATABASE_HOST: String
    let DATABASE_NAME: String
    let DATABASE_USERNAME: String
    let DATABASE_PASSWORD: String
    let DATABASE_PORT: Int
    let JWT_SECRET: String
    let JWT_SECRET_REFRESH: String
    let RUSTFS_ACCESS_KEY: String
    let RUSTFS_SECRET_KEY: String
    let RUSTFS_ENDPOINT: String
    let RUSTFS_BUCKET: String
    
    static func validateEnv() throws -> EnvConfig{
        let missing = ["DATABASE_HOST", "DATABASE_NAME", "DATABASE_USERNAME",
                       "DATABASE_PASSWORD", "DATABASE_PORT", "JWT_SECRET", "JWT_SECRET_REFRESH", "RUSTFS_ACCESS_KEY", "RUSTFS_SECRET_KEY", "RUSTFS_ENDPOINT", "RUSTFS_BUCKET"]
            .filter { Environment.get($0) == nil }
        
        guard missing.isEmpty else {
            throw Abort(.internalServerError, reason: "Missing env variables: \(missing.joined(separator: ", "))")
        }
        
        return EnvConfig(
            DATABASE_HOST: Environment.get("DATABASE_HOST")!,
            DATABASE_NAME: Environment.get("DATABASE_NAME")!,
            DATABASE_USERNAME: Environment.get("DATABASE_USERNAME")!,
            DATABASE_PASSWORD: Environment.get("DATABASE_PASSWORD")!,
            DATABASE_PORT: Int(Environment.get("DATABASE_PORT")!) ?? 3306,
            JWT_SECRET: Environment.get("JWT_SECRET")!,
            JWT_SECRET_REFRESH: Environment.get("JWT_SECRET_REFRESH")!,
            RUSTFS_ACCESS_KEY: Environment.get("RUSTFS_ACCESS_KEY")!,
            RUSTFS_SECRET_KEY: Environment.get("RUSTFS_SECRET_KEY")!,
            RUSTFS_ENDPOINT: Environment.get("RUSTFS_ENDPOINT")!,
            RUSTFS_BUCKET: Environment.get("RUSTFS_BUCKET")!
        )
        
        
        
    }
}
