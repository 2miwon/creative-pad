import SwiftUI
import AudioToolbox
import CoreMedia

struct RecordSoundView: View {
    @EnvironmentObject var mic: Recorder
    
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
                   
                StopWatchView(time: mic.progressTimeRecording)
                    .frame(height: mic.isRecording == .on ? 20 : 0)
                    .opacity(mic.isRecording == .on ? 1 : 0)
                    .foregroundColor(Color.red)
                
                ZStack {
                    Circle()
                        .stroke(mic.isRecording == .on ? Color.red : Color.white, lineWidth: 3)
                        .frame(width: 50, height: 50)
                    recordButton()
                        .frame(width: 40, height: 40)
                        .scaleEffect(mic.isRecording == .on ? 0.5 : 1)
                        .foregroundColor(Color.red)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                if mic.isRecording == .on {
                                    mic.isRecording = .off
                                } else {
                                    mic.isRecording = .on
                                }
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
                } else {
                    mic.isRecording = .on
                }
            }
            .background(.customGray)
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

struct RecordSoundView_Previews: PreviewProvider {
    static var previews: some View {
        RecordSoundView()
            .environmentObject(Recorder())
            .background(.black)
    }
}

#Preview {
    RecordSoundView_Previews.previews
}
