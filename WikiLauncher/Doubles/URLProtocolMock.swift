import Foundation

final class URLProtocolMock: URLProtocol {
    static var mockResponses: [(request: URLRequest, response: HTTPURLResponse, data: Data)] = []

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let response = URLProtocolMock.mockResponses.first(where: { $0.request.url == request.url }) {
            self.client?.urlProtocol(self, didReceive: response.response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didLoad: response.data)
        } else {
            self.client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
