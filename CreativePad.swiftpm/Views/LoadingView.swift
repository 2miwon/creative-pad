import SwiftUI

struct LoadingView: View {
    public var body: some View {
        VStack(spacing: 10) {
          ProgressView()
          Text("Loading")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .foregroundColor(.white)
      }
}

#Preview {
    LoadingView()
}
