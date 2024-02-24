import SwiftUI

struct SideBar: View {
    @ObservedObject var tracker: ButtonTracker
    
    init(tracker: ButtonTracker){
        self.tracker = tracker
    }
    
    var body: some View {
        VStack(spacing: 50){
            PlayButton(tracker: tracker)
            ResetButton(tracker: tracker)
            MuteButton()
            RecordButton(tracker: tracker)
            ButtonSetting(tracker: tracker)
            MasterSetting()
            FileListButton()
//            HelpButton()
        }
        .padding(15)
        .scaledToFit()
        .background(.black)
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(tracker: ButtonTracker(num: 36))
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    SideBar_Previews.previews
}

