import SwiftUI

struct HelpButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "questionmark.circle.fill")
                .resizable()
                .scaledToFit()
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    HelpButton()
        .background(.black)
}
