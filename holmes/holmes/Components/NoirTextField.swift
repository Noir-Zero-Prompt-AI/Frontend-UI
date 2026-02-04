import SwiftUI

struct NoirTextField: View {
    @Binding var text: String
    let placeholder: String
    let fontSize: CGFloat
    @FocusState private var isFocused: Bool
    
    init(_ placeholder: String, text: Binding<String>, fontSize: CGFloat = 48) {
        self.placeholder = placeholder
        self._text = text
        self.fontSize = fontSize
    }
    
    var body: some View {
        ZStack {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: fontSize, weight: .light))
                    .foregroundColor(NoirColors.fogGray.opacity(0.5))
            }
            
            TextField("", text: $text)
                .font(.system(size: fontSize, weight: .light))
                .foregroundColor(NoirColors.paperWhite)
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .focused($isFocused)
        }
        .onAppear {
            isFocused = true
        }
    }
}

struct NoirSearchField: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(NoirColors.fogGray)
            
            TextField(placeholder, text: $text)
                .font(NoirFonts.body())
                .foregroundColor(NoirColors.paperWhite)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(NoirColors.fogGray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(NoirColors.smokeGray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        
        VStack(spacing: 24) {
            NoirTextField("Glass", text: .constant(""))
            NoirSearchField(text: .constant(""), placeholder: "Search...")
        }
        .padding(40)
    }
    .frame(width: 600, height: 300)
}
