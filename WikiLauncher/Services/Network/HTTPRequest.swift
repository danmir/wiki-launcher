import Foundation

struct HTTPRequest {
    var url: URL
    var method: String
    var headers: [String: String]?
    var body: Data?
}
