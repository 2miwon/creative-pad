import SwiftUI

struct TuneSection: View {
    @EnvironmentObject var masterSetting : SettingManager
    @EnvironmentObject var masterMic : Recorder
    @ObservedObject var tracker: ButtonTracker

    init(tracker: ButtonTracker) {
        self.tracker = tracker
    }
    
    var body: some View {
        VStack{
            if masterSetting.allRecording {
                RecordingView()
            } else if masterSetting.isFile {
                FileListView()
            } else if masterSetting.isEditing {
                EditView(tracker: tracker)
            } else if masterSetting.isSetting {
                SettingView()
            }
            HStack{
                Spacer()
//                Text("Made By Heewon Lim, South Korea")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .shadow(color: .white, radius: 1)
//                    .frame(alignment: .bottomTrailing)
//                    .lineLimit(1)
//                    .scaledToFill()
//                    .opacity(0.75)
            }.frame(alignment: .bottom)
        }
        .sheet(isPresented: $masterSetting.showEndSheet) {
            PlaybackSheetView(showEndSheet: $masterSetting.showEndSheet)
                .environmentObject(masterMic)
                .presentationDetents([.fraction(0.4)])
                .interactiveDismissDisabled()
        }
//        .background(Color(.systemGray5))
    }
}

struct TuneSection_Previews: PreviewProvider {
    static var previews: some View {
        TuneSection(tracker: ButtonTracker(num: 36))
            .environmentObject(Recorder())
            .environmentObject(SettingManager())
            .scaledToFit()
    }
}

#Preview {
    TuneSection_Previews.previews
}
