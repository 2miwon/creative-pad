import SwiftUI

struct ContentView: View {
    @StateObject var tracker = ButtonTracker(num: 36)
    
    var body: some View {
        ZStack{
            Color(.black).ignoresSafeArea()
            VStack {
                HStack{
                    SideBar()
                    TuneSection(tracker: tracker)
                        .frame(width: 300)
                    PadView(tracker: tracker)
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
    }
}

#Preview {
    ContentView_Previews.previews
}
