import AVFoundation

class PermissionManager : ObservableObject {
    @Published var permissionGranted = false
    
    /**
     * 오디오 권한을  요청합니다.
     */
    func requestAudioPermission(){
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
            if granted {
                print("Audio: Permissioned")
            } else {
                print("Audio: Permission denied")
            }
        })
    }
    
}
