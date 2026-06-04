//
//  CreateUserDTO.swift
//  GalopUp
//
//  Created by Emma on 12/05/2026.
//

import Vapor

struct CreateUserDTO : Content, Validatable {
    let email : String
    let password : String
    let confirmPassword: String
    
    static func validations(_ validations: inout Validations){
        validations.add("email", as: String.self, is: .email, customFailureDescription: "EMAIL_INVALID")
        validations.add("password", as: String.self, is: .strongPassword, customFailureDescription: "NOT_STRONG_ENOUGH")
        validations.add("confirmPassword", as: String.self)
    }
    
    func toModel() -> User {
        let model = User()
        model.email = email
        model.password = password
        model.role = UserRoleEnum.USER
        model.isBanned = false
        return model
    }
   
}

private extension Validator where T == String {
    static var strongPassword: Validator<String> {
        .init { value in
            let regex = #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"#
            let isValid = value.range(of: regex, options: .regularExpression) != nil
            return StrongPasswordResult(isValid: isValid)
        }
    }
}
struct StrongPasswordResult: ValidatorResult {
    let isValid: Bool
    var isFailure: Bool { !isValid }
    var successDescription: String? { "is a strong password" }
    var failureDescription: String? { "NOT_STRONG_ENOUGH" }
}
