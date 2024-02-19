import SwiftUI

struct PlayButton: View {
    @EnvironmentObject var masterSetting : SettingManager
    
    var body: some View {
        Button{
            if available() {
                withAnimation(nil){
                    masterSetting.isPausing.toggle()
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
        PlayButton()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    PlayButton_Previews.previews
}
