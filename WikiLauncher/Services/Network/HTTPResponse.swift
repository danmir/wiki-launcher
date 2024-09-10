import Foundation

struct HTTPResponse {
    var data: Data
    var statusCode: Int
    var headers: [String: String]
}
