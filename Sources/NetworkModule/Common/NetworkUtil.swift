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

// MARK: - Log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
    static let network = OSLog(subsystem: subsystem, category: "Network")
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

public struct Log {
    fileprivate enum Level {
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

    static private func log(_ message: [String], level: Level, file: String, fnc: String, line: Int) {
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let className = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
        let function = fnc.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }.map { String($0) }.joined()
        let logMessage = "[\(className):\(function):\(line)] \(message.joined(separator: ", "))"
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
    }
}

public extension Log {

    static func debug(_ messages: String..., file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .debug, file: file, fnc: fnc, line: line)
    }

    static func info(_ messages: String..., file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .info, file: file, fnc: fnc, line: line)
    }

    static func network(_ messages: String..., file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .network, file: file, fnc: fnc, line: line)
    }

    static func error(_ messages: String..., file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .error, file: file, fnc: fnc, line: line)
    }

    static func custom(_ messages: String..., category: String, file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .custom(categoryName: category), file: file, fnc: fnc, line: line)
    }

}
