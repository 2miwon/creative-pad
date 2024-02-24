import Foundation

class SettingManager: ObservableObject {
    @Published var isPausing: Bool = false
    @Published var allRecording: Bool = false
    @Published var isRecording: Bool = false
    @Published var isEditing: Bool = false
    @Published var isSetting: Bool = false
    @Published var isMute: Bool = false
    @Published var isFile: Bool = false
    @Published var autoSave: Bool = true
    
    @Published var masterVolumn: Float = 1.0
    
    @Published var widthTuneSection: Double? = nil
    @Published var showEndSheet = false
    @Published var showRecordSheet = false
}
