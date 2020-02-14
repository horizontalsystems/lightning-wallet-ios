import UIKit
import AVFoundation
import SnapKit
import ThemeKit

class ScanQRController: ThemeViewController {
    weak var delegate: IScanQrCodeDelegate?

    private let qrView = ScanQRView()
    private var willAppear = false

    init(delegate: IScanQrCodeDelegate) {
        self.delegate = delegate

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(qrView)
        qrView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        qrView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        willAppear = true
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        qrView.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        willAppear = false
        UIView.animate(withDuration: 0.5) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        qrView.stop()
    }

    override var prefersStatusBarHidden: Bool {
        willAppear
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

}

extension ScanQRController: IScanQrCodeDelegate {

    func didScan(string: String) {
        delegate?.didScan(string: string)
        dismiss(animated: true)
    }

}
