import SwiftUI

struct NoirTextField: View {
    @Binding var text: String
    var placeholder: String = ""
    var fontSize: CGFloat = 16
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.4)))
            .font(.system(size: fontSize))
            .foregroundStyle(.white.opacity(0.9))
            .textFieldStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white.opacity(0.05))
            .clipShape(.rect(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        NoirTextField(text: .constant(""), placeholder: "Enter text...")
        NoirTextField(text: .constant("Hello, Grain"), placeholder: "Enter text...")
    }
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(NoirColors.charcoalGray)
}
