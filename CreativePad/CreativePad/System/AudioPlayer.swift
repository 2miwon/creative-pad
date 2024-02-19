import Foundation
import AVFoundation
import SwiftUI

class AudioPlayer {
    var engine: AVAudioEngine
    var distortion: AVAudioUnitDistortion = AVAudioUnitDistortion()
    var isPreset: Bool
    
    init(engine: AVAudioEngine) {
        self.engine = engine
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            fatalError("Can’t set Audio Session category.")
        }
        isPreset = false
    }
    
    static func soundLength(_ sound: SoundSource, speed: Double) -> Double {
        guard let soundUrl = sound.urlSound else { return 0 }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            return audioPlayer.duration * (1/speed)
        } catch {
            print("error initializing AVAudioPlayer")
        }
        return 0
    }
    
    func playSound(_ sound: SoundSource, node audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode(), pitch: Double, speed: Double, volume: Float, filter: AVAudioUnitDistortionPreset?, length: Double) {
        DispatchQueue.main.async {
            let speedControl = AVAudioUnitVarispeed()
            let pitchControl = AVAudioUnitTimePitch()
            
            let soundBuffer = self.createBuffer(sound: sound)
            guard let buffer = soundBuffer else { return }
            
            pitchControl.pitch = Float(max(-2399, min(pitch, 2399)))
            speedControl.rate = Float(max(0.05, min(speed, 4.0)))
            audioPlayerNode.volume = volume
            
            self.addNode(node: audioPlayerNode, pitchControl: pitchControl, speedControl: speedControl, preset: filter)
            self.connectNode(node: audioPlayerNode, buffer: buffer, pitchControl: pitchControl, speedControl: speedControl)
            self.startEngine()
            
            audioPlayerNode.scheduleBuffer(buffer,
                                          at: nil,
                                          options: .loops,
                                          completionHandler: nil)
            audioPlayerNode.play()
       }
    }
    
    func removeNode(node: AVAudioNode) {
        engine.detach(node)
    }
    
    private func startEngine() {
        if !engine.isRunning {
            engine.prepare()
            do {
                try engine.start()
            } catch {
                fatalError("Could not start engine. Error: \(error).")
            }
        }
    }
    
    func stopEngine() {
        engine.stop()
    }
    
    private func createBuffer(sound: SoundSource) -> AVAudioPCMBuffer? {
        var res: AVAudioPCMBuffer?
        guard let url = sound.urlSound else { return res }
        do {
            let file = try AVAudioFile(forReading: url)
            res = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity:AVAudioFrameCount(file.length))
            if let _ = res {
                do {
                    try file.read(into: res!)
                } catch (let error) {
                    print("ERROR read file", error)
                }
            }

        } catch (let error) {
            print("ERROR file creation", error)
        }
        return res
    }
    
    private func addNode(node: AVAudioNode, pitchControl: AVAudioUnitTimePitch, speedControl: AVAudioUnitVarispeed, preset: AVAudioUnitDistortionPreset?) {
        engine.attach(node)
        engine.attach(pitchControl)
        engine.attach(speedControl)
        guard let preset = preset else {
            self.isPreset = false
            return
        }
        self.isPreset = true
        engine.attach(distortion)
        distortion.loadFactoryPreset(preset)
    }
    
    private func connectNode(node: AVAudioNode, buffer: AVAudioPCMBuffer?, pitchControl: AVAudioUnitTimePitch, speedControl: AVAudioUnitVarispeed) {
        guard isPreset else {
            engine.connect(node, to: pitchControl, format: buffer!.format)
            engine.connect(pitchControl, to: speedControl, format: buffer!.format)
            engine.connect(speedControl, to: engine.mainMixerNode, format: buffer!.format)
            return
        }
        engine.connect(node, to: pitchControl, format: buffer!.format)
        engine.connect(pitchControl, to: speedControl, format: buffer!.format)
        engine.connect(speedControl, to: distortion, format: buffer!.format)
        engine.connect(distortion, to: engine.mainMixerNode, format: buffer!.format)
    }
}
