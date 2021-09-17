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
    
    app.get("username") { req -> String in
        guard let name = req.parameters.get("name") else {
            throw Abort(.internalServerError)
        }
        return "Hello, \(name)"
    }
    
    app.post("info") { req -> String in
        var data:UserInfo?
        
        do {
            data = try req.content.decode(UserInfo.self)
        } catch let error {
            print(error.localizedDescription)
        }
        if let data = data, let id = data.id, let name = data.name, let age = data.age, let address = data.address {
            return "id: \(id) \nName: \(name) \nAge: \(age) \nAddress:\(address)"
        } else { throw Abort(.internalServerError) }
    }
    
    app.post("saveuser") { req -> String in
        
        let data = try req.content.decode(UserInfo.self)
        let userinfo = UserInfo(name: data.name, age: data.age, address: data.address)
        
        let _ = userinfo.create(on: app.db).map { userinfo }
        
        return String(bytes:
                        try JSONEncoder().encode(Response(httpStatus: .ok, body: UserInfo(id: userinfo.id, name: userinfo.name, age: userinfo.age, address: userinfo.address))), encoding: .utf8) ?? ""
    }
}
