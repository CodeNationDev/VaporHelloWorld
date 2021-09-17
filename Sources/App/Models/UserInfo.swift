//
import Foundation
import FluentMySQLDriver
import Vapor

final class UserInfo: Content, Model {
    static var schema: String = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name:String?
    
    @Field(key: "age")
    var age:Int?
    
    @Field(key: "address")
    var address:String?
    
    init() {}
    
    init(id: UUID? = nil, name: String?, age: Int?, address: String?) {
        self.id = id
        self.name = name
        self.age = age
        self.address = address
        
    }
}

extension UserInfo: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            
            database
                .schema(UserInfo.schema)
                .id()
                .field("name", .string)
                .field("age", .int)
                .field("address", .string)
                .create()
        ])
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database
                .schema(UserInfo.schema).delete()
        ])
    }
    
    
}

struct Response<T:Codable>: Content {
    var httpStatus: HTTPStatus?
    var body:T?
}



