import SwiftUI

struct ContextCard: View {
    let context: DetectedContext
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: context.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(NoirColors.fogGray)
                
                Text("Context Detected")
                    .font(NoirFonts.caption())
                    .foregroundColor(NoirColors.fogGray)
            }
            
            Text(context.description)
                .font(NoirFonts.body())
                .foregroundColor(NoirColors.paperWhite)
                .lineLimit(2)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(NoirColors.smokeGray.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(NoirColors.glassStroke, lineWidth: 1)
        )
    }
}

struct DetectedContext {
    let icon: String
    let description: String
    let appName: String
    
    static let placeholder = DetectedContext(
        icon: "doc.text",
        description: "Working on \"Project Proposal.docx\" in Microsoft Word",
        appName: "Microsoft Word"
    )
}

#Preview {
    ZStack {
        NoirColors.charcoalGray.ignoresSafeArea()
        
        ContextCard(context: .placeholder)
            .padding()
    }
    .frame(width: 400, height: 200)
}
