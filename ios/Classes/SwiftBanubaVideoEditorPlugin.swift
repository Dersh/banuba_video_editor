import Flutter
import UIKit
import BanubaVideoEditorSDK
import VideoEditor

typealias Completion = (FLTVideoEditResult?, FlutterError?) -> Void


public class SwiftBanubaVideoEditorPlugin: NSObject, FlutterPlugin, FLTBanubaVideoEditorApi {
    private var _completion: Completion?
    private var videoEditorSDK: BanubaVideoEditor?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        FLTBanubaVideoEditorApiSetup(registrar.messenger(), SwiftBanubaVideoEditorPlugin())
    }
    
    public func startEditorFromCamera(completion: @escaping (FLTVideoEditResult?, FlutterError?) -> Void) {
        guard  let controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController else {completeWithError(code: "CONTROLLER", message: "Failed to get rootController"); return;}
        if _completion != nil {
            completion(nil,FlutterError(code: "ALREADY_ACTIVE", message: "Video editor is already active.", details: nil))
            return
        }
        
        _completion = completion
        let config = createVideoEditorConfiguration()
        videoEditorSDK = BanubaVideoEditor(
            token: "yZSWWbe0r/jv7Pd4MZesKTRKfEC8pkAjGbiOTzWJ/U+FpF7BtX8xJm/TUo2/T6w/suEfPljuKbEdAmPNCSbyXaIkioqXLqSfOudmV+7GlDgR1pQsd3K1z3D7hl+P1/OKDEHkL5AT7NhDhQ+AGmxODHO43gdMRb0A0pm9j8mB6i11fGgpWjqgbU+Lbl3aF6EcDLtoOfE879feZ8m0iyS8MFkua0f5DKi+FQLomiab7BO4SOB1mJvoMsNetpoPs3PtgCwupvhaj6ijiOZg+dLnsb0mvSN6zgNX9sz6qoAZilMVfWz95IB7YopK6nzzla8TLDDRQZX+9Eo497D2C12OAehKmKjBzAphcX9urkfLnj4scFce22O1nHhDjb0qEk0jB41H7gO6hX/27JXUYBYFNbw16aKUI+jpX1BtqLVcMYF4nUJS1QuByKLzeHplA9yZcxqF4LYNTpz3LoIhyRsmlIXio1Rw8N+SyFVEI/N4sAzw5gIsRXLEbyQknKx/8AVNGhhZGoJt60T/Wvzf2CqNJruCfgtHaRkGd8FHTGGMWgevQpuX5ES382eJvBOjoRUXTuso4SDYp1qCNIW6fHYbhzoLfJs7PJ3wK20YDvdu2Ou6GyYn38ooH7MbvnPybh5PeXeSr+NTHz/Rza1MkyVspMP+x88piT8XLu5H2rFA+JdtcxB0PRNwDVYLPSSoZDWGB6uaSv38s6AXRe5dbNNjIQ==",
            configuration: config,
            externalViewControllerFactory: nil
        )
        videoEditorSDK?.delegate = self
        DispatchQueue.main.async {
            self.videoEditorSDK?.presentVideoEditor(
                from: controller,
                animated: true,
                completion: nil
            )
        }
    }
    
    private func createVideoEditorConfiguration() -> VideoEditorConfig {
        let config = VideoEditorConfig()
        // Do customization here
        return config
    }
    
    
    func completeWithError(code: String, message: String) {
        guard let completion = _completion else { return; }
        
        completion(nil,FlutterError(code: code, message: message, details: nil))
        clearCompletion()
        
    }
    
    func completeWithSuccess(videoPath: String?) {
        guard let completion = _completion else { return; }
        let result = FLTVideoEditResult.init();
        result.filepath = videoPath
        completion(result, nil)
        clearCompletion()
        
    }
    
    func clearCompletion() {
        _completion = nil
    }
    
}


// MARK: - BanubaVideoEditorSDKDelegate
extension SwiftBanubaVideoEditorPlugin: BanubaVideoEditorDelegate {
    public func videoEditorDidCancel(_ videoEditor: BanubaVideoEditor) {
        videoEditor.dismissVideoEditor(animated: true) {
            self.videoEditorSDK = nil
            self.completeWithSuccess(videoPath:nil)
        }
    }
    
    public func videoEditorDone(_ videoEditor: BanubaVideoEditor) {
        videoEditor.dismissVideoEditor(animated: true,completion: nil)
        exportVideo()
    }
    
    func exportVideo() {
        let manager = FileManager.default
        let filePath = UUID().uuidString
        let videoURL = manager.temporaryDirectory.appendingPathComponent("\(filePath).mov")
        if manager.fileExists(atPath: videoURL.path) {
            try? manager.removeItem(at: videoURL)
        }
        
        let exportConfiguration = ExportVideoConfiguration(
            fileURL: videoURL,
            quality: .videoConfiguration(ExportVideoInfo(resolution: ExportVideoInfo.Resolution.fullHd1080, useHEVCCodecIfPossible: true, frameRate: 60)),
            useHEVCCodecIfPossible: true,
            watermarkConfiguration: nil
        )
        
        let exportConfig = ExportConfiguration(
            videoConfigurations: [exportConfiguration],
            isCoverEnabled: true,
            gifSettings: GifSettings(duration: 0.3)
        )
        
        videoEditorSDK?.export(using: exportConfig, completion: { success, error, exportCoverImages in
            DispatchQueue.main.async {
                self.videoEditorSDK?.clearSessionData()
                if success {
                    self.completeWithSuccess(videoPath:videoURL.path)
                } else if let error_data = error {
                    self.completeWithError(code: "EXPORT", message: "Failed to export created video: \(error_data)")
                }
                self.videoEditorSDK = nil
            }
        })
    }
}
