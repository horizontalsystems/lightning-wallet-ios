import LightningKit

class LightningKitManager {
    private(set) var currentKit: LightningKit.Kit?

    func loadKit(connection: LightningConnection) {
        switch connection {
        case .local: ()
        case .remote(let credentials):
            currentKit = try? LightningKit.Kit.remote(rpcCredentials: credentials)
        }
    }

    func unloadKit() {
        currentKit = nil
    }

}
