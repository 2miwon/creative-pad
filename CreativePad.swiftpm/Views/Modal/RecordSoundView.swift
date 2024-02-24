import SwiftUI
import AudioToolbox
import CoreMedia

struct RecordSheetView: View {
    @EnvironmentObject var mic: MicRecorder
    @EnvironmentObject var masterSetting: SettingManager
    @ObservedObject var tracker: ButtonTracker
    @Binding var showRecordSheet: Bool

    func exitModal(){
        mic.isRecording = .off
        showRecordSheet = false
        tracker.unselect()
        tracker.renew()
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                
                HStack(alignment: .center, spacing: 4) {
                    if mic.isRecording == .on && !UIAccessibility.isVoiceOverRunning {
                        ForEach(mic.newSamples, id: \.id) { sample in
                            let adjustedValue = mic.adjustSampleHeight(value: sample.value)
                            Visualizer(value: adjustedValue)
                        }
                    }
                }
                .frame(maxWidth: geo.size.width, maxHeight: mic.isRecording == .on ? 100 : 0)
                .opacity(mic.isRecording == .on ? 1 : 0)
                
                HStack{
                    StopWatchView(time: mic.progressTimeRecording)
                    Text("/")
                    StopWatchView(time: 5)
                    
                }
                .frame(height: mic.isRecording == .on ? 20 : 0)
                .opacity(mic.isRecording == .on ? 1 : 0)
                .foregroundColor(Color.red)
                
                
                ZStack {
                    Circle()
                        .stroke(mic.isRecording == .on ? Color.red : Color.white, lineWidth: 3)
                        .frame(width: 85, height: 85)
                    recordButton()
                        .frame(width: 70, height: 70)
                        .scaleEffect(mic.isRecording == .on ? 0.5 : 1)
                        .foregroundColor(Color.red)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if mic.isRecording == .on {
                                    if let button = tracker.selectedButton {
                                        button.randomColor()
                                    }
                                    exitModal()
                                } else {
                                    mic.isRecording = .on
                                }
                                mic.startRecording(countSamples: Int(geo.size.width))
                            }
                        }
                        .accessibilityLabel("Record button")
                    
                }
                .accessibilityElement(children: .contain)
                .frame(maxHeight: .infinity)
            }
            .accessibilityAction(.magicTap) {
                if mic.isRecording == .on {
                    mic.isRecording = .off
                    showRecordSheet = false
                } else {
                    mic.isRecording = .on
                }
                mic.startRecording(countSamples: Int(geo.size.width*0.2))
            }
            .onReceive(NotificationCenter.default.publisher(for: .progressTimeRecordingChanged)) { _ in
                if self.mic.progressTimeRecording > 5.0 {
                    self.mic.stopRecording()
                    if !masterSetting.autoSave {
                        tracker.selectedButton?.deleteFile()
                    } else {
                        tracker.selectedButton?.randomColor()
                    }
                    self.exitModal()
                }
            }
            .background(Color.CustomGray)

        }
        .overlay(alignment: .topTrailing) {
            Button {
                tracker.selectedButton?.deleteFile()
                exitModal()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.white)
            } 
            .padding()
        }
    }
    
    
    @ViewBuilder
    private func recordButton()-> some View {
        if mic.isRecording == .on {
            RoundedRectangle(cornerRadius: 10)
        } else {
            Circle()
        }
    }
}

struct RecordSheetView_Previews: PreviewProvider {
    static var previews: some View {
        RecordSheetView(tracker: ButtonTracker(num: 36), showRecordSheet: .constant(false))
            .environmentObject(MicRecorder(tracker: ButtonTracker(num: 36)))
            .environmentObject(SettingManager())
            .background(.black)
    }
}

#Preview {
    RecordSheetView_Previews.previews
}
