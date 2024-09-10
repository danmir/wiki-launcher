import Foundation

final class DIContainer {
    lazy var wikiDeeplinkService: WikiDeeplinkService = {
        WikiDeeplinkServiceImpl()
    }()

    lazy var logger: ConsoleLogger = {
        ConsoleLogger()
    }()

    lazy var loggerMiddleware: LoggerMiddleware = {
        LoggerMiddleware(logger: logger)
    }()

    lazy var requestSender: RequestSender = {
        RequestSenderImpl(middlewares: [loggerMiddleware])
    }()

    lazy var responseParser: ResponseParser = {
        ResponseParserImpl(logger: logger)
    }()

    lazy var locationsService: LocationsService = {
        LocationsServiceImpl(requestSender: requestSender, responseParser: responseParser)
    }()

    lazy var coordinatesValidator: CoordinatesValidator = {
        CoordinatesValidatorImpl()
    }()

    lazy var locationBuilder: LocationBuilder = {
        LocationBuilderImpl()
    }()

    lazy var externalDeeplinkRouter: ExternalDeeplinkRouter = {
        ExternalDeeplinkRouterImpl()
    }()

    init() {}
}
