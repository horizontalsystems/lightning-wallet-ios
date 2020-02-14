import UIKit
import AVFoundation
import UIExtensions

class ScanQRView: UIView {
    private static let sideMargin: CGFloat = CGFloat.margin6x

    weak var delegate: IScanQrCodeDelegate?

    private var captureSession: AVCaptureSession!
    private var metadataOutput: AVCaptureMetadataOutput?
    private let previewLayer: AVCaptureVideoPreviewLayer

    private let blurView = ScanQRBlurView(sideMargin: ScanQRView.sideMargin)
    private let alertView = ScanQrAlertView()

    private var initiallySetUp = false

    override var bounds: CGRect {
        didSet {
            previewLayer.frame = layer.bounds
        }
    }

    init() {
        captureSession = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        super.init(frame: .zero)

        previewLayer.frame = layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        layer.addSublayer(previewLayer)

        addSubview(blurView)
        blurView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }

        addSubview(alertView)
        alertView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.leading.trailing.equalToSuperview().inset(24)
            maker.height.equalTo(alertView.snp.width)
        }
        alertView.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialSetup() {
        do {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
                failed()
                return
            }
            let videoInput: AVCaptureDeviceInput

            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            guard captureSession.canAddInput(videoInput) else {
                failed()
                return
            }
            captureSession.addInput(videoInput)

            let metadataOutput = AVCaptureMetadataOutput()
            self.metadataOutput = metadataOutput
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr]
                updateRectOfInterest()
            } else {
                failed()
            }
        } catch {
        }
    }

    private func updateRectOfInterest() {
        guard !width.isZero && !height.isZero else {
            return
        }

        let left = ScanQRView.sideMargin / width
        let rectWidth = width - 2 * ScanQRView.sideMargin
        let top = ((height - rectWidth) / 2) / height

        metadataOutput?.rectOfInterest = CGRect(x: top, y: left, width: rectWidth / height, height: rectWidth / width)
    }

    private func failed() {
        captureSession = nil
        showAlert(title: "access_camera.not_supported".localized)
    }

    private func showAlert(title: String, actionText: String? = nil, action: (() -> ())? = nil) {
        alertView.isHidden = false
        alertView.bind(title: title, actionTitle: actionText, action: action)
    }

    func start() {
        if let captureSession = captureSession, !captureSession.isRunning {
            captureSession.startRunning()
        }

        if !initiallySetUp {
            initiallySetUp = true

            PermissionsHelper.performWithCameraPermission { [weak self] success in
                if success {
                    self?.initialSetup()
                } else {
                    self?.showAlert(title: "access_camera.message".localized, actionText: "access_camera.settings".localized) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
    }

    func stop() {
        if let captureSession = captureSession, captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

}

extension ScanQRView: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first,
           let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
           let stringValue = readableObject.stringValue {

            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didScan(string: stringValue)
        }
    }

}
