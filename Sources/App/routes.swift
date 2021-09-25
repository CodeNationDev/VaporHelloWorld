import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return "It works!"
    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("userinfo") { req -> String in
        let encoded = try? JSONHelper.jsonEncode(UserInfo(name: "David", age: 40, address: "Calle Aragón 10"))
        return encoded!
    }
    
    app.get("username", ":name") { req -> String in
        guard let name = req.parameters.get("name") else {
            throw Abort(.internalServerError)
        }
        return "Hello, \(name)"
    }
    
    app.get("getuserbyname") { req -> EventLoopFuture<[UserInfo.Public]> in
        
        let data = try req.content.decode(UserInfo.self)
        
        return UserInfo
            .query(on: req.db)
            .filter(\.$name, .equal, data.name)
            .all()
            .map { items in
                return items.map({UserInfo.Public(id: $0.id, name: $0.name, age: $0.age, address: $0.address)})
            }
    }
    
    app.post("info") { req -> String in
        do {
            let data = try req.content.decode(UserInfo.self)
            
            if let name = data.name, let age = data.age, let address = data.address {
                return "\nName: \(name) \nAge: \(age) \nAddress:\(address)"
            } else { throw Abort(.internalServerError) }
        } catch let error {
            return error.localizedDescription
        }
    }
    
    app.post("createuser") { request -> EventLoopFuture<UserInfo.Public> in
        
        let parsed = try request.content.decode(UserInfo.Create.self)
        
        let userInfo = UserInfo(name: parsed.name, age: parsed.age, address: parsed.address)
        return userInfo.save(on: request.db).map {
            UserInfo.Public(id: userInfo.id, name: userInfo.name, age: userInfo.age, address: userInfo.address)
        }
    }
    
    app.get("allusers") { req -> EventLoopFuture<[UserInfo]> in
        return UserInfo.query(on: app.db).all()
    }
    
    app.post("getuserby") { req -> EventLoopFuture<[UserInfo.Public]> in
        let data = try req.content.decode(UserInfo.self)
        return UserInfo
            .query(on: req.db)
            .filter(\.$age, .greaterThan, 10)
            .all()
            .map { items in
                return items.map({UserInfo.Public(id: $0.id, name: $0.name, age: $0.age, address: $0.address)})
            }
    }
}

