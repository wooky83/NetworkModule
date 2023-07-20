import Foundation
import OSLog

// MARK: - Log
extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier!
//    static let network = OSLog(subsystem: subsystem, category: "Network")
//    static let debug = OSLog(subsystem: subsystem, category: "Debug")
//    static let info = OSLog(subsystem: subsystem, category: "Info")
//    static let error = OSLog(subsystem: subsystem, category: "Error")
}

public enum Log {
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
