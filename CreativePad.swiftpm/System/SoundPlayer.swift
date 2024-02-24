import Foundation
import SwiftUI
import AVFoundation

typealias SoundSource = String

extension String {
    
    var urlSound: URL? {
        let defaultURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        var resourceURL = defaultURL?.appendingPathComponent(self).appendingPathExtension("caf")

#if DEBUG
        if resourceURL == nil {
            for framework in Bundle.allFrameworks {
                resourceURL = framework.url(forResource: self, withExtension: "caf")
                
                if resourceURL != nil {
                    break
                }
            }
        }
#endif
        return resourceURL
    }
}

enum Pitch: Double, CaseIterable {
    case D_b = 100
    case D = 200
    case E_b = 300
    case E = 400
    case F = 500
    case G_b = 600
    case G = 700
    case A_b = 800
    case A = 900
    case B_b = 1000
    case B = 1100
    case C = 1200
}


class SoundPlayer: ObservableObject {
    var audioPlayer: AudioPlayer
    @Published var beatDelay: Double = 0
    
    init() {
        let engine = AVAudioEngine()
        self.audioPlayer = AudioPlayer(engine: engine)
    }
    
    init(engine: AVAudioEngine) {
        self.audioPlayer = AudioPlayer(engine: engine)
    }

    func playSound(_ sound: SoundSource, pitch: Double = 0, speed: Double = 1.0, volume: Float = 1.0, filter: AVAudioUnitDistortionPreset? = nil) {
        playSingleAudio(sound, pitch: pitch, speed: speed, volume: volume, filter: filter)
    }

    func playSingleAudio(_ sound: SoundSource, pitch: Double, speed: Double, volume: Float, filter: AVAudioUnitDistortionPreset?) {
        let node = AVAudioPlayerNode()
        let length = AudioPlayer.soundLength(sound, speed: speed)
        audioPlayer.playSound(sound, node: node, pitch: pitch, speed: speed, volume: volume, filter: filter, length: length)
        _ = Timer.scheduledTimer(withTimeInterval: length, repeats: false) { _ in
            self.stopLoop(node)
        }
    }
    
    func beatDelayCalc(isRecording: States) -> Double {
        if isRecording == .completed {
            return 0.0
        } else {
            return 2 - (Date.timeIntervalSinceReferenceDate * 100).truncatingRemainder(dividingBy: 200)/100
        }
    }
    
    func playLoop(_ sound: SoundSource, node: AVAudioPlayerNode, pitch: Double, speed: Double, volume: Float, filter: AVAudioUnitDistortionPreset?, isRecording: Binding<States>, isLooping: Binding<Bool>, loopingButtons: Binding<[AVAudioNode: Binding<Bool>]>) {
        let length = AudioPlayer.soundLength(sound, speed: speed)
        beatDelay = beatDelayCalc(isRecording: isRecording.wrappedValue)
        loopingButtons.wrappedValue[node] = isLooping
        DispatchQueue.main.asyncAfter(deadline: .now() + beatDelay) {
            if isLooping.wrappedValue && isRecording.wrappedValue != .completed {
                self.audioPlayer.playSound(sound, node: node, pitch: pitch, speed: speed, volume: volume, filter: filter, length: length)
            }
            let timerBlock: ((Timer) -> Void) = { [self] timer in
                if isRecording.wrappedValue == .completed || !isLooping.wrappedValue {
                    timer.invalidate()
                    isLooping.wrappedValue = false
                    loopingButtons.wrappedValue[node] = nil
                    self.stopLoop(node)
                }
            }
            let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: timerBlock)
            timerBlock(timer)
        }
    }
    
    func stopLoop(_ node: AVAudioPlayerNode) {
        node.stop()
        self.audioPlayer.removeNode(node: node)
    }
    
    func stopSound(){
        audioPlayer.stopEngine()
    }
    
    func stopAllSounds(loopingButtons: Binding<[AVAudioNode: Binding<Bool>]>) {
        audioPlayer.stopEngine()
        for isLooping in loopingButtons.wrappedValue.values {
            isLooping.wrappedValue = false
        }
        loopingButtons.wrappedValue.removeAll()
    }
}

