import Foundation
import OSLog

public enum Log {

    private static let subsystem = Bundle.main.bundleIdentifier ?? ""
    /// OSLogMessage
    /// argumentString: @autoclosure @escaping () -> String,
    /// format: OSLogIntegerFormatting = .decimal,
    /// align: OSLogStringAlignment = .none,
    /// privacy: OSLogPrivacy = .auto,
    /// attributes: String
    static private func log(_ message: [String], level: OSLogType, category: String? = nil, file: String, fnc: String, line: Int) {
        let logger = Logger(subsystem: subsystem, category: category ?? level.description)
        let className = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
        let function = fnc.unicodeScalars.filter { CharacterSet.alphanumerics.contains($0) }.map { String($0) }.joined()
        let logMessage = "[\(className):\(function):\(line)] \(message.joined(separator: ", "))"
        logger.log(level: level, "\(logMessage)")
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
        log(messages, level: .info, category: "Network", file: file, fnc: fnc, line: line)
    }

    static func error(_ messages: String..., file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .error, file: file, fnc: fnc, line: line)
    }

    static func custom(_ messages: String..., category: String, file: String = #file, fnc: String = #function, line: (Int)=#line) {
        log(messages, level: .debug, category: category, file: file, fnc: fnc, line: line)
    }

}

extension OSLogType {
    var description: String {
        switch self {
        case .default:
            return "Default"
        case .info:
            return "Info"
        case .debug:
            return "Debug"
        case .error:
            return "Error"
        case .fault:
            return "Fault"
        default:
            return "Unknown"
        }
    }
}
