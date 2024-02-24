import SwiftUI

struct FileListButton: View {
    @EnvironmentObject var masterSetting : SettingManager

    var body: some View {
        Button{
            if available() {
                withAnimation(nil){
                    masterSetting.isSetting = false
                    masterSetting.isEditing = false
                    masterSetting.isFile.toggle()
                }
            }
        } label: {
            Image(systemName: "recordingtape.circle")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(available() ? .white : .CustomGray)
                .font(.system(size: 60, weight: .bold))
                .shadow(color: masterSetting.isFile ? .white : .clear, radius: 20, x: 0, y: 0)
        }
        
    }
    
    func available() -> Bool {
        return
            !masterSetting.allRecording
    }
}

struct FileListButton_Previews: PreviewProvider {
    static var previews: some View {
        FileListButton()
            .background(.black)
            .environmentObject(SettingManager())
    }
}

#Preview {
    FileListButton_Previews.previews
}
