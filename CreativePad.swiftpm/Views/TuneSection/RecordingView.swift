import SwiftUI
import AudioToolbox
import CoreMedia

struct RecordingView: View {
    @EnvironmentObject var masterMic: Recorder
    @EnvironmentObject var masterSetting: SettingManager
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                ZStack {
                    HStack(alignment: .center, spacing: 4) {
                        if masterMic.isRecording == .on && !UIAccessibility.isVoiceOverRunning {
                            ForEach(masterMic.newSamples, id: \.id) { sample in
                                let adjustedValue = masterMic.adjustSampleHeight(value: sample.value)
                                Visualizer(value: adjustedValue)
                            }
                        }
                    }
                    .frame(maxWidth: 300, maxHeight: masterMic.isRecording == .on ? 100 : 0)
                    .opacity(masterMic.isRecording == .on ? 1 : 0)
                    .foregroundColor(Color.red)
                    
                    StopWatchView(time: masterMic.progressTimeRecording)
                        .frame(height: masterMic.isRecording == .on ? 20 : 0)
                        .opacity(masterMic.isRecording == .on ? 1 : 0)
                        .foregroundColor(Color(.systemRed))
                }
                .frame(maxHeight: .infinity)
            }
        }
    }
}


struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView()
            .environmentObject(Recorder())
            .environmentObject(SettingManager())
    }
}

#Preview {
    RecordingView_Previews.previews
}
