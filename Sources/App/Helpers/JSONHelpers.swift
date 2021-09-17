//
import Foundation

public struct JSONHelper {
    public static func jsonDecode<T: Codable>(_ json: String, type: T.Type) throws -> T {
        guard let data = json.data(using: .utf8) else {
            throw NSError(domain: "Unable to parse action", code: 1, userInfo: nil)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    public static func jsonEncode<T: Codable>(_ result: T) throws -> String {
        let data = try JSONEncoder().encode(result)
        if let result = String(data: data, encoding: .utf8) {
            return result
        }
        
        throw NSError(domain: "JSON could't be encoded into a string.", code: 1, userInfo: nil)
    }
}
