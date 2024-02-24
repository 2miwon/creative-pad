import SwiftUI
import Foundation

struct PadView: View {
    @ObservedObject var tracker: ButtonTracker
    @EnvironmentObject var masterSetting : SettingManager
    
    private var columns = Array(repeating: GridItem(.flexible(minimum: 0, maximum: 400), spacing: 0, alignment: .center), count: 6)
    
    init(tracker: ButtonTracker) {
        self.tracker = tracker
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(tracker.buttons) { button in
                Button {
                    if masterSetting.isEditing {
                        if button.exist{
                            if button.selected {
                                tracker.unselect()
                            } else {
                                tracker.select(button)
                            }
                        }
                    } else {
                        if button.exist{
                            if !masterSetting.isPausing {
                                button.playSound(masterSetting: masterSetting)
                            }
                        } else {
                            masterSetting.showRecordSheet = true
                            tracker.select(button)
                        }
                    }
                } label: {
                    PadButtonView(buttonObj: button)
                }
                .padding(5)
            }
        }
        .sheet(isPresented: $masterSetting.showRecordSheet) {
                    RecordSheetView(tracker: tracker, showRecordSheet: $masterSetting.showRecordSheet)
                        .presentationDetents([.fraction(0.4)])
                        .interactiveDismissDisabled()
                }
        .background(.customGray)
    }
}


struct Pad_Previews: PreviewProvider {
    static var previews: some View {
        let tracker = ButtonTracker(num: 36)
        PadView(tracker: tracker)
            .environmentObject(SettingManager())
            .environmentObject(Recorder())
            .environmentObject(MicRecorder(tracker: tracker))
            .scaledToFit()
    }
}

#Preview {
    Pad_Previews.previews
}

