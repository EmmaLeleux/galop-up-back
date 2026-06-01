//
//  LoginResponseDTO.swift
//  GalopUp
//
//  Created by Emma on 12/05/2026.
//


import Vapor

struct LoginResponse: Content {
    let accessToken: String
    let accessTokenExpiration: Date
    let refreshToken: String
}
