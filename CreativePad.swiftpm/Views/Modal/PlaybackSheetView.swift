import SwiftUI
import Foundation

func currentDateTimeString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMdd_HH:mm:ss"
    return formatter.string(from: Date())
}


struct PlaybackSheetView: View {
    @State var showAlert = false
    @Binding var showEndSheet: Bool
    @EnvironmentObject var masterMic: Recorder
    
    @State private var songTitle: String = currentDateTimeString()
    @AccessibilityFocusState private var textAccessibilityFocus: Bool

    var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    var body: some View {
        VStack(alignment: .center) {
            RecordingTitleView(songTitle: $songTitle, showEndSheet: $showEndSheet, url: url)
                .accessibilityElement(children: .combine)
                .accessibilityFocused($textAccessibilityFocus)
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 5)
                    .foregroundColor(Color(.systemGray5))
                    .opacity(0.6)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: playbackDisplayCalc(geo.size.width), height: 5)
                    .foregroundColor(Color.white)
            }
            .frame(height:5)
            
            HStack {
                StopWatchView(time: masterMic.progressTimePlayback)
                Spacer()
                StopWatchView(time: masterMic.progressTimePlayback-masterMic.progressTimeRecording)
            }
            .foregroundColor(Color.white)
            .frame(height: 15)
            
            Button {
                masterMic.playbackToggle()
            } label: {
                Image(systemName: masterMic.isPlaying == .on ? "pause.fill" : "play.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.white)
            }
            .frame(width: 20, height: 20)
            .padding(.bottom)
            .accessibilityLabel(masterMic.isPlaying == .on ? "Pause" : "Play")
        }
        .onAppear {
            masterMic.intializePlayer()
            
            textAccessibilityFocus = true
        }
        .accessibilityAction(.magicTap) {
            masterMic.playbackToggle()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
        .background(
            Color.CustomGray
                .ignoresSafeArea())
        .overlay(alignment: .bottomTrailing) {
            ShareLink(item: MusicURL(text: (songTitle) + Recorder.fileExtension).url) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.white)
            }
            .presentationDetents([.fraction(0.5), .large])
            .padding(.horizontal, 40)
            .padding(.vertical, 30)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                showAlert = true
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.white)
            }
            .alert("Are you done?", isPresented: $showAlert, actions: {
                Button("Delete", role: .destructive, action: {
                    masterMic.isRecording = .off
                    showEndSheet  = false
                    masterMic.player?.stop()
                    masterMic.isPlaying = .off
                })
            }, message: {
                Text("If you leave this screen your song will not be saved.")
            })
            .accessibilityLabel("Delete")
            .padding()
        }
    }
}

extension PlaybackSheetView {
    func playbackDisplayCalc(_ width: CGFloat) -> CGFloat {
        guard masterMic.progressTimeRecording != 0 else { return width }
        return CGFloat(Double(width) * (Double(masterMic.progressTimePlayback) / Double(masterMic.progressTimeRecording)))
    }
}

struct MusicURL {
    var text: String
    var url: URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(text) else {
            fatalError("not a valid URL")
        }
        return url
    }
}

struct RecordingTitleView: View {
    @Binding var songTitle: String
    @Binding var showEndSheet: Bool
    @EnvironmentObject var masterMic: Recorder
    var url: URL?
    var body: some View {
        ZStack(alignment: .trailingLastTextBaseline) {
            TextField("", text: $songTitle)
                .disabled(true)
                .padding()
                .font(.system(size: 17, weight: .semibold))
                .background(
                    Color.black
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                )
                .foregroundColor(Color.white)
                .padding(.bottom, 30)
            
            Button("Save") {
                if let url = self.url {
                    let newURL = url.appendingPathComponent(self.songTitle + ".caf")
                    do {
                        // Save file at newURL
                        // For example, if you want to save a string as a text file:
//                        try masterMic.recordingFile.write(to: newURL, atomically: true, encoding: .utf8)
                    } catch {
                        print("Error saving file: \(error.localizedDescription)")
                    }
                    showEndSheet  = false
                }
            }
            .padding(.trailing)
            .foregroundColor(.white)
        }
    }
}

struct PlaybackSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackSheetView(showEndSheet: .constant(false))
            .environmentObject(Recorder())
    }
}

#Preview {
    PlaybackSheetView_Previews.previews
}
