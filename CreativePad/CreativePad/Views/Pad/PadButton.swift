import SwiftUI
import AVFoundation

class ButtonTracker : ObservableObject {
    @Published var buttons = [PadButton]()
    @Published var sellectedButton: PadButton? = nil
    var col: Int
    
    init(num: Int){
        self.col = Int(sqrt(Double(num)))
        for _ in 0..<num {
            buttons.append(PadButton())
        }
    }
}

class PadButton : Identifiable, ObservableObject {
    let id = UUID()
    var soundSource: SoundSource?
    var color: Color = .CustomLightGray
    var filter: AVAudioUnitDistortionPreset? = nil
    var volume: Float = 1.0
    var pitch: Double = 0.0
    var speed: Double = 1.0

    let node = AVAudioPlayerNode()
    @State var isLooping = false
    @State var isPlaying = false
    
    @Published var symbol: Symbol = Symbol(name: "plus.square.fill")
}


