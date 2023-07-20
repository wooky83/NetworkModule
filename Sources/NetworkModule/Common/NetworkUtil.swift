import Foundation

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
