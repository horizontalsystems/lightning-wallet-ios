import Foundation
import GRPC
import RxSwift
import NIO

class WalletUnlocker {
    class UnlockingException: Error {}
    
    private let unlockWaitTime: TimeInterval = 30 // seconds
    private let connection: LndNioConnection
    private var unlockFinishTime: TimeInterval?
    
    init(connection: LndNioConnection) {
        self.connection = connection
    }

    func startUnlock(request: Lnrpc_UnlockWalletRequest) -> Single<Void> {
        connection.walletUnlockerUnaryCall() { (client) -> EventLoopFuture<Lnrpc_UnlockWalletResponse> in
            client.unlockWallet(request).response
        }
        .map { _ in Void() }
        .do(
            afterSuccess: { [weak self] _ in
                self?.unlockFinishTime = Date().timeIntervalSince1970
            },
            onError: { [weak self] _ in
                self?.unlockFinishTime = nil
            }
        )
    }

    func isUnlocking() -> Bool {
        if let time = unlockFinishTime {
            return time + unlockWaitTime > Date().timeIntervalSince1970
        }

        return false
    }
}
