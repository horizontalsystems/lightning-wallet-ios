import NIO
import RxSwift

extension EventLoopFuture {
    func toSingle() -> Single<Value> {
        Single<Value>.create { emitter in
            self.whenSuccess { emitter(.success($0)) }
            self.whenFailure { emitter(.error($0)) }
            
            return Disposables.create()
        }
    }
}
