public enum NodeStatus {
    case connecting
    case locked
    case unlocking
    case syncing
    case running
    case error(_ error: Error)
}

extension NodeStatus: Equatable {
    public static func == (lhs: NodeStatus, rhs: NodeStatus) -> Bool {
        switch (lhs, rhs) {
        case (.connecting, .connecting), (.locked, .locked), (.unlocking, .unlocking), (.syncing, .syncing), (.running, .running), (.error, .error): return true
        default: return false
        }
    }
}
