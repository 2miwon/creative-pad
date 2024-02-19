import SwiftUI

struct SettingView: View {
    @EnvironmentObject var masterSetting: SettingManager
    
    var body: some View {
        VStack{
            Text("()")
            Text("()")
            Text("()")
        }
        .background(.blue)
            
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(SettingManager())
            .scaledToFit()
    }
}

#Preview {
    SettingView_Previews.previews
}
