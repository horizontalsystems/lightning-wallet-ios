import RxSwift
import LightningKit

class ChannelsInteractor {
    weak var delegate: IChannelsInteractorDelegate?

    private let lightningKit: LightningKit.Kit

    private let disposeBag = DisposeBag()

    init(lightningKit: LightningKit.Kit) {
        self.lightningKit = lightningKit
    }

}

extension ChannelsInteractor: IChannelsInteractor {

    func fetchOpenChannels() {
        lightningKit.channelsSingle
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] response in
                    self?.delegate?.didUpdate(openChannels: response.channels)
                })
                .disposed(by: disposeBag)
    }

    func fetchPendingChannels() {
        lightningKit.pendingChannelsSingle
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] response in
                    self?.delegate?.didUpdatePendingChannels(response: response)
                })
                .disposed(by: disposeBag)
    }

}
