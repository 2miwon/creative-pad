import SwiftUI
import AVFoundation
import Foundation

class ButtonTracker : ObservableObject {
    @Published var buttons = [PadButton]()
    @Published var selectedButton: PadButton? = nil
    var col: Int
    
    init(num: Int){
        self.col = Int(sqrt(Double(num)))
        for ind in 0..<num {
            buttons.append(PadButton(index: ind))
        }
    }
    
    func renew(){
        for button in buttons{
            button.checkExist()
        }
    }
    
    func select(_ button: PadButton) {
        if self.selectedButton != nil{
            self.unselect()
        }
        self.selectedButton = button
        self.selectedButton?.selected = true
    }
    
    func unselect(){
        self.selectedButton?.selected = false
        self.selectedButton = nil
    }
    
    func allStop(){
        for button in buttons {
            button.soundPlayer.stopSound()
        }
    }
    
}

class PadButton : Identifiable, ObservableObject {
    
    let id:Int
    var soundSource: SoundSource
    @Published var exist: Bool = false
    @Published var selected: Bool = false
    var color: Color = .CustomLightGray
    var filter: AVAudioUnitDistortionPreset? = nil
    var volume: Float = 1.0
    var pitch: Double = 0
    var speed: Double = 1.0
    var fileURL: URL? = nil
    
    // let node = AVAudioPlayerNode()
    let soundPlayer = SoundPlayer(engine: Recorder.engine)
    @State var isLooping = false
    @State var isPlaying = false

    init(index: Int){
        self.id = index
        self.soundSource = "\(index)"
        if let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            fileURL = pathURL.appendingPathComponent("\(index).caf")
        }
        checkExist()
    }
    
    func checkExist(){
        if FileManager.default.fileExists(atPath: fileURL!.path) {
            exist = true
        } else {
            exist = false
        }
    }
    
    func deleteFile(){
        if FileManager.default.fileExists(atPath: fileURL!.path) {
            do {
                try FileManager.default.removeItem(at: fileURL!)
                exist = false
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func playSound(masterSetting: SettingManager){
        if FileManager.default.fileExists(atPath: fileURL!.path) {
            soundPlayer.playSound(soundSource, pitch: pitch, speed: speed, volume: masterSetting.isMute ? 0.0 : masterSetting.masterVolumn * volume, filter: filter)
        }
    }
    
    func randomColor(){
        color = Color.random()
    }

}


