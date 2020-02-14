import Foundation

extension FileManager {
    class UnableToGetWalletDirector: Error {}

    public func walletDirectory() throws -> URL {
        guard let applicationSupportDirectory = urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            throw UnableToGetWalletDirector()
        }
        let url = applicationSupportDirectory.appendingPathComponent("lnd", isDirectory: true)
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        
        return url
    }
}
