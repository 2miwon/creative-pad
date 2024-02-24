import SwiftUI

struct PadButtonView: View {
    @EnvironmentObject var masterSetting : SettingManager
    @EnvironmentObject var tracker: ButtonTracker
    @State var isPlaying: Bool = false
    @State var isAnimating: Bool = false
    let buttonAttribute: PadButton
    
    init(buttonObj button: PadButton) {
        self.buttonAttribute = button
    }
    
    var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 15.0)
                    .aspectRatio(1.0, contentMode: ContentMode.fit)
                    .foregroundColor(buttonAttribute.selected ? .white : buttonAttribute.color)
                    .shadow(color: buttonAttribute.exist ? buttonAttribute.color : .clear, radius: 15, x: 0, y: 0)
                if !buttonAttribute.exist {
                    Image(systemName: "plus.square.fill")
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.white)
                        .padding(25)
                        .opacity(0.5)
                }
            }
        }
//    }
}

#Preview {
    PadButtonView(buttonObj: PadButton(index: 99))
        .environmentObject(ButtonTracker(num: 36))
}
