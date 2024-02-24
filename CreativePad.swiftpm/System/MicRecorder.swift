import Foundation
import SwiftUI
import AVFoundation

extension Notification.Name {
    static let progressTimeRecordingChanged = Notification.Name("progressTimeRecordingChanged")
}

class MicRecorder: ObservableObject {
    static var micRecorder = AVAudioRecorder()
    var fileExtension = ".caf"
    var pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    @ObservedObject var tracker: ButtonTracker

    //recording
    var recordingFile: AVAudioFile?
    @Published var isRecording: States = .off
    @Published var progressTimeRecording: TimeInterval = 0 {
        didSet {
            NotificationCenter.default.post(name: .progressTimeRecordingChanged, object: nil)
        }
    }
    var timerRecording: Timer?
    var recordingStartTime: TimeInterval = 0

    //samples
    @Published var countSamples: Int = 100
    @Published var newSamples: [SampleValue]
    
    init(tracker: ButtonTracker){
        self.tracker = tracker
        self.newSamples = []
    }
    
    func startRecording(countSamples: Int) {
        guard isRecording == .on else {
            stopRecording()
            isRecording = .completed
            return
        }
        
        if let button = tracker.selectedButton {
            let fileURL = pathURL!.appendingPathComponent("\(button.id)\(fileExtension)")
            recordingStartTime = Date.timeIntervalSinceReferenceDate
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            startRecordingTimer()
            
//            DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
//                self.newSamples = [SampleValue](repeating: SampleValue(value: -50), count: countSamples)
//                self.countSamples = countSamples
//            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [])
                MicRecorder.micRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
                MicRecorder.micRecorder.prepareToRecord()
                MicRecorder.micRecorder.record()
                isRecording = .on
                
//                setupAudioTap(countSamples: countSamples)
            } catch {
                print("Error recording: \(error.localizedDescription)")
                stopRecording()
            }
        }
    }
    
    func stopRecording() {
        if MicRecorder.micRecorder.isRecording {
            MicRecorder.micRecorder.stop()
            isRecording = .completed
//            saveRecording()
        } else {
//            print("No recording in progress")
        }
    }
    
    private func setupAudioTap(countSamples: Int) {
        let audioEngine = AVAudioEngine()
        let audioInputNode = audioEngine.inputNode

        let format = audioInputNode.inputFormat(forBus: 0)
        audioInputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            buffer.frameLength = 1024
            let floatArray = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
            let rms = self.calcRootMeanSquare(values: floatArray, n: buffer.frameLength)
            let dec = self.convertToDecibel(rms)
            let sampleHeight = self.calcPower(power: dec)

            DispatchQueue.main.async {
                self.updateSampleValues(countSamples: countSamples, sampleHeight: sampleHeight)
            }
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
    }
    
    private func startRecordingTimer() {
        timerRecording = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.progressTimeRecording = Date.timeIntervalSinceReferenceDate - self.recordingStartTime
        }
    }

    private func updateSampleValues(countSamples: Int, sampleHeight: Float) {
        newSamples = shiftLeft()
        newSamples[countSamples-1] = SampleValue(value: sampleHeight)
    }

    func saveRecording() {
        let fileURL = pathURL!.appendingPathComponent("Untitled\(fileExtension)")
        if let button = tracker.selectedButton {
            let destinationURL = pathURL!.appendingPathComponent("\(button.id)\(fileExtension)")
            do {
    //            self.recordingFile = try AVAudioFile(forWriting: fileURL, settings:format.settings)
                try FileManager.default.moveItem(at: fileURL, to: destinationURL)
                isRecording = .off
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
}

func createDirectory() {
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let directoryURL = documentsURL.appendingPathComponent("Record")

    do {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        print("Directory created successfully at: \(directoryURL)")
    } catch {
        print("Error creating directory: \(error.localizedDescription)")
    }
}
