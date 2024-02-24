import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var masterSetting : SettingManager
    @ObservedObject var tracker: ButtonTracker
    
    init(tracker: ButtonTracker){
        self.tracker = tracker
    }
    
    var body: some View {
        Button{
            if available() {
                withAnimation(nil){
                    masterSetting.isPausing.toggle()
                    if masterSetting.isPausing {
                        tracker.allStop()
                    }
                }
            }
        } label: {
            Image(systemName: masterSetting.isPausing ? "play.fill" : "pause.fill")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(available() ? .white : .CustomGray)
                .padding(5)
        }
        
    }
    
    func available() -> Bool {
        return
            !masterSetting.isEditing
    }
}

struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton(tracker: ButtonTracker(num: 36))
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    PlayButton_Previews.previews
}
