public struct LocalNodeCredentials {
    public let lndDirPath: String
    public let password: String

    public init(lndDirPath: String, password: String) {
        self.lndDirPath = lndDirPath
        self.password = password
    }

}

extension LocalNodeCredentials: Codable {
}

extension LocalNodeCredentials: CustomStringConvertible {

    public var description: String {
        "[lndUrl: \(lndDirPath); password: ***]"
    }

}
