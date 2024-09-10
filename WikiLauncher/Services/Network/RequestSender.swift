import Foundation

protocol RequestSender {
    func sendRequest(_ request: HTTPRequest) async throws -> HTTPResponse
}

final class RequestSenderImpl: RequestSender {
    private var middlewares: [Middleware] = []

    init(middlewares: [Middleware]) {
        self.middlewares = middlewares
    }

    func sendRequest(_ request: HTTPRequest) async throws -> HTTPResponse {
        var mutableRequest = request
        middlewares.forEach { $0.process(&mutableRequest) }

        var urlRequest = URLRequest(url: mutableRequest.url)
        urlRequest.httpMethod = mutableRequest.method
        urlRequest.allHTTPHeaderFields = mutableRequest.headers
        urlRequest.httpBody = mutableRequest.body

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        let responseHeaders = httpResponse.allHeaderFields as? [String: String] ?? [:]
        var mutableResponse = HTTPResponse(
            data: data,
            statusCode: httpResponse.statusCode,
            headers: responseHeaders
        )

        middlewares.forEach { $0.process(&mutableResponse) }

        return mutableResponse
    }
}
