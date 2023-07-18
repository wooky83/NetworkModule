import Foundation
import OSLog

enum NetworkUtil {
    
    enum Authorization: Equatable {
        case notRequired, required, dontCare
    }

    //Define Header Name
    static let ACCEPT_LANGUAGE = "Accept-Language"
    static let CONTENT_TYPE = "Content-Type"
    static let AUTHORIZATION = "Authorization"
    static let RETRY = "retry"

    static func getHttpheader(_ option: String? = nil) -> [String : String] {
        var header = [String : String]()
        header[ACCEPT_LANGUAGE] = "ko-KR;q=1, en-KR;q=0.9"
        header[CONTENT_TYPE] = "application/x-www-form-urlencoded; charset=utf-8"
        return header
    }
    
    static func getURLEncodeCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
    }
    
    static var basicAuth: String {
        let username = "wooky"
        let password = "1234"
        let credentialData = "\(username):\(password)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString(options: []) ?? ""
        return "Basic \(base64Credentials)"
    }

    static func convertToPrettyString(from jsonData: Data) -> String {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            return String(data: prettyData, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
}

enum NetworkError: Error {
    case networkError
    case jsonDecodingError
    case typeCastingError
    case unKnownHttpError(status: Int)
    case httpError
    case serverError(MYServerError)
}

struct MYServerError: Decodable {
    let code: String
    let message: String
    let detailMessage: String
}

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

struct Log {
    enum Level {
        case debug
        case info
        case network
        case error
        case custom(categoryName: String)

        fileprivate var category: String {
            switch self {
            case .debug:
                return "Debug"
            case .info:
                return "Info"
            case .network:
                return "Network"
            case .error:
                return "Error"
            case .custom(let categoryName):
                return categoryName
            }
        }

        fileprivate var osLog: OSLog {
            switch self {
            case .debug:
                return OSLog.debug
            case .info:
                return OSLog.info
            case .network:
                return OSLog.network
            case .error:
                return OSLog.error
            case .custom:
                return OSLog.debug
            }
        }

        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:
                return .debug
            case .info:
                return .info
            case .network:
                return .default
            case .error:
                return .error
            case .custom:
                return .debug
            }
        }
    }

    static private func log(_ message: Any, _ arguments: [Any], level: Level) {
#if DEBUG
        let extraMessage = arguments.map({ String(describing: $0) }).joined(separator: " ")
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let logMessage = "\(message) \(extraMessage)"
        switch level {
        case .debug, .custom:
            logger.debug("\(logMessage, privacy: .public)")
        case .info:
            logger.info("\(logMessage, privacy: .public)")
        case .network:
            logger.log("\(logMessage, privacy: .public)")
        case .error:
            logger.error("\(logMessage, privacy: .public)")
        }
#endif
    }
}

// MARK: - utils
extension Log {
    static func debug(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .debug)
    }

    static func info(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .info)
    }

    static func network(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .network)
    }

    static func error(_ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .error)
    }

    static func custom(category: String, _ message: Any, _ arguments: Any...) {
        log(message, arguments, level: .custom(categoryName: category))
    }
}
