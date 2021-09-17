import Vapor
import Fluent
import FluentMySQLDriver
import SimplyLogger


// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    let hostname = Environment.get("MYSQL_HOSTNAME") ?? ""
    let user = Environment.get("MYSQL_USER") ?? ""
    let database = Environment.get("MYSQL_DATABASE") ?? ""
    let password = Environment.get("MYSQL_PASSWORD") ?? ""
    
    print("\(hostname), \(user), \(database), \(password)")

    //Configure database connection
    app.databases.use(.mysql(hostname: hostname, username: user, password: password, database: database, tlsConfiguration: .forClient(certificateVerification: .none) ), as: .mysql)
    SimplyLogger.log(str: "App configure successfully", appName: "example_app", identity: "configure", logToSystem: true, category: .success, type: .default, log: .default)
    
    //Migrations
    app.migrations.add(UserInfo())
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
