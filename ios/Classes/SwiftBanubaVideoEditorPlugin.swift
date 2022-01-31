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
            token: "tpdip+jPYuoguW94XotISzRKfEC8pkAjGbiOTzWJ/U+FpF7BtX8xJm/TUo2/T6w/suEfPljuKbEdAmPNCSbyXaIkioqXLqSfOudmV+7GlDgR1pQsd3K1z3D7hl+P1/OKDEHkL5AT7NhDhQyAGmxODHO43gdMRb0A0oezycyZzBByfmYuFiKrZlOFNUHeBIwmB7EuIfk+7dfAaYa2ihWGO1Noc0/kAu67DSTSkSzd9Bu7BLF7zp3zOs4QrtQJtGOkjm0ho/RRlYOUj/pn493rufo+3CULwFdEwPv145hY0xYbZHTs3LFiQKRWsWTr3JANJB/Ta7v6z1Yg0472Ay/4PeRasILPnmNWdEp+vlujkDBtfFQe0mWiqVdMgKgnD0czVpVfqgS3mmmx4puFZhMFKqEz7peaL47xRwZrr6UbP48pm0dSyhaHz5PWTExwEs+KZgeD4foVVsrxKZJmxxV3koDivEl29/yr8SdcO6V+txy36Ax9Q3fEcDkim55L4QhLNyhEAoZ7/BTnQqrZ3zrKKLXQfj5kaRoAYMYWVADmWwayX5qV+lm28HiUvRe7vBUVUfYo5DjFp16bKYa5YWsYhiUWf5wiIZz1MnAZCexz2eOuBicuytcoHq8GvnPvcx5MZ2qSqPlOHznK0K5OjzhvpN3jxMkxlDwTNPBF26xe+pVzbBN1IAxzD0gUPie3ezaCH7SZT+TjsKYNWu1aBvNj",
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
        var config = VideoEditorConfig()
        config.videoDurationConfiguration.maximumVideoDuration = 180.0
        config.videoDurationConfiguration.minimumVideoDuration = 10.0
        return config
    }
    
    
    func completeWithError(code: String, message: String) {
        guard let completion = _completion else { return; }
        
        completion(nil,FlutterError(code: code, message: message, details: nil))
        clearCompletion()
        
    }
    
    func completeWithSuccess(videoPath: String?, coverPath: String?) {
        guard let completion = _completion else { return; }
        let result = FLTVideoEditResult.init();
        result.filePath = videoPath
        result.coverPath = coverPath
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
            self.completeWithSuccess(videoPath:nil, coverPath:nil)
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
        var coverURL : URL?
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
                    if let data = exportCoverImages?.coverImage?.pngData() ?? exportCoverImages?.coverImage?.jpegData(compressionQuality: 1) {
                        do {
                            let coverPath = UUID().uuidString
                            coverURL = manager.temporaryDirectory.appendingPathComponent("\(coverPath)\(exportCoverImages?.coverImage?.pngData() != nil ? ".png" : ".jpg")")
                            
                            try  data.write(to: coverURL!)
                        } catch {
                            self.completeWithError(code: "EXPORT", message: "Unable to Write \(String(describing: coverURL)) Cover Data to Disk")
                            return
                        }
                    }
                    
                    self.completeWithSuccess(videoPath:videoURL.path, coverPath: coverURL?.path)
                } else if let error_data = error {
                    self.completeWithError(code: "EXPORT", message: "Failed to export created video: \(error_data)")
                }
                self.videoEditorSDK = nil
            }
        })
    }
}
