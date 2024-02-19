import AVFoundation
import SwiftUI
import AudioToolbox
import CoreMedia

struct RecordButton: View {
    @EnvironmentObject var masterSetting : SettingManager
    @EnvironmentObject var masterMic: Recorder

    var body: some View {
        Button{
            if available() {
                withAnimation(nil){
                    toggleMic()
                    if masterSetting.allRecording {
                        masterSetting.isPausing = false
                        masterSetting.isMute = false
                        masterSetting.isFile = false
                    } else {
                        
                    }
                }
            }
        } label: {
            Image(systemName: masterSetting.allRecording ? "stop.circle" : "record.circle")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(available() ? Color(.systemRed) : .CustomGray)
                .font(.system(size: 60, weight: .black))
                .shadow(color: masterSetting.allRecording ? Color(.systemRed) : .clear, radius: 20, x: 0, y: 0)
        }
    }
    
    func available() -> Bool {
        return
            !masterSetting.isEditing &&
            !masterSetting.isSetting &&
            !masterSetting.isFile
    }
    
    func toggleMic(){
        if masterMic.isRecording == .on {
            masterMic.isRecording = .off
            masterSetting.showEndSheet = true
        } else {
            masterMic.isRecording = .on
        }
        masterSetting.allRecording = !masterMic.startRecording(countSamples: 0)
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        RecordButton()
            .background(.black)
            .environmentObject(SettingManager())
            .environmentObject(Recorder())
        }
}

#Preview {
    RecordButton_Previews.previews
}
