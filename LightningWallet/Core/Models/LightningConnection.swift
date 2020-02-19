import LightningKit

enum LightningConnection {
    case local
    case remote(credentials: RpcCredentials)
}

extension LightningConnection: Codable {

    private enum CodingKeys: String, CodingKey {
        case base, remoteRpcConfiguration
    }

    private enum Base: String, Codable {
        case local
        case remote
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)

        switch base {
        case .local:
            self = .local
        case .remote:
            let rpcCredentials = try container.decode(RpcCredentials.self, forKey: .remoteRpcConfiguration)
            self = .remote(credentials: rpcCredentials)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .local:
            try container.encode(Base.local, forKey: .base)
        case .remote(let rpcCredentials):
            try container.encode(Base.remote, forKey: .base)
            try container.encode(rpcCredentials, forKey: .remoteRpcConfiguration)
        }
    }
}
