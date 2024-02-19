import SwiftUI

struct PadButtonView: View {
    @State var isPlaying: Bool = false
    @State var isAnimating: Bool = false
    let button: PadButton
    
    init(buttonObj button: PadButton) {
        self.button = button
    }
    
    var body: some View {
        Button {
            if button.soundSource == nil {
                
            }
        } label: {
            ZStack{
                
                RoundedRectangle(cornerRadius: 15.0)
                    .aspectRatio(1.0, contentMode: ContentMode.fit)
                    .foregroundColor(.CustomLightGray)
                    .shadow(color: button.soundSource != nil ? button.color : .clear, radius: 10, x: 0, y: 0)
                if button.soundSource == nil {
                    Image(systemName: button.symbol.name)
                        .resizable()
                        .scaledToFit()
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.white)
                        .padding(25)
                        .opacity(0.5)
                }
            }
//            .animation(<#T##animation: Animation?##Animation?#>)
        }
        .padding(5)
    }
}

#Preview {
    PadButtonView(buttonObj: PadButton())
}
