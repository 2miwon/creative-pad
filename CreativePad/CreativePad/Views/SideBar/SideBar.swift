import SwiftUI

struct SideBar: View {

    var body: some View {
        VStack(spacing: 50){
            PlayButton()
            ResetButton()
            MuteButton()
            RecordButton()
            ButtonSetting()
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
        SideBar()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    SideBar_Previews.previews
}

