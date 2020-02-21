import GRPC
import NIO
import NIOSSL
import NIOHPACK
import RxSwift

class LndNioConnection {
    private var connectivityManager: ConnectivityManager
    
    deinit {
        group.shutdownGracefully({_ in})
    }

    private let group: MultiThreadedEventLoopGroup
    let lightningClient: Lnrpc_LightningServiceClient
    let walletUnlockClient: Lnrpc_WalletUnlockerServiceClient
    
    init(rpcCredentials: RpcCredentials) throws {
        group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

        let certificateBytes: [UInt8] = Array(rpcCredentials.certificate.utf8)
        let certificate = try NIOSSLCertificate(bytes: certificateBytes, format: .pem)
        let tlsConfig = ClientConnection.Configuration.TLS(
            trustRoots: .certificates([certificate])
        )

        let callOptions = CallOptions(
            customMetadata: HPACKHeaders([("macaroon", rpcCredentials.macaroon)])
        )

        connectivityManager = ConnectivityManager()

        let config = ClientConnection.Configuration(
            target: .hostAndPort(rpcCredentials.host, rpcCredentials.port),
            eventLoopGroup: group,
            connectivityStateDelegate: connectivityManager,
            tls: tlsConfig
        )

        let connection = ClientConnection(configuration: config)

        lightningClient = Lnrpc_LightningServiceClient(connection: connection, defaultCallOptions: callOptions)
        walletUnlockClient = Lnrpc_WalletUnlockerServiceClient(connection: connection, defaultCallOptions: callOptions)
    }
    
    func walletUnlockerUnaryCall<T>(_ callFunction: @escaping (Lnrpc_WalletUnlockerServiceClient) -> EventLoopFuture<T>) -> Single<T> {
        connectivityManager.runIfConnected {
            callFunction(self.walletUnlockClient).toSingle()
        }
    }

    func unaryCall<T>(_ callFunction: @escaping (Lnrpc_LightningServiceClient) -> EventLoopFuture<T>) -> Single<T> {
        connectivityManager.runIfConnected {
            callFunction(self.lightningClient).toSingle()
        }
    }
    
    func serverStreamCall<A, T>(_ callFunction: @escaping (Lnrpc_LightningServiceClient, @escaping (T) -> Void) -> ServerStreamingCall<A, T>) -> Observable<T> {
        guard connectivityManager.isConnected else {
            return Observable.error(GRPCStatus(code: .unavailable, message: "Not connected to remote node"))
        }

        return Observable<T>.create { [weak self] emitter in
            guard let connection = self else {
                emitter.onCompleted()
                return Disposables.create()
            }
            
            let call = callFunction(connection.lightningClient) { response in
                emitter.onNext(response)
            }
            
            call.status.whenSuccess({ status in
                if status != .ok {
                    emitter.onError(status)
                }
                
            })
            
            call.status.whenComplete({ _ in emitter.onCompleted() })
            
            return Disposables.create()
        }
    }
}
