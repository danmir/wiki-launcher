import Foundation

final class LoggerMiddleware: Middleware {
    private let logger: Logger

    init(logger: Logger) {
        self.logger = logger
    }

    func process(_ request: inout HTTPRequest) {
        logger.log("Sending request to URL: \(request.url)")
        logger.log("Request method: \(request.method)")
        if let headers = request.headers {
            logger.log("Request headers: \(headers)")
        }
        if let body = request.body, let bodyString = String(data: body, encoding: .utf8) {
            logger.log("Request body: \(bodyString)")
        }
    }

    func process(_ response: inout HTTPResponse) {
        logger.log("Received response with status code: \(response.statusCode)")
        if let bodyString = String(data: response.data, encoding: .utf8) {
            logger.log("Response body: \(bodyString)")
        }
    }
}
