import Foundation

protocol Middleware {
    func process(_ request: inout HTTPRequest)
    func process(_ response: inout HTTPResponse)
}
