import Foundation

public struct RpcCredentials {
    public let host: String
    public let port: Int
    public let certificate: String
    public let macaroon: String

    public init(host: String, port: Int, certificate: String, macaroon: String) {
        self.host = host
        self.port = port
        self.certificate = certificate
        self.macaroon = macaroon
    }

    public init?(lndConnectUrlString: String) {
        let string = lndConnectUrlString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: string) else { return nil }
        self.init(lndConnectUrl: url)
    }

    public init?(lndConnectUrl: URL) {
        guard
            let queryParameters = lndConnectUrl.queryParameters,
            let host = lndConnectUrl.host,
            let port = lndConnectUrl.port,
            let macaroonString = queryParameters["macaroon"]?.base64UrlToBase64().base64ToHex(),
            let certificateString = queryParameters["cert"]?.base64UrlToBase64()
            else { return nil }

        self.init(host: host, port: port, certificate: Pem(key: certificateString).string, macaroon: macaroonString)
    }

}

extension RpcCredentials: Codable {
}

extension RpcCredentials: CustomStringConvertible {

    public var description: String {
        "[host: \(host); port: \(port); certificate: \(certificate.count) char(s); macaroon: \(macaroon.count) char(s)]"
    }

}

fileprivate extension String {
    func separate(every: Int, with separator: String) -> String {
        let result = stride(from: 0, to: count, by: every)
            .map { Array(Array(self)[$0..<min($0 + every, count)]) }
            .joined(separator: separator)
        return String(result)
    }

    func base64ToHex() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return data.hex
    }

    func base64UrlToBase64() -> String {
        var base64 = self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        if base64.count % 4 != 0 {
            base64.append(String(repeating: "=", count: 4 - base64.count % 4))
        }

        return base64
    }
}

fileprivate extension URL {
    var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems
            else { return nil }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}

fileprivate class Pem {
    private let prefix = "-----BEGIN CERTIFICATE-----"
    private let suffix = "-----END CERTIFICATE-----"
    let string: String

    init(key: String) {
        if key.hasPrefix(prefix) {
            string = key
        } else {
            string = "\(prefix)\n\(key.separate(every: 64, with: "\n"))\n\(suffix)\n"
        }
    }
}
