import Foundation

final class MockMiddleware: Middleware {
    var requestProcessed: ((inout HTTPRequest) -> Void)?
    var responseProcessed: ((inout HTTPResponse) -> Void)?

    func process(_ request: inout HTTPRequest) {
        requestProcessed?(&request)
    }

    func process(_ response: inout HTTPResponse) {
        responseProcessed?(&response)
    }
}
