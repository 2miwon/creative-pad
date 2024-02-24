import SwiftUI

struct ContentView: View {
    @EnvironmentObject var masterSetting: SettingManager
    @StateObject var tracker = ButtonTracker(num: 36)
    
    var body: some View {
        ZStack{
            Color(.black).ignoresSafeArea()
            VStack {
                HStack{
//                    if let button = tracker.selectedButton {
//                        Text(String(describing: button.fileURL))
//                            .foregroundColor(Color.red)
//                    } else {
//                        Text("fuck")
//                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
//                    }
                    SideBar(tracker: tracker)
                    TuneSection(tracker: tracker)
                        .frame(width: 300)
                    PadView(tracker: tracker)
                        .environmentObject(MicRecorder(tracker: tracker))
                        .environmentObject(SoundPlayer())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .scaledToFill()
    //                    .padding(5)
                }
            }
            .background(.black)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SettingManager())
            .environmentObject(Recorder())
            .environmentObject(MicRecorder(tracker: ButtonTracker(num: 36)))
    }
}

#Preview {
    ContentView_Previews.previews
}
