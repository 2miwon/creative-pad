import Foundation
import SwiftUI
import AVFoundation

struct SampleValue {
    var id: UUID { UUID() }
    let value: Float
}

enum States: String {
    case completed = "completed",
         on = "on",
         off = "off"
}

struct Visualizer: View {
    var value: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.red)
                .frame(width: 1, height: value)
                .accessibilityLabel("Bar height \(value)")
        }
    }
}

class Recorder: ObservableObject {
    static var engine = AVAudioEngine()
    static var fileExtension = ".caf"
    var pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    @Published var loopingButtons: [AVAudioNode: Binding<Bool>] = [:]

    //recording
    var recordingFile: AVAudioFile?
    @Published var isRecording: States = .off
    @Published var progressTimeRecording: TimeInterval = 0
    var timerRecording: Timer?
    var recordingStartTime: TimeInterval = 0
    
    //playback
    var player: AVAudioPlayer?
    @Published var isPlaying: States = .off
    @Published var progressTimePlayback: TimeInterval = 0
    var timerPlayback: Timer?
    var playbackStartTime: TimeInterval = 0
    var pausedTime: TimeInterval = 0
    
    //samples
    @Published var countSamples: Int = 100
    @Published var newSamples: [SampleValue]
    
    init() {
        self.newSamples = []
    }
    
    func startRecording(countSamples: Int) -> Bool {
        guard isRecording == .on else {
            stopRecording()
            isRecording = .completed
            return true
        }
        
        createRecordingFile()
        recordingStartTime = Date.timeIntervalSinceReferenceDate
        
        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
            self.newSamples = [SampleValue](repeating: SampleValue(value: -50), count: countSamples)
            self.countSamples = countSamples
            
            Recorder.engine.mainMixerNode.installTap(onBus: 0,
                                             bufferSize: 1024,
                                             format: Recorder.engine.mainMixerNode.outputFormat(forBus: 0)) { (buffer, time) -> Void in
                do {
                    try self.recordingFile?.write(from: buffer)
                } catch (let error) {
                    print("Error recording", error);
                }
                guard let channelData = buffer.floatChannelData else { return }
                let channelDataValue = channelData.pointee
                let channelDataValueArray = stride(
                    from: 0,
                    to: Int(buffer.frameLength),
                    by: buffer.stride)
                    .map { channelDataValue[$0] }
                
                let rms = self.calcRootMeanSquare(values: channelDataValueArray, n: buffer.frameLength)
                let dec = self.convertToDecibel(rms)
                let sampleHeight = self.calcPower(power: dec)
//                DispatchQueue.main.async {
//                    self.newSamples = self.shiftLeft()
//                    self.newSamples[self.countSamples-1] = SampleValue(value: sampleHeight)
//                }
            }

            timerRecording = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                self.progressTimeRecording = Date.timeIntervalSinceReferenceDate - self.recordingStartTime
            }
        }
        return false
    }
    
    func stopRecording() {
        Recorder.engine.mainMixerNode.removeTap(onBus: 0)
        guard let timer = timerRecording else {
            return
        }
        timer.invalidate()
    }
    
    private func createRecordingFile() {
        if let url = self.pathURL?
            .appendingPathComponent("Record")
            .appendingPathComponent(currentDateTimeString() + Recorder.fileExtension) {
            let format = Recorder.engine.outputNode.inputFormat(forBus: 0)
            do {
                self.recordingFile = try AVAudioFile(forWriting: url, settings:format.settings)
            } catch (let error) {
                print("Error creating recording file", error);
            }
        }
    }
    
    private func calcRootMeanSquare(values: [Float], n: AVAudioFrameCount) -> Float {
        let sum = values.map {
            return $0 * $0
          }
          .reduce(0, +)
        let res = sqrt(sum / Float(n))
        return res
    }
    
    private func convertToDecibel(_ value: Float) -> Float {
        return 20 * log10(value)
    }
    
    private func calcPower(power: Float) -> Float {
        guard power.isFinite else { return 0.0 }
        let minDb: Float = -80
        if power < minDb {
            return 0.0
        } else if power >= 1.0 {
            return 1.0
        } else {
            let scaledPower = (abs(minDb) - abs(power)) / abs(minDb)
            return scaledPower
        }
    }
    
    func adjustSampleHeight(value: Float) -> CGFloat {
        return CGFloat(max(1, value*80))
    }
    
    private func shiftLeft() -> Array<SampleValue> {
        let elementsToPutAtBeginning = Array(self.newSamples[1..<self.newSamples.count])
        return elementsToPutAtBeginning + Array(arrayLiteral: SampleValue(value: 0))
    }
    
    func intializePlayer() {
        guard let url = self.recordingFile?.url else { return }
        resetPlayback()
        do {
            self.player = try AVAudioPlayer(contentsOf:
                url)
            self.player?.prepareToPlay()
        } catch {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
    
    func playbackToggle() {
        if isPlaying == .off {
            isPlaying = .on
            player?.play()
        } else if isPlaying == .on {
            isPlaying = .off
            player?.pause()
        } else {
            player?.stop()
            resetPlayback()
            isPlaying = .on
            player?.play()
        }
        playbackTimer()
    }
    
    private func playbackTimer() {
        if isPlaying == .on {
            playbackStartTime = Date.timeIntervalSinceReferenceDate - pausedTime
            timerPlayback = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [self] _ in
                progressTimePlayback = Date.timeIntervalSinceReferenceDate - playbackStartTime
                
                if progressTimePlayback >= progressTimeRecording {
                    playbackComplete()
                }
            })
        } else {
            timerPlayback?.invalidate()
            pausedTime = progressTimePlayback
        }
    }
    
    private func resetPlayback() {
        progressTimePlayback = 0
        pausedTime = 0
    }
    
    private func playbackComplete() {
        timerPlayback?.invalidate()
        isPlaying = .completed
        progressTimePlayback = progressTimeRecording
    }
}

#Preview {
    Visualizer(value: 100)
}
