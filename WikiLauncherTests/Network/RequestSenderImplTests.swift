import XCTest
@testable import WikiLauncher

class RequestSenderImplTests: XCTestCase {
    override class func setUp() {
        super.setUp()
        URLProtocol.registerClass(URLProtocolMock.self)
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolMock.self)
        super.tearDown()
    }

    func testSendRequest_WithMiddleware_ShouldProcessRequestAndResponse() async throws {
        let url = URL(string: "https://wiki.com")!
        let requestHeaders = ["Initial-Header": "InitialValue"]
        let request = HTTPRequest(
            url: url,
            method: "GET",
            headers: requestHeaders,
            body: nil
        )

        let middleware = MockMiddleware()
        middleware.requestProcessed = { request in
            request.headers?["Processed-Header"] = "ProcessedValue"
        }

        middleware.responseProcessed = { response in
            response.headers["ProcessedResponse-Header"] = "ProcessedResponseValue"
        }

        let requestSender = RequestSenderImpl(middlewares: [middleware])

        let responseHeaders = ["Mock-Response-Header": "MockValue"]
        let responseData = "response data".data(using: .utf8)!
        URLProtocolMock.mockResponses = [
            (
                request: URLRequest(url: url),
                response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: responseHeaders)!,
                data: responseData
            )
        ]

        let response = try await requestSender.sendRequest(request)

        XCTAssertEqual(response.data, responseData)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.headers["Mock-Response-Header"], "MockValue")
        XCTAssertEqual(response.headers["ProcessedResponse-Header"], "ProcessedResponseValue")
    }

    func testSendRequest_NoMiddlewares_ShouldReturnResponseUnmodified() async throws {
        let url = URL(string: "https://wiki.com")!
        let request = HTTPRequest(
            url: url,
            method: "GET",
            headers: nil,
            body: nil
        )

        let requestSender = RequestSenderImpl(middlewares: [])

        let responseHeaders = ["Mock-Response-Header": "MockValue"]
        let responseData = "response data".data(using: .utf8)!
        URLProtocolMock.mockResponses = [
            (
                request: URLRequest(url: url),
                response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: responseHeaders)!,
                data: responseData
            )
        ]

        let response = try await requestSender.sendRequest(request)

        XCTAssertEqual(response.data, responseData)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.headers["Mock-Response-Header"], "MockValue")
    }

    func testSendRequest_ResponseMiddlewareModifiesResponse() async throws {
        let url = URL(string: "https://wiki.com")!
        let request = HTTPRequest(
            url: url,
            method: "GET",
            headers: nil,
            body: nil
        )

        let middleware = MockMiddleware()
        middleware.responseProcessed = { response in
            response.headers["ProcessedResponse-Header"] = "ProcessedResponseValue"
        }

        let requestSender = RequestSenderImpl(middlewares: [middleware])

        let responseHeaders = ["Mock-Response-Header": "MockValue"]
        let responseData = "response data".data(using: .utf8)!
        URLProtocolMock.mockResponses = [
            (
                request: URLRequest(url: url),
                response: HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: responseHeaders)!,
                data: responseData
            )
        ]

        let response = try await requestSender.sendRequest(request)

        XCTAssertEqual(response.data, responseData)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.headers["ProcessedResponse-Header"], "ProcessedResponseValue")
    }
}
