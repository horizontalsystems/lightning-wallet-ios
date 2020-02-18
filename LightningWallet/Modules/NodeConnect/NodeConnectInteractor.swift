import UIKit
import LightningKit
import RxSwift

class NodeConnectInteractor {
    weak var delegate: INodeConnectInteractorDelegate?

    private let disposeBag = DisposeBag()
}

extension NodeConnectInteractor: INodeConnectInteractor {

    func validate(credentials: RpcCredentials) {
        LightningKit.Kit.validateRemoteConnection(rpcCredentials: credentials)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] in
                    self?.delegate?.didValidateCredentials()
                }, onError: { [weak self] error in
                    self?.delegate?.didFailToValidateCredentials(error: error)
                })
                .disposed(by: disposeBag)
    }

}
