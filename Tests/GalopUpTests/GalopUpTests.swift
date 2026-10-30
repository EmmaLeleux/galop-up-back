@testable import GalopUp
import VaporTesting
import Testing
import Fluent

@Suite("App Tests with DB", .serialized)
struct GalopUpTests {
    private func withApp(_ test: (Application) async throws -> ()) async throws {
        let app = try await Application.make(.testing)
        do {
            try await configure(app)
            try await app.autoMigrate()
            try await test(app)
            try await app.autoRevert()
        } catch {
            try? await app.autoRevert()
            try await app.asyncShutdown()
            throw error
        }
        try await app.asyncShutdown()
    }
    
    
    @Test("POST/ Create user")
    func createUser() async throws {
        let dto = CreateUserDTO(
            email: "test@gmail.com",
            password: "Test123456**",
            confirmPassword: "Test123456**"
        )
        
        try await withApp { app in
            try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
                try req.content.encode(dto)
            }, afterResponse: { res async throws in

                #expect(res.status == .ok)
                
                let loginResponse = try res.content.decode(LoginResponse.self)
                print (loginResponse)
                #expect(!loginResponse.accessToken.isEmpty)
            })
            
            
        }
    }
    
    @Test("POST/ Create post")
    func createPost() async throws {
        let userDto = CreateUserDTO(
            email: "test2@gmail.com",
            password: "Test123456**",
            confirmPassword: "Test123456**"
        )
        
        try await withApp { app in
            var accessToken = ""
            
            try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
                try req.content.encode(userDto)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let loginResponse = try res.content.decode(LoginResponse.self)
                accessToken = loginResponse.accessToken
            })
            
            let postDto = CreatePostDTO(title: "post 1", content: "test", pictures: nil)
            
            try await app.testing().test(.POST, "post", beforeRequest: { req in
                req.headers.bearerAuthorization = BearerAuthorization(token: accessToken)
                try req.content.encode(postDto)
            }, afterResponse: { res async throws in
                #expect(res.status == .ok)
                let post = try res.content.decode(PostResponseDTO.self)
                #expect(post.title == "post 1")
                #expect(post.content == "test")
            })
        }
    }
    
    @Test("GET/ getPosts")
    func getPosts() async throws {
        let userDto = CreateUserDTO(
            email: "test3@gmail.com",
            password: "Test123456**",
            confirmPassword: "Test123456**"
        )
        
        try await withApp { app in
            var accessToken = ""
            
            try await app.testing().test(.POST, "auth/register", beforeRequest: { req in
                try req.content.encode(userDto)
            }, afterResponse: { res async throws in

                #expect(res.status == .ok)
                let loginResponse = try res.content.decode(LoginResponse.self)
                accessToken = loginResponse.accessToken
            })
            
            try await app.testing().test(.GET, "post", beforeRequest: { req in
                req.headers.bearerAuthorization = BearerAuthorization(token: accessToken)
            }, afterResponse: { res async throws in
                print("Status: \(res.status), Body: \(res.body.string)")

                #expect(res.status == .ok)
            })
        }
    }
    
}
